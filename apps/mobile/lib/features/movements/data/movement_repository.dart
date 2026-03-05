import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/offline_sync_issue.dart';
import '../../../core/network/transport_mapper.dart';
import '../../../core/storage/cache_keys.dart';
import '../../../core/storage/local_cache_store.dart';
import 'movement_queue_store.dart';

class MovementRepository {
  MovementRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
    MovementQueueStore? queueStore,
  })  : _cacheStore = cacheStore ?? LocalCacheStore.instance,
        _queueStore =
            queueStore ?? MovementQueueStore(cacheStore: cacheStore ?? LocalCacheStore.instance);

  final ApiClient _apiClient;
  final LocalCacheStore _cacheStore;
  final MovementQueueStore _queueStore;

  Future<List<MobileMovement>> fetchMovements({
    required String accessToken,
    int limit = 20,
  }) async {
    final cacheKey = CacheKeys.movementsList(limit);

    try {
      final json = await _apiClient.get(
        '/v1/movements?limit=$limit',
        accessToken: accessToken,
      );
      await _cacheStore.writeJson(cacheKey, json);
      return _decodeMovementList(json);
    } catch (_) {
      final cached = await _cacheStore.readJson(cacheKey);
      if (cached != null) {
        return _decodeMovementList(cached);
      }
      rethrow;
    }
  }

  Future<MovementWriteResult> createIncome({
    required String accessToken,
    required String productId,
    required double quantity,
    String? comment,
  }) async {
    return _createWithOfflineQueue(
      accessToken: accessToken,
      endpoint: '/v1/movements/income',
      body: generated.CreateMovementRequest(
        productId: productId,
        quantity: quantity,
        comment: comment,
      ).toJson(),
      queuedOperation: PendingMovementOperation(
        id: _newQueueId(),
        type: PendingMovementType.income,
        productId: productId,
        value: quantity,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<MovementWriteResult> createExpense({
    required String accessToken,
    required String productId,
    required double quantity,
    String? comment,
  }) async {
    return _createWithOfflineQueue(
      accessToken: accessToken,
      endpoint: '/v1/movements/expense',
      body: generated.CreateMovementRequest(
        productId: productId,
        quantity: quantity,
        comment: comment,
      ).toJson(),
      queuedOperation: PendingMovementOperation(
        id: _newQueueId(),
        type: PendingMovementType.expense,
        productId: productId,
        value: quantity,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<MovementWriteResult> createAdjustment({
    required String accessToken,
    required String productId,
    required double targetQty,
    String? comment,
  }) async {
    return _createWithOfflineQueue(
      accessToken: accessToken,
      endpoint: '/v1/movements/adjustment',
      body: generated.CreateAdjustmentRequest(
        productId: productId,
        targetQty: targetQty,
        comment: comment,
      ).toJson(),
      queuedOperation: PendingMovementOperation(
        id: _newQueueId(),
        type: PendingMovementType.adjustment,
        productId: productId,
        value: targetQty,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<int> getPendingCount() async {
    final items = await _queueStore.readAll();
    return items.length;
  }

  Future<void> clearPendingWrites() {
    return _queueStore.writeAll(const []);
  }

  Future<MovementSyncResult> flushPendingWrites({
    required String accessToken,
  }) async {
    final items = await _queueStore.readAll();
    if (items.isEmpty) {
      return const MovementSyncResult(
        appliedCount: 0,
        pendingCount: 0,
      );
    }

    final remaining = <PendingMovementOperation>[];
    var appliedCount = 0;
    var conflictCount = 0;
    String? blockingMessage;
    var stop = false;

    for (var index = 0; index < items.length; index += 1) {
      final item = items[index];
      if (stop) {
        remaining.add(item);
        continue;
      }

      try {
        await _dispatchPending(
          accessToken: accessToken,
          operation: item,
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

    return MovementSyncResult(
      appliedCount: appliedCount,
      pendingCount: remaining.length,
      blockingMessage: blockingMessage,
      conflictCount: conflictCount,
    );
  }

  Future<MovementWriteResult> _createWithOfflineQueue({
    required String accessToken,
    required String endpoint,
    required Map<String, dynamic> body,
    required PendingMovementOperation queuedOperation,
  }) async {
    try {
      await _apiClient.post(
        endpoint,
        accessToken: accessToken,
        body: body,
      );
      return const MovementWriteResult(queued: false);
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.enqueue(queuedOperation);
      return const MovementWriteResult(queued: true);
    }
  }

  Future<void> _dispatchPending({
    required String accessToken,
    required PendingMovementOperation operation,
  }) {
    switch (operation.type) {
      case PendingMovementType.income:
        return _apiClient.post(
          '/v1/movements/income',
          accessToken: accessToken,
          body: generated.CreateMovementRequest(
            productId: operation.productId,
            quantity: operation.value,
            comment: operation.comment,
          ).toJson(),
        );
      case PendingMovementType.expense:
        return _apiClient.post(
          '/v1/movements/expense',
          accessToken: accessToken,
          body: generated.CreateMovementRequest(
            productId: operation.productId,
            quantity: operation.value,
            comment: operation.comment,
          ).toJson(),
        );
      case PendingMovementType.adjustment:
        return _apiClient.post(
          '/v1/movements/adjustment',
          accessToken: accessToken,
          body: generated.CreateAdjustmentRequest(
            productId: operation.productId,
            targetQty: operation.value,
            comment: operation.comment,
          ).toJson(),
        );
    }
  }

  String _newQueueId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

List<MobileMovement> _decodeMovementList(Map<String, dynamic> json) {
  return ApiContract.list(
    json,
    module: 'movements',
    decode: (payload) => mapTransport(
      payload,
      decodeTransport: generated.StockMovement.fromJson,
      toDomain: MobileMovement.fromTransport,
    ),
  );
}

class MobileMovement {
  const MobileMovement({
    required this.id,
    required this.type,
    required this.quantity,
    required this.productName,
    required this.actorName,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String quantity;
  final String productName;
  final String actorName;
  final DateTime createdAt;

  String get typeLabel {
    switch (type) {
      case 'INCOME':
        return 'Приход';
      case 'EXPENSE':
        return 'Расход';
      case 'ADJUSTMENT':
        return 'Корректировка';
      case 'INVENTORY_DIFF':
        return 'Инвентаризация';
      default:
        return type;
    }
  }

  String get signedQuantity {
    if (quantity.startsWith('-') || quantity.startsWith('+')) {
      return quantity;
    }
    if (type == 'EXPENSE' || type == 'INVENTORY_DIFF') {
      return '-$quantity';
    }
    return '+$quantity';
  }

  factory MobileMovement.fromTransport(generated.StockMovement transport) {
    return MobileMovement(
      id: transport.id,
      type: transport.movementType.value,
      quantity: transport.quantity,
      productName: transport.product.name,
      actorName: transport.createdBy.name,
      createdAt: transport.createdAt,
    );
  }
}
