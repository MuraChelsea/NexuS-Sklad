// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_movement_summary_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyMovementSummaryItemCWProxy {
  DailyMovementSummaryItem count(int count);

  DailyMovementSummaryItem quantity(String quantity);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMovementSummaryItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMovementSummaryItem(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMovementSummaryItem call({int count, String quantity});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyMovementSummaryItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyMovementSummaryItem.copyWith.fieldName(...)`
class _$DailyMovementSummaryItemCWProxyImpl
    implements _$DailyMovementSummaryItemCWProxy {
  const _$DailyMovementSummaryItemCWProxyImpl(this._value);

  final DailyMovementSummaryItem _value;

  @override
  DailyMovementSummaryItem count(int count) => this(count: count);

  @override
  DailyMovementSummaryItem quantity(String quantity) =>
      this(quantity: quantity);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMovementSummaryItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMovementSummaryItem(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMovementSummaryItem call({
    Object? count = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
  }) {
    return DailyMovementSummaryItem(
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as String,
    );
  }
}

extension $DailyMovementSummaryItemCopyWith on DailyMovementSummaryItem {
  /// Returns a callable class that can be used as follows: `instanceOfDailyMovementSummaryItem.copyWith(...)` or like so:`instanceOfDailyMovementSummaryItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyMovementSummaryItemCWProxy get copyWith =>
      _$DailyMovementSummaryItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMovementSummaryItem _$DailyMovementSummaryItemFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyMovementSummaryItem', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['count', 'quantity']);
  final val = DailyMovementSummaryItem(
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    quantity: $checkedConvert('quantity', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$DailyMovementSummaryItemToJson(
  DailyMovementSummaryItem instance,
) => <String, dynamic>{'count': instance.count, 'quantity': instance.quantity};
