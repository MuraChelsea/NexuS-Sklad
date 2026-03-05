// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_expense_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementExpenseResponseCWProxy {
  MovementExpenseResponse item(StockMovement item);

  MovementExpenseResponse module(Object? module);

  MovementExpenseResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementExpenseResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementExpenseResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementExpenseResponse call({
    StockMovement item,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementExpenseResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementExpenseResponse.copyWith.fieldName(...)`
class _$MovementExpenseResponseCWProxyImpl
    implements _$MovementExpenseResponseCWProxy {
  const _$MovementExpenseResponseCWProxyImpl(this._value);

  final MovementExpenseResponse _value;

  @override
  MovementExpenseResponse item(StockMovement item) => this(item: item);

  @override
  MovementExpenseResponse module(Object? module) => this(module: module);

  @override
  MovementExpenseResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementExpenseResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementExpenseResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementExpenseResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return MovementExpenseResponse(
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

extension $MovementExpenseResponseCopyWith on MovementExpenseResponse {
  /// Returns a callable class that can be used as follows: `instanceOfMovementExpenseResponse.copyWith(...)` or like so:`instanceOfMovementExpenseResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementExpenseResponseCWProxy get copyWith =>
      _$MovementExpenseResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementExpenseResponse _$MovementExpenseResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MovementExpenseResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module', 'action']);
  final val = MovementExpenseResponse(
    item: $checkedConvert(
      'item',
      (v) => StockMovement.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$MovementExpenseResponseToJson(
  MovementExpenseResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': instance.action,
};
