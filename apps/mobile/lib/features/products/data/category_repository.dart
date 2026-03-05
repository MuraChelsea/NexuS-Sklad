import 'package:flutter/foundation.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/json_reader.dart';
import '../../../core/network/offline_sync_issue.dart';
import '../../../core/network/transport_mapper.dart';
import '../../../core/storage/cache_keys.dart';
import '../../../core/storage/local_cache_store.dart';

const _categoryCreateQueueKey = 'categories.pending.create.queue';

class CategoryRepository {
  CategoryRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final ApiClient _apiClient;
  final LocalCacheStore _cacheStore;

  Future<List<MobileCategory>> fetchCategories({
    required String accessToken,
  }) async {
    try {
      final json = await _apiClient.get(
        '/v1/categories',
        accessToken: accessToken,
      );
      await _cacheStore.writeJson(CacheKeys.categoriesList, json);
      return _decode(json);
    } catch (_) {
      final cached = await _cacheStore.readJson(CacheKeys.categoriesList);
      if (cached != null) {
        return _decode(cached);
      }
      rethrow;
    }
  }

  Future<CategoryCreateResult> createCategory({
    required String accessToken,
    required String name,
  }) async {
    try {
      final json = await _apiClient.post(
        '/v1/categories',
        accessToken: accessToken,
        body: generated.CreateCategoryRequest(name: name).toJson(),
      );

      return CategoryCreateResult(
        queued: false,
        category: ApiContract.item(
          json,
          module: 'categories',
          action: 'create',
          decode: (payload) => mapTransport(
            payload,
            decodeTransport: generated.Category.fromJson,
            toDomain: MobileCategory.fromTransport,
          ),
        ),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      final pending = PendingCategoryCreate(
        localId: 'local:${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        createdAt: DateTime.now(),
      );
      await _enqueuePendingCreate(pending);

      return CategoryCreateResult(
        queued: true,
        category: MobileCategory.pendingCreate(
          localId: pending.localId,
          name: name,
        ),
      );
    }
  }

  Future<int> getPendingCreateCount() async {
    final items = await _readPendingCreates();
    return items.length;
  }

  Future<List<PendingCategoryCreateView>> getPendingCreates() async {
    final items = await _readPendingCreates();
    return items
        .map(
          (item) => PendingCategoryCreateView(
            localId: item.localId,
            name: item.name,
            createdAt: item.createdAt,
          ),
        )
        .toList(growable: false);
  }

  Future<void> clearPendingCreates() {
    return _writePendingCreates(const []);
  }

  Future<void> discardPendingCreate(String localId) async {
    final items = await _readPendingCreates();
    await _writePendingCreates(
      items.where((item) => item.localId != localId).toList(growable: false),
    );
  }

  Future<String?> retryPendingCreate({
    required String accessToken,
    required String localId,
  }) async {
    final items = await _readPendingCreates();
    final pending = items.where((item) => item.localId == localId).toList(growable: false);
    if (pending.isEmpty) {
      return null;
    }

    final item = pending.first;
    try {
      await _sendPendingCreate(accessToken: accessToken, item: item);
      await discardPendingCreate(localId);
      return null;
    } on ApiException catch (error) {
      return OfflineSyncIssue.fromApiException(error).message;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }
      return 'Нет соединения. Повторим позже.';
    }
  }

  Future<CategorySyncResult> flushPendingCreates({
    required String accessToken,
  }) async {
    final items = await _readPendingCreates();
    if (items.isEmpty) {
      return const CategorySyncResult(
        appliedCount: 0,
        pendingCount: 0,
      );
    }

    final remaining = <PendingCategoryCreate>[];
    var appliedCount = 0;
    var conflictCount = 0;
    String? blockingMessage;
    var stop = false;

    for (final item in items) {
      if (stop) {
        remaining.add(item);
        continue;
      }

      try {
        await _sendPendingCreate(accessToken: accessToken, item: item);
        appliedCount += 1;
      } on ApiException catch (error) {
        final issue = OfflineSyncIssue.fromApiException(error);
        remaining.add(item);
        blockingMessage ??= issue.message;
        if (issue.isConflict) {
          conflictCount += 1;
          continue;
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

    await _writePendingCreates(remaining);

    return CategorySyncResult(
      appliedCount: appliedCount,
      pendingCount: remaining.length,
      blockingMessage: blockingMessage,
      conflictCount: conflictCount,
    );
  }

  List<MobileCategory> _decode(Map<String, dynamic> json) {
    return ApiContract.list(
      json,
      module: 'categories',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.Category.fromJson,
        toDomain: MobileCategory.fromTransport,
      ),
    );
  }

  Future<List<PendingCategoryCreate>> _readPendingCreates() async {
    final json = await _cacheStore.readJson(_categoryCreateQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingCategoryCreate.fromJson)
        .toList(growable: false);
  }

  Future<void> _writePendingCreates(List<PendingCategoryCreate> items) {
    return _cacheStore.writeJson(
      _categoryCreateQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> _enqueuePendingCreate(PendingCategoryCreate item) async {
    final items = await _readPendingCreates();
    await _writePendingCreates([...items, item]);
  }

  Future<void> _sendPendingCreate({
    required String accessToken,
    required PendingCategoryCreate item,
  }) {
    return _apiClient.post(
      '/v1/categories',
      accessToken: accessToken,
      body: generated.CreateCategoryRequest(name: item.name).toJson(),
    );
  }
}

class MobileCategory {
  const MobileCategory({
    required this.id,
    required this.name,
    this.isPendingCreate = false,
  });

  final String id;
  final String name;
  final bool isPendingCreate;

  factory MobileCategory.fromTransport(generated.Category transport) {
    return MobileCategory(
      id: transport.id,
      name: transport.name,
    );
  }

  factory MobileCategory.pendingCreate({
    required String localId,
    required String name,
  }) {
    return MobileCategory(
      id: localId,
      name: name,
      isPendingCreate: true,
    );
  }
}

class PendingCategoryCreate {
  const PendingCategoryCreate({
    required this.localId,
    required this.name,
    required this.createdAt,
  });

  final String localId;
  final String name;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingCategoryCreate.fromJson(Map<String, dynamic> json) {
    return PendingCategoryCreate(
      localId: JsonReader.string(json, 'localId'),
      name: JsonReader.string(json, 'name'),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}

@immutable
class CategoryCreateResult {
  const CategoryCreateResult({
    required this.queued,
    required this.category,
  });

  final bool queued;
  final MobileCategory category;
}

@immutable
class PendingCategoryCreateView {
  const PendingCategoryCreateView({
    required this.localId,
    required this.name,
    required this.createdAt,
  });

  final String localId;
  final String name;
  final DateTime createdAt;
}

@immutable
class CategorySyncResult {
  const CategorySyncResult({
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
