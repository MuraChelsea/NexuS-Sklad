import '../../../core/network/json_reader.dart';
import '../../../core/storage/local_cache_store.dart';

const _inventoryQueueKey = 'inventory.pending.queue';
const _inventoryStartQueueKey = 'inventory.pending.start';

class InventoryQueueStore {
  InventoryQueueStore({
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final LocalCacheStore _cacheStore;

  Future<List<PendingInventoryItemUpdate>> readAll() async {
    final json = await _cacheStore.readJson(_inventoryQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingInventoryItemUpdate.fromJson)
        .toList(growable: false);
  }

  Future<PendingInventoryStart?> readPendingStart() async {
    final json = await _cacheStore.readJson(_inventoryStartQueueKey);
    if (json == null) {
      return null;
    }

    return PendingInventoryStart.fromJson(json);
  }

  Future<void> writeAll(List<PendingInventoryItemUpdate> items) async {
    await _cacheStore.writeJson(
      _inventoryQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> writePendingStart(PendingInventoryStart item) {
    return _cacheStore.writeJson(_inventoryStartQueueKey, item.toJson());
  }

  Future<void> clearPendingStart() {
    return _cacheStore.remove(_inventoryStartQueueKey);
  }

  Future<void> enqueue(PendingInventoryItemUpdate item) async {
    final items = await readAll();
    final filtered = items.where((entry) => entry.itemId != item.itemId).toList(growable: false);
    await writeAll([...filtered, item]);
  }
}

class PendingInventoryStart {
  const PendingInventoryStart({
    required this.createdAt,
  });

  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingInventoryStart.fromJson(Map<String, dynamic> json) {
    return PendingInventoryStart(
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}

class PendingInventoryItemUpdate {
  const PendingInventoryItemUpdate({
    required this.id,
    required this.inventoryId,
    required this.itemId,
    required this.actualQty,
    required this.createdAt,
  });

  final String id;
  final String inventoryId;
  final String itemId;
  final double actualQty;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inventoryId': inventoryId,
      'itemId': itemId,
      'actualQty': actualQty,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingInventoryItemUpdate.fromJson(Map<String, dynamic> json) {
    return PendingInventoryItemUpdate(
      id: JsonReader.string(json, 'id'),
      inventoryId: JsonReader.string(json, 'inventoryId'),
      itemId: JsonReader.string(json, 'itemId'),
      actualQty: double.parse(JsonReader.decimalString(json, 'actualQty')),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}
