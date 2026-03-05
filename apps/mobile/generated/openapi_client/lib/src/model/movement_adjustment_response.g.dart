// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_adjustment_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementAdjustmentResponseCWProxy {
  MovementAdjustmentResponse item(StockMovement item);

  MovementAdjustmentResponse module(Object? module);

  MovementAdjustmentResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementAdjustmentResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementAdjustmentResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementAdjustmentResponse call({
    StockMovement item,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementAdjustmentResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementAdjustmentResponse.copyWith.fieldName(...)`
class _$MovementAdjustmentResponseCWProxyImpl
    implements _$MovementAdjustmentResponseCWProxy {
  const _$MovementAdjustmentResponseCWProxyImpl(this._value);

  final MovementAdjustmentResponse _value;

  @override
  MovementAdjustmentResponse item(StockMovement item) => this(item: item);

  @override
  MovementAdjustmentResponse module(Object? module) => this(module: module);

  @override
  MovementAdjustmentResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementAdjustmentResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementAdjustmentResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementAdjustmentResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return MovementAdjustmentResponse(
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

extension $MovementAdjustmentResponseCopyWith on MovementAdjustmentResponse {
  /// Returns a callable class that can be used as follows: `instanceOfMovementAdjustmentResponse.copyWith(...)` or like so:`instanceOfMovementAdjustmentResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementAdjustmentResponseCWProxy get copyWith =>
      _$MovementAdjustmentResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementAdjustmentResponse _$MovementAdjustmentResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MovementAdjustmentResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module', 'action']);
  final val = MovementAdjustmentResponse(
    item: $checkedConvert(
      'item',
      (v) => StockMovement.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$MovementAdjustmentResponseToJson(
  MovementAdjustmentResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': instance.action,
};
