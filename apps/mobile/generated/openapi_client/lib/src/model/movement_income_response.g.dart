// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_income_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementIncomeResponseCWProxy {
  MovementIncomeResponse item(StockMovement item);

  MovementIncomeResponse module(Object? module);

  MovementIncomeResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementIncomeResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementIncomeResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementIncomeResponse call({
    StockMovement item,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementIncomeResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementIncomeResponse.copyWith.fieldName(...)`
class _$MovementIncomeResponseCWProxyImpl
    implements _$MovementIncomeResponseCWProxy {
  const _$MovementIncomeResponseCWProxyImpl(this._value);

  final MovementIncomeResponse _value;

  @override
  MovementIncomeResponse item(StockMovement item) => this(item: item);

  @override
  MovementIncomeResponse module(Object? module) => this(module: module);

  @override
  MovementIncomeResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementIncomeResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementIncomeResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementIncomeResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return MovementIncomeResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as StockMovement,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as Object?,
    );
  }
}

extension $MovementIncomeResponseCopyWith on MovementIncomeResponse {
  /// Returns a callable class that can be used as follows: `instanceOfMovementIncomeResponse.copyWith(...)` or like so:`instanceOfMovementIncomeResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementIncomeResponseCWProxy get copyWith =>
      _$MovementIncomeResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementIncomeResponse _$MovementIncomeResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MovementIncomeResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module', 'action']);
  final val = MovementIncomeResponse(
    item: $checkedConvert(
      'item',
      (v) => StockMovement.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$MovementIncomeResponseToJson(
  MovementIncomeResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': instance.action,
};
