// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_inventory_session_count.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyInventorySessionCountCWProxy {
  DailyInventorySessionCount items(int items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyInventorySessionCount(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyInventorySessionCount(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyInventorySessionCount call({int items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyInventorySessionCount.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyInventorySessionCount.copyWith.fieldName(...)`
class _$DailyInventorySessionCountCWProxyImpl
    implements _$DailyInventorySessionCountCWProxy {
  const _$DailyInventorySessionCountCWProxyImpl(this._value);

  final DailyInventorySessionCount _value;

  @override
  DailyInventorySessionCount items(int items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyInventorySessionCount(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyInventorySessionCount(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyInventorySessionCount call({
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return DailyInventorySessionCount(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as int,
    );
  }
}

extension $DailyInventorySessionCountCopyWith on DailyInventorySessionCount {
  /// Returns a callable class that can be used as follows: `instanceOfDailyInventorySessionCount.copyWith(...)` or like so:`instanceOfDailyInventorySessionCount.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyInventorySessionCountCWProxy get copyWith =>
      _$DailyInventorySessionCountCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyInventorySessionCount _$DailyInventorySessionCountFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyInventorySessionCount', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items']);
  final val = DailyInventorySessionCount(
    items: $checkedConvert('items', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$DailyInventorySessionCountToJson(
  DailyInventorySessionCount instance,
) => <String, dynamic>{'items': instance.items};
