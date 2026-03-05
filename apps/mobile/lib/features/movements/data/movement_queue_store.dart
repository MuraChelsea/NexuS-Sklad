import 'package:flutter/foundation.dart';

import '../../../core/network/json_reader.dart';
import '../../../core/storage/local_cache_store.dart';

const _movementQueueKey = 'movements.pending.queue';

class MovementQueueStore {
  MovementQueueStore({
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final LocalCacheStore _cacheStore;

  Future<List<PendingMovementOperation>> readAll() async {
    final json = await _cacheStore.readJson(_movementQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingMovementOperation.fromJson)
        .toList(growable: false);
  }

  Future<void> writeAll(List<PendingMovementOperation> items) async {
    await _cacheStore.writeJson(
      _movementQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> enqueue(PendingMovementOperation item) async {
    final items = await readAll();
    await writeAll([...items, item]);
  }
}

enum PendingMovementType {
  income,
  expense,
  adjustment,
}

class PendingMovementOperation {
  const PendingMovementOperation({
    required this.id,
    required this.type,
    required this.productId,
    required this.value,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final PendingMovementType type;
  final String productId;
  final double value;
  final String? comment;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'productId': productId,
      'value': value,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingMovementOperation.fromJson(Map<String, dynamic> json) {
    return PendingMovementOperation(
      id: JsonReader.string(json, 'id'),
      type: PendingMovementType.values.firstWhere(
        (value) => value.name == JsonReader.string(json, 'type'),
      ),
      productId: JsonReader.string(json, 'productId'),
      value: double.parse(JsonReader.decimalString(json, 'value')),
      comment: JsonReader.nullableString(json, 'comment'),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}

@immutable
class MovementWriteResult {
  const MovementWriteResult({
    required this.queued,
  });

  final bool queued;
}

@immutable
class MovementSyncResult {
  const MovementSyncResult({
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
