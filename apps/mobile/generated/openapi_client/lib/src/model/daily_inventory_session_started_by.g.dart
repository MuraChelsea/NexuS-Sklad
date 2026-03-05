// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_inventory_session_started_by.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyInventorySessionStartedByCWProxy {
  DailyInventorySessionStartedBy id(String id);

  DailyInventorySessionStartedBy name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyInventorySessionStartedBy(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyInventorySessionStartedBy(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyInventorySessionStartedBy call({String id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyInventorySessionStartedBy.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyInventorySessionStartedBy.copyWith.fieldName(...)`
class _$DailyInventorySessionStartedByCWProxyImpl
    implements _$DailyInventorySessionStartedByCWProxy {
  const _$DailyInventorySessionStartedByCWProxyImpl(this._value);

  final DailyInventorySessionStartedBy _value;

  @override
  DailyInventorySessionStartedBy id(String id) => this(id: id);

  @override
  DailyInventorySessionStartedBy name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyInventorySessionStartedBy(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyInventorySessionStartedBy(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyInventorySessionStartedBy call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return DailyInventorySessionStartedBy(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $DailyInventorySessionStartedByCopyWith
    on DailyInventorySessionStartedBy {
  /// Returns a callable class that can be used as follows: `instanceOfDailyInventorySessionStartedBy.copyWith(...)` or like so:`instanceOfDailyInventorySessionStartedBy.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyInventorySessionStartedByCWProxy get copyWith =>
      _$DailyInventorySessionStartedByCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyInventorySessionStartedBy _$DailyInventorySessionStartedByFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyInventorySessionStartedBy', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'name']);
  final val = DailyInventorySessionStartedBy(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$DailyInventorySessionStartedByToJson(
  DailyInventorySessionStartedBy instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
