// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_session.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventorySessionCWProxy {
  InventorySession id(String id);

  InventorySession companyId(String companyId);

  InventorySession startedById(String startedById);

  InventorySession startedBy(InventoryStartedBy startedBy);

  InventorySession status(InventoryStatus status);

  InventorySession comment(String? comment);

  InventorySession startedAt(DateTime startedAt);

  InventorySession finishedAt(DateTime? finishedAt);

  InventorySession items(List<InventoryItem> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventorySession(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventorySession(...).copyWith(id: 12, name: "My name")
  /// ````
  InventorySession call({
    String id,
    String companyId,
    String startedById,
    InventoryStartedBy startedBy,
    InventoryStatus status,
    String? comment,
    DateTime startedAt,
    DateTime? finishedAt,
    List<InventoryItem> items,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventorySession.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventorySession.copyWith.fieldName(...)`
class _$InventorySessionCWProxyImpl implements _$InventorySessionCWProxy {
  const _$InventorySessionCWProxyImpl(this._value);

  final InventorySession _value;

  @override
  InventorySession id(String id) => this(id: id);

  @override
  InventorySession companyId(String companyId) => this(companyId: companyId);

  @override
  InventorySession startedById(String startedById) =>
      this(startedById: startedById);

  @override
  InventorySession startedBy(InventoryStartedBy startedBy) =>
      this(startedBy: startedBy);

  @override
  InventorySession status(InventoryStatus status) => this(status: status);

  @override
  InventorySession comment(String? comment) => this(comment: comment);

  @override
  InventorySession startedAt(DateTime startedAt) => this(startedAt: startedAt);

  @override
  InventorySession finishedAt(DateTime? finishedAt) =>
      this(finishedAt: finishedAt);

  @override
  InventorySession items(List<InventoryItem> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventorySession(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventorySession(...).copyWith(id: 12, name: "My name")
  /// ````
  InventorySession call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? startedById = const $CopyWithPlaceholder(),
    Object? startedBy = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? finishedAt = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return InventorySession(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      companyId: companyId == const $CopyWithPlaceholder()
          ? _value.companyId
          // ignore: cast_nullable_to_non_nullable
          : companyId as String,
      startedById: startedById == const $CopyWithPlaceholder()
          ? _value.startedById
          // ignore: cast_nullable_to_non_nullable
          : startedById as String,
      startedBy: startedBy == const $CopyWithPlaceholder()
          ? _value.startedBy
          // ignore: cast_nullable_to_non_nullable
          : startedBy as InventoryStartedBy,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as InventoryStatus,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime,
      finishedAt: finishedAt == const $CopyWithPlaceholder()
          ? _value.finishedAt
          // ignore: cast_nullable_to_non_nullable
          : finishedAt as DateTime?,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<InventoryItem>,
    );
  }
}

extension $InventorySessionCopyWith on InventorySession {
  /// Returns a callable class that can be used as follows: `instanceOfInventorySession.copyWith(...)` or like so:`instanceOfInventorySession.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventorySessionCWProxy get copyWith => _$InventorySessionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventorySession _$InventorySessionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InventorySession', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'companyId',
          'startedById',
          'startedBy',
          'status',
          'startedAt',
          'items',
        ],
      );
      final val = InventorySession(
        id: $checkedConvert('id', (v) => v as String),
        companyId: $checkedConvert('companyId', (v) => v as String),
        startedById: $checkedConvert('startedById', (v) => v as String),
        startedBy: $checkedConvert(
          'startedBy',
          (v) => InventoryStartedBy.fromJson(v as Map<String, dynamic>),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$InventoryStatusEnumMap, v),
        ),
        comment: $checkedConvert('comment', (v) => v as String?),
        startedAt: $checkedConvert(
          'startedAt',
          (v) => DateTime.parse(v as String),
        ),
        finishedAt: $checkedConvert(
          'finishedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$InventorySessionToJson(InventorySession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'startedById': instance.startedById,
      'startedBy': instance.startedBy.toJson(),
      'status': _$InventoryStatusEnumMap[instance.status]!,
      'comment': ?instance.comment,
      'startedAt': instance.startedAt.toIso8601String(),
      'finishedAt': ?instance.finishedAt?.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

const _$InventoryStatusEnumMap = {
  InventoryStatus.DRAFT: 'DRAFT',
  InventoryStatus.IN_PROGRESS: 'IN_PROGRESS',
  InventoryStatus.COMPLETED: 'COMPLETED',
};
