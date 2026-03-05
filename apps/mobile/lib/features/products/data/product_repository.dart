import 'package:flutter/foundation.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/offline_sync_issue.dart';
import '../../../core/network/transport_mapper.dart';
import '../../../core/storage/cache_keys.dart';
import '../../../core/storage/local_cache_store.dart';
import 'product_queue_store.dart';

class ProductRepository {
  ProductRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
    ProductQueueStore? queueStore,
  })  : _cacheStore = cacheStore ?? LocalCacheStore.instance,
        _queueStore =
            queueStore ?? ProductQueueStore(cacheStore: cacheStore ?? LocalCacheStore.instance);

  final ApiClient _apiClient;
  final LocalCacheStore _cacheStore;
  final ProductQueueStore _queueStore;

  Future<List<MobileProduct>> fetchProducts({
    required String accessToken,
    String? search,
  }) async {
    final query = search != null && search.trim().isNotEmpty
        ? '?search=${Uri.encodeQueryComponent(search.trim())}'
        : '';

    final cacheKey = CacheKeys.productsList(search);

    try {
      final json = await _apiClient.get(
        '/v1/products$query',
        accessToken: accessToken,
      );
      await _cacheStore.writeJson(cacheKey, json);
      return _applyPendingOverlays(await _decodeProductList(json));
    } catch (_) {
      final cached = await _cacheStore.readJson(cacheKey);
      if (cached != null) {
        return _applyPendingOverlays(await _decodeProductList(cached));
      }
      rethrow;
    }
  }

  Future<ProductCreateResult> createProduct({
    required String accessToken,
    required String name,
    required String unit,
    String? categoryId,
    String? sku,
    String? barcode,
    String? description,
    double? minStock,
    double? currentStock,
  }) async {
    try {
      final json = await _apiClient.post(
        '/v1/products',
        accessToken: accessToken,
        body: generated.CreateProductRequest(
          categoryId: categoryId,
          name: name,
          sku: sku,
          barcode: barcode,
          unit: unit,
          description: description,
          minStock: minStock,
          currentStock: currentStock,
        ).toJson(),
      );

      return ProductCreateResult(
        queued: false,
        product: ApiContract.item(
          json,
          module: 'products',
          action: 'create',
          decode: (payload) => mapTransport(
            payload,
            decodeTransport: generated.Product.fromJson,
            toDomain: MobileProduct.fromTransport,
          ),
        ),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      final localId = _newLocalId();
      final pending = PendingProductCreate(
        localId: localId,
        categoryId: categoryId,
        name: name,
        sku: sku,
        barcode: barcode,
        description: description,
        unit: unit,
        minStock: minStock,
        currentStock: currentStock,
        createdAt: DateTime.now(),
      );
      await _queueStore.enqueueCreate(pending);

      return ProductCreateResult(
        queued: true,
        product: MobileProduct.pendingCreate(
          localId: localId,
          categoryId: categoryId,
          name: name,
          sku: sku,
          barcode: barcode,
          unit: unit,
          currentStock: currentStock,
          minStock: minStock,
          description: description,
        ),
      );
    }
  }

  Future<ProductWriteResult> updateProduct({
    required String accessToken,
    required MobileProduct fallbackProduct,
    required String productId,
    bool includeCategoryId = false,
    String? categoryId,
    String? name,
    String? sku,
    String? barcode,
    String? description,
    String? unit,
    double? minStock,
  }) async {
    try {
      final json = await _apiClient.patch(
        '/v1/products/$productId',
        accessToken: accessToken,
        body: generated.UpdateProductRequest(
          categoryId: includeCategoryId ? categoryId : null,
          name: name,
          sku: sku,
          barcode: barcode,
          description: description,
          unit: unit,
          minStock: minStock,
        ).toJson(),
      );

      return ProductWriteResult(
        queued: false,
        product: ApiContract.item(
          json,
          module: 'products',
          action: 'update',
          decode: (payload) => mapTransport(
            payload,
            decodeTransport: generated.Product.fromJson,
            toDomain: MobileProduct.fromTransport,
          ),
        ),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.enqueue(
        PendingProductUpdate(
          productId: productId,
          includeCategoryId: includeCategoryId,
          categoryId: categoryId,
          name: name,
          sku: sku,
          barcode: barcode,
          description: description,
          unit: unit,
          minStock: minStock,
          createdAt: DateTime.now(),
        ),
      );

      return ProductWriteResult(
        queued: true,
        product: fallbackProduct.copyWith(
          categoryId: includeCategoryId ? categoryId : fallbackProduct.categoryId,
          name: name,
          sku: sku,
          barcode: barcode,
          description: description,
          unit: unit,
          minStock: minStock,
        ),
      );
    }
  }

  Future<int> getPendingUpdateCount() async {
    final updates = await _queueStore.readAll();
    final creates = await _queueStore.readPendingCreates();
    return updates.length + creates.length;
  }

  Future<List<PendingProductUpdateView>> getPendingUpdates() async {
    final items = await _queueStore.readAll();
    return items
        .map(
          (item) => PendingProductUpdateView(
            productId: item.productId,
            name: item.name ?? 'Без названия',
            createdAt: item.createdAt,
          ),
        )
        .toList(growable: false);
  }

  Future<List<PendingProductCreateView>> getPendingCreates() async {
    final items = await _queueStore.readPendingCreates();
    return items
        .map(
          (item) => PendingProductCreateView(
            localId: item.localId,
            name: item.name,
            createdAt: item.createdAt,
          ),
        )
        .toList(growable: false);
  }

  Future<void> clearPendingUpdates() {
    return _queueStore.writeAll(const []);
  }

  Future<void> clearPendingCreates() {
    return _queueStore.writePendingCreates(const []);
  }

  Future<void> discardPendingUpdate(String productId) async {
    final items = await _queueStore.readAll();
    await _queueStore.writeAll(
      items.where((item) => item.productId != productId).toList(growable: false),
    );
  }

  Future<void> discardPendingCreate(String localId) async {
    final items = await _queueStore.readPendingCreates();
    await _queueStore.writePendingCreates(
      items.where((item) => item.localId != localId).toList(growable: false),
    );
  }

  Future<String?> retryPendingUpdate({
    required String accessToken,
    required String productId,
  }) async {
    final items = await _queueStore.readAll();
    final pending = items.where((item) => item.productId == productId).toList(growable: false);
    if (pending.isEmpty) {
      return null;
    }

    final item = pending.first;
    try {
      await _sendPendingUpdate(
        accessToken: accessToken,
        item: item,
      );
      await discardPendingUpdate(productId);
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

  Future<String?> retryPendingCreate({
    required String accessToken,
    required String localId,
  }) async {
    final items = await _queueStore.readPendingCreates();
    final pending = items.where((item) => item.localId == localId).toList(growable: false);
    if (pending.isEmpty) {
      return null;
    }

    final item = pending.first;
    try {
      await _sendPendingCreate(
        accessToken: accessToken,
        item: item,
      );
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

  Future<ProductSyncResult> flushPendingUpdates({
    required String accessToken,
  }) async {
    final createItems = await _queueStore.readPendingCreates();
    final updateItems = await _queueStore.readAll();
    if (createItems.isEmpty && updateItems.isEmpty) {
      return const ProductSyncResult(
        appliedCount: 0,
        pendingCount: 0,
      );
    }

    final remainingCreates = <PendingProductCreate>[];
    final remaining = <PendingProductUpdate>[];
    var appliedCount = 0;
    var conflictCount = 0;
    String? blockingMessage;
    var stop = false;

    for (final item in createItems) {
      if (stop) {
        remainingCreates.add(item);
        continue;
      }

      try {
        await _sendPendingCreate(accessToken: accessToken, item: item);
        appliedCount += 1;
      } on ApiException catch (error) {
        final issue = OfflineSyncIssue.fromApiException(error);
        remainingCreates.add(item);
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
        remainingCreates.add(item);
        stop = true;
      }
    }

    for (final item in updateItems) {
      if (stop) {
        remaining.add(item);
        continue;
      }

      try {
        await _sendPendingUpdate(accessToken: accessToken, item: item);
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

    await _queueStore.writePendingCreates(remainingCreates);
    await _queueStore.writeAll(remaining);

    return ProductSyncResult(
      appliedCount: appliedCount,
      pendingCount: remainingCreates.length + remaining.length,
      blockingMessage: blockingMessage,
      conflictCount: conflictCount,
    );
  }

  Future<List<MobileProduct>> _applyPendingOverlays(List<MobileProduct> products) async {
    final pendingCreates = await _queueStore.readPendingCreates();
    final pending = await _queueStore.readAll();

    final byId = {for (final item in pending) item.productId: item};
    final updatedProducts = products.map((product) {
      final queued = byId[product.id];
      if (queued == null) {
        return product;
      }
      return product.copyWith(
        categoryId: queued.includeCategoryId ? queued.categoryId : product.categoryId,
        name: queued.name,
        sku: queued.sku,
        barcode: queued.barcode,
        description: queued.description,
        unit: queued.unit,
        minStock: queued.minStock,
      );
    }).toList(growable: false);

    if (pendingCreates.isEmpty) {
      return updatedProducts;
    }

    final queuedProducts = pendingCreates
        .map(
          (item) => MobileProduct.pendingCreate(
            localId: item.localId,
            categoryId: item.categoryId,
            name: item.name,
            sku: item.sku,
            barcode: item.barcode,
            unit: item.unit,
            currentStock: item.currentStock,
            minStock: item.minStock,
            description: item.description,
          ),
        )
        .toList(growable: false);

    return [...queuedProducts, ...updatedProducts];
  }

  Future<void> _sendPendingUpdate({
    required String accessToken,
    required PendingProductUpdate item,
  }) {
    return _apiClient.patch(
      '/v1/products/${item.productId}',
      accessToken: accessToken,
      body: generated.UpdateProductRequest(
        categoryId: item.includeCategoryId ? item.categoryId : null,
        name: item.name,
        sku: item.sku,
        barcode: item.barcode,
        description: item.description,
        unit: item.unit,
        minStock: item.minStock,
      ).toJson(),
    );
  }

  Future<void> _sendPendingCreate({
    required String accessToken,
    required PendingProductCreate item,
  }) {
    return _apiClient.post(
      '/v1/products',
      accessToken: accessToken,
      body: generated.CreateProductRequest(
        categoryId: item.categoryId,
        name: item.name,
        sku: item.sku,
        barcode: item.barcode,
        unit: item.unit,
        description: item.description,
        minStock: item.minStock,
        currentStock: item.currentStock,
      ).toJson(),
    );
  }

  String _newLocalId() => 'local:${DateTime.now().microsecondsSinceEpoch}';
}

Future<List<MobileProduct>> _decodeProductList(Map<String, dynamic> json) async {
  return ApiContract.list(
    json,
    module: 'products',
    decode: (payload) => mapTransport(
      payload,
      decodeTransport: generated.Product.fromJson,
      toDomain: MobileProduct.fromTransport,
    ),
  );
}

@immutable
class ProductWriteResult {
  const ProductWriteResult({
    required this.queued,
    required this.product,
  });

  final bool queued;
  final MobileProduct product;
}

@immutable
class ProductCreateResult {
  const ProductCreateResult({
    required this.queued,
    required this.product,
  });

  final bool queued;
  final MobileProduct product;
}

@immutable
class ProductSyncResult {
  const ProductSyncResult({
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

@immutable
class PendingProductUpdateView {
  const PendingProductUpdateView({
    required this.productId,
    required this.name,
    required this.createdAt,
  });

  final String productId;
  final String name;
  final DateTime createdAt;
}

@immutable
class PendingProductCreateView {
  const PendingProductCreateView({
    required this.localId,
    required this.name,
    required this.createdAt,
  });

  final String localId;
  final String name;
  final DateTime createdAt;
}

class MobileProduct {
  const MobileProduct({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.unit,
    required this.currentStock,
    required this.minStock,
    required this.description,
    required this.categoryName,
    this.isPendingCreate = false,
  });

  final String id;
  final String? categoryId;
  final String name;
  final String? sku;
  final String? barcode;
  final String unit;
  final String currentStock;
  final String minStock;
  final String? description;
  final String? categoryName;
  final bool isPendingCreate;

  bool get isLowStock => double.tryParse(currentStock) != null &&
      double.tryParse(minStock) != null &&
      double.parse(currentStock) <= double.parse(minStock);

  factory MobileProduct.fromTransport(generated.Product transport) {
    return MobileProduct(
      id: transport.id,
      categoryId: transport.categoryId,
      name: transport.name,
      sku: transport.sku,
      barcode: transport.barcode,
      unit: transport.unit,
      currentStock: transport.currentStock,
      minStock: transport.minStock,
      description: transport.description,
      categoryName: transport.category?.name,
    );
  }

  factory MobileProduct.pendingCreate({
    required String localId,
    required String? categoryId,
    required String name,
    required String? sku,
    required String? barcode,
    required String unit,
    required double? currentStock,
    required double? minStock,
    required String? description,
  }) {
    return MobileProduct(
      id: localId,
      categoryId: categoryId,
      name: name,
      sku: sku,
      barcode: barcode,
      unit: unit,
      currentStock: (currentStock ?? 0).toString(),
      minStock: (minStock ?? 0).toString(),
      description: description,
      categoryName: null,
      isPendingCreate: true,
    );
  }

  MobileProduct copyWith({
    String? categoryId,
    String? name,
    String? sku,
    String? barcode,
    String? description,
    String? unit,
    double? minStock,
  }) {
    return MobileProduct(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      unit: unit ?? this.unit,
      currentStock: currentStock,
      minStock: minStock?.toString() ?? this.minStock,
      description: description ?? this.description,
      categoryName: categoryName,
      isPendingCreate: isPendingCreate,
    );
  }
}
