import '../../../core/network/json_reader.dart';
import '../../../core/storage/local_cache_store.dart';

const _productQueueKey = 'products.pending.update.queue';
const _productCreateQueueKey = 'products.pending.create.queue';

class ProductQueueStore {
  ProductQueueStore({
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final LocalCacheStore _cacheStore;

  Future<List<PendingProductUpdate>> readAll() async {
    final json = await _cacheStore.readJson(_productQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingProductUpdate.fromJson)
        .toList(growable: false);
  }

  Future<List<PendingProductCreate>> readPendingCreates() async {
    final json = await _cacheStore.readJson(_productCreateQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingProductCreate.fromJson)
        .toList(growable: false);
  }

  Future<void> writeAll(List<PendingProductUpdate> items) {
    return _cacheStore.writeJson(
      _productQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> writePendingCreates(List<PendingProductCreate> items) {
    return _cacheStore.writeJson(
      _productCreateQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> enqueue(PendingProductUpdate item) async {
    final items = await readAll();
    final filtered = items.where((entry) => entry.productId != item.productId).toList(growable: false);
    await writeAll([...filtered, item]);
  }

  Future<void> enqueueCreate(PendingProductCreate item) async {
    final items = await readPendingCreates();
    await writePendingCreates([...items, item]);
  }
}

class PendingProductUpdate {
  const PendingProductUpdate({
    required this.productId,
    required this.includeCategoryId,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.description,
    required this.unit,
    required this.minStock,
    required this.createdAt,
  });

  final String productId;
  final bool includeCategoryId;
  final String? categoryId;
  final String? name;
  final String? sku;
  final String? barcode;
  final String? description;
  final String? unit;
  final double? minStock;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'includeCategoryId': includeCategoryId,
      'categoryId': categoryId,
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'description': description,
      'unit': unit,
      'minStock': minStock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingProductUpdate.fromJson(Map<String, dynamic> json) {
    return PendingProductUpdate(
      productId: JsonReader.string(json, 'productId'),
      includeCategoryId: JsonReader.boolean(json, 'includeCategoryId'),
      categoryId: JsonReader.nullableString(json, 'categoryId'),
      name: JsonReader.nullableString(json, 'name'),
      sku: JsonReader.nullableString(json, 'sku'),
      barcode: JsonReader.nullableString(json, 'barcode'),
      description: JsonReader.nullableString(json, 'description'),
      unit: JsonReader.nullableString(json, 'unit'),
      minStock: json['minStock'] == null
          ? null
          : double.parse(JsonReader.decimalString(json, 'minStock')),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}

class PendingProductCreate {
  const PendingProductCreate({
    required this.localId,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.description,
    required this.unit,
    required this.minStock,
    required this.currentStock,
    required this.createdAt,
  });

  final String localId;
  final String? categoryId;
  final String name;
  final String? sku;
  final String? barcode;
  final String? description;
  final String unit;
  final double? minStock;
  final double? currentStock;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'categoryId': categoryId,
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'description': description,
      'unit': unit,
      'minStock': minStock,
      'currentStock': currentStock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingProductCreate.fromJson(Map<String, dynamic> json) {
    return PendingProductCreate(
      localId: JsonReader.string(json, 'localId'),
      categoryId: JsonReader.nullableString(json, 'categoryId'),
      name: JsonReader.string(json, 'name'),
      sku: JsonReader.nullableString(json, 'sku'),
      barcode: JsonReader.nullableString(json, 'barcode'),
      description: JsonReader.nullableString(json, 'description'),
      unit: JsonReader.string(json, 'unit'),
      minStock: json['minStock'] == null
          ? null
          : double.parse(JsonReader.decimalString(json, 'minStock')),
      currentStock: json['currentStock'] == null
          ? null
          : double.parse(JsonReader.decimalString(json, 'currentStock')),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}
