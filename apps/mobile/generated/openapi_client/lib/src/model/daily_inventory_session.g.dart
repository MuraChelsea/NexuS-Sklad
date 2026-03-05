// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_inventory_session.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyInventorySessionCWProxy {
  DailyInventorySession id(String id);

  DailyInventorySession status(String status);

  DailyInventorySession startedAt(DateTime startedAt);

  DailyInventorySession finishedAt(DateTime? finishedAt);

  DailyInventorySession comment(String? comment);

  DailyInventorySession startedBy(DailyInventorySessionStartedBy startedBy);

  DailyInventorySession count(DailyInventorySessionCount count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyInventorySession(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyInventorySession(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyInventorySession call({
    String id,
    String status,
    DateTime startedAt,
    DateTime? finishedAt,
    String? comment,
    DailyInventorySessionStartedBy startedBy,
    DailyInventorySessionCount count,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyInventorySession.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyInventorySession.copyWith.fieldName(...)`
class _$DailyInventorySessionCWProxyImpl
    implements _$DailyInventorySessionCWProxy {
  const _$DailyInventorySessionCWProxyImpl(this._value);

  final DailyInventorySession _value;

  @override
  DailyInventorySession id(String id) => this(id: id);

  @override
  DailyInventorySession status(String status) => this(status: status);

  @override
  DailyInventorySession startedAt(DateTime startedAt) =>
      this(startedAt: startedAt);

  @override
  DailyInventorySession finishedAt(DateTime? finishedAt) =>
      this(finishedAt: finishedAt);

  @override
  DailyInventorySession comment(String? comment) => this(comment: comment);

  @override
  DailyInventorySession startedBy(DailyInventorySessionStartedBy startedBy) =>
      this(startedBy: startedBy);

  @override
  DailyInventorySession count(DailyInventorySessionCount count) =>
      this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyInventorySession(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyInventorySession(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyInventorySession call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? finishedAt = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? startedBy = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
  }) {
    return DailyInventorySession(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime,
      finishedAt: finishedAt == const $CopyWithPlaceholder()
          ? _value.finishedAt
          // ignore: cast_nullable_to_non_nullable
          : finishedAt as DateTime?,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      startedBy: startedBy == const $CopyWithPlaceholder()
          ? _value.startedBy
          // ignore: cast_nullable_to_non_nullable
          : startedBy as DailyInventorySessionStartedBy,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as DailyInventorySessionCount,
    );
  }
}

extension $DailyInventorySessionCopyWith on DailyInventorySession {
  /// Returns a callable class that can be used as follows: `instanceOfDailyInventorySession.copyWith(...)` or like so:`instanceOfDailyInventorySession.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyInventorySessionCWProxy get copyWith =>
      _$DailyInventorySessionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyInventorySession _$DailyInventorySessionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyInventorySession', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'status', 'startedAt', 'startedBy', '_count'],
  );
  final val = DailyInventorySession(
    id: $checkedConvert('id', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    startedAt: $checkedConvert('startedAt', (v) => DateTime.parse(v as String)),
    finishedAt: $checkedConvert(
      'finishedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    comment: $checkedConvert('comment', (v) => v as String?),
    startedBy: $checkedConvert(
      'startedBy',
      (v) => DailyInventorySessionStartedBy.fromJson(v as Map<String, dynamic>),
    ),
    count: $checkedConvert(
      '_count',
      (v) => DailyInventorySessionCount.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
}, fieldKeyMap: const {'count': '_count'});

Map<String, dynamic> _$DailyInventorySessionToJson(
  DailyInventorySession instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'startedAt': instance.startedAt.toIso8601String(),
  'finishedAt': ?instance.finishedAt?.toIso8601String(),
  'comment': ?instance.comment,
  'startedBy': instance.startedBy.toJson(),
  '_count': instance.count.toJson(),
};
