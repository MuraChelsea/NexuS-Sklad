import 'package:flutter/foundation.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/offline_sync_issue.dart';
import '../../../core/network/transport_mapper.dart';
import '../../../core/storage/local_cache_store.dart';
import 'inventory_queue_store.dart';

@immutable
class InventoryWriteResult {
  const InventoryWriteResult({
    required this.queued,
    required this.item,
  });

  final bool queued;
  final MobileInventoryItem item;
}

@immutable
class InventoryStartResult {
  const InventoryStartResult({
    required this.queued,
    this.session,
  });

  final bool queued;
  final MobileInventorySession? session;
}

@immutable
class InventorySyncResult {
  const InventorySyncResult({
    required this.appliedCount,
    required this.pendingCount,
    this.blockingMessage,
    this.conflictCount = 0,
  });

  final int appliedCount;
  final int pendingCount;
  final String? blockingMessage;
  final int conflictCount;

  bool get hasConflict => conflictCount > 0;
}

class InventoryRepository {
  InventoryRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
    InventoryQueueStore? queueStore,
  }) : _queueStore =
            queueStore ?? InventoryQueueStore(cacheStore: cacheStore ?? LocalCacheStore.instance);

  final ApiClient _apiClient;
  final InventoryQueueStore _queueStore;

  Future<InventoryStartResult> start({
    required String accessToken,
  }) async {
    try {
      final session = await _sendStart(accessToken: accessToken);
      return InventoryStartResult(
        queued: false,
        session: session,
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.writePendingStart(
        PendingInventoryStart(createdAt: DateTime.now()),
      );
      return const InventoryStartResult(queued: true);
    }
  }

  Future<PendingInventoryStartView?> getPendingStart() async {
    final pending = await _queueStore.readPendingStart();
    if (pending == null) {
      return null;
    }

    return PendingInventoryStartView(createdAt: pending.createdAt);
  }

  Future<void> clearPendingStart() {
    return _queueStore.clearPendingStart();
  }

  Future<InventoryStartSyncResult> flushPendingStart({
    required String accessToken,
  }) async {
    final pending = await _queueStore.readPendingStart();
    if (pending == null) {
      return const InventoryStartSyncResult(
        applied: false,
        hasPending: false,
      );
    }

    try {
      final session = await _sendStart(accessToken: accessToken);
      await _queueStore.clearPendingStart();
      return InventoryStartSyncResult(
        applied: true,
        hasPending: false,
        session: session,
      );
    } on ApiException catch (error) {
      final issue = OfflineSyncIssue.fromApiException(error);
      return InventoryStartSyncResult(
        applied: false,
        hasPending: true,
        blockingMessage: issue.message,
        hasConflict: issue.isConflict,
      );
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      return const InventoryStartSyncResult(
        applied: false,
        hasPending: true,
      );
    }
  }

  Future<MobileInventorySession> getById({
    required String accessToken,
    required String inventoryId,
  }) async {
    final json = await _apiClient.get(
      '/v1/inventory/$inventoryId',
      accessToken: accessToken,
    );

    return ApiContract.item(
      json,
      module: 'inventory',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.InventorySession.fromJson,
        toDomain: MobileInventorySession.fromTransport,
      ),
    );
  }

  Future<MobileInventoryItem> updateItem({
    required String accessToken,
    required String inventoryId,
    required String itemId,
    required double actualQty,
  }) async {
    final json = await _apiClient.post(
      '/v1/inventory/$inventoryId/items/$itemId?_method=PATCH',
      accessToken: accessToken,
      body: generated.UpdateInventoryItemRequest(
        actualQty: actualQty,
      ).toJson(),
    );

    return ApiContract.item(
      json,
      module: 'inventory',
      action: 'update-item',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.InventoryItem.fromJson,
        toDomain: MobileInventoryItem.fromTransport,
      ),
    );
  }

  Future<InventoryWriteResult> patchItem({
    required String accessToken,
    required String inventoryId,
    required String itemId,
    required double actualQty,
    required MobileInventoryItem fallbackItem,
  }) async {
    try {
      final json = await _apiClient.patch(
        '/v1/inventory/$inventoryId/items/$itemId',
        accessToken: accessToken,
        body: generated.UpdateInventoryItemRequest(
          actualQty: actualQty,
        ).toJson(),
      );

      final item = ApiContract.item(
        json,
        module: 'inventory',
        action: 'update-item',
        decode: (payload) => mapTransport(
          payload,
          decodeTransport: generated.InventoryItem.fromJson,
          toDomain: MobileInventoryItem.fromTransport,
        ),
      );

      return InventoryWriteResult(
        queued: false,
        item: item,
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.enqueue(
        PendingInventoryItemUpdate(
          id: _newQueueId(),
          inventoryId: inventoryId,
          itemId: itemId,
          actualQty: actualQty,
          createdAt: DateTime.now(),
        ),
      );

      return InventoryWriteResult(
        queued: true,
        item: fallbackItem.copyWithActualQty(actualQty),
      );
    }
  }

  Future<int> getPendingCount({
    required String inventoryId,
  }) async {
    final items = await _queueStore.readAll();
    return items.where((item) => item.inventoryId == inventoryId).length;
  }

  Future<void> clearPendingItemUpdates({
    required String inventoryId,
  }) async {
    final items = await _queueStore.readAll();
    final remaining = items.where((item) => item.inventoryId != inventoryId).toList(growable: false);
    await _queueStore.writeAll(remaining);
  }

  Future<InventorySyncResult> flushPendingItemUpdates({
    required String accessToken,
    required String inventoryId,
  }) async {
    final items = await _queueStore.readAll();
    final forInventory = items.where((item) => item.inventoryId == inventoryId).toList(growable: false);
    if (forInventory.isEmpty) {
      return const InventorySyncResult(
        appliedCount: 0,
        pendingCount: 0,
      );
    }

    final remaining = <PendingInventoryItemUpdate>[];
    var appliedCount = 0;
    var conflictCount = 0;
    String? blockingMessage;
    var stop = false;

    for (final item in items) {
      if (item.inventoryId != inventoryId) {
        remaining.add(item);
        continue;
      }

      if (stop) {
        remaining.add(item);
        continue;
      }

      try {
        await _apiClient.patch(
          '/v1/inventory/${item.inventoryId}/items/${item.itemId}',
          accessToken: accessToken,
          body: generated.UpdateInventoryItemRequest(
            actualQty: item.actualQty,
          ).toJson(),
        );
        appliedCount += 1;
      } on ApiException catch (error) {
        final issue = OfflineSyncIssue.fromApiException(error);
        remaining.add(item);
        blockingMessage ??= issue.message;
        if (issue.isConflict) {
          conflictCount += 1;
        }
        stop = true;
      } catch (error) {
        if (!isOfflineQueueableError(error)) {
          rethrow;
        }
        remaining.add(item);
        stop = true;
      }
    }

    await _queueStore.writeAll(remaining);

    return InventorySyncResult(
      appliedCount: appliedCount,
      pendingCount: remaining.where((item) => item.inventoryId == inventoryId).length,
      blockingMessage: blockingMessage,
      conflictCount: conflictCount,
    );
  }

  Future<MobileInventorySession> finish({
    required String accessToken,
    required String inventoryId,
  }) async {
    final json = await _apiClient.post(
      '/v1/inventory/$inventoryId/finish',
      accessToken: accessToken,
      body: generated.FinishInventoryRequest().toJson(),
    );

    return ApiContract.item(
      json,
      module: 'inventory',
      action: 'finish',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.InventorySession.fromJson,
        toDomain: MobileInventorySession.fromTransport,
      ),
    );
  }

  Future<MobileInventorySession> _sendStart({
    required String accessToken,
  }) async {
    final json = await _apiClient.post(
      '/v1/inventory/start',
      accessToken: accessToken,
      body: generated.StartInventoryRequest().toJson(),
    );

    return ApiContract.item(
      json,
      module: 'inventory',
      action: 'start',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.InventorySession.fromJson,
        toDomain: MobileInventorySession.fromTransport,
      ),
    );
  }

  String _newQueueId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

@immutable
class InventoryStartSyncResult {
  const InventoryStartSyncResult({
    required this.applied,
    required this.hasPending,
    this.session,
    this.blockingMessage,
    this.hasConflict = false,
  });

  final bool applied;
  final bool hasPending;
  final MobileInventorySession? session;
  final String? blockingMessage;
  final bool hasConflict;
}

@immutable
class PendingInventoryStartView {
  const PendingInventoryStartView({
    required this.createdAt,
  });

  final DateTime createdAt;
}

class MobileInventorySession {
  const MobileInventorySession({
    required this.id,
    required this.status,
    required this.comment,
    required this.items,
  });

  final String id;
  final String status;
  final String? comment;
  final List<MobileInventoryItem> items;

  bool get isCompleted => status == 'COMPLETED';

  factory MobileInventorySession.fromTransport(generated.InventorySession transport) {
    return MobileInventorySession(
      id: transport.id,
      status: transport.status.value,
      comment: transport.comment,
      items: transport.items.map(MobileInventoryItem.fromTransport).toList(),
    );
  }

  MobileInventorySession copyWith({
    String? id,
    String? status,
    String? comment,
    List<MobileInventoryItem>? items,
  }) {
    return MobileInventorySession(
      id: id ?? this.id,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      items: items ?? this.items,
    );
  }
}

class MobileInventoryItem {
  const MobileInventoryItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unit,
    required this.expectedQty,
    required this.actualQty,
    required this.difference,
  });

  final String id;
  final String productId;
  final String productName;
  final String unit;
  final String expectedQty;
  final String actualQty;
  final String difference;

  double get actualQtyValue => double.tryParse(actualQty) ?? 0;
  double get expectedQtyValue => double.tryParse(expectedQty) ?? 0;

  factory MobileInventoryItem.fromTransport(generated.InventoryItem transport) {
    return MobileInventoryItem(
      id: transport.id,
      productId: transport.productId,
      productName: transport.product.name,
      unit: transport.product.unit,
      expectedQty: transport.expectedQty,
      actualQty: transport.actualQty,
      difference: transport.difference,
    );
  }

  MobileInventoryItem copyWithActualQty(double nextActualQty) {
    final diff = nextActualQty - expectedQtyValue;
    return MobileInventoryItem(
      id: id,
      productId: productId,
      productName: productName,
      unit: unit,
      expectedQty: expectedQty,
      actualQty: nextActualQty.toString(),
      difference: diff.toString(),
    );
  }
}
