// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementResponseCWProxy {
  MovementResponse item(StockMovement item);

  MovementResponse module(Object? module);

  MovementResponse action(String action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementResponse call({StockMovement item, Object? module, String action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementResponse.copyWith.fieldName(...)`
class _$MovementResponseCWProxyImpl implements _$MovementResponseCWProxy {
  const _$MovementResponseCWProxyImpl(this._value);

  final MovementResponse _value;

  @override
  MovementResponse item(StockMovement item) => this(item: item);

  @override
  MovementResponse module(Object? module) => this(module: module);

  @override
  MovementResponse action(String action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return MovementResponse(
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
          : action as String,
    );
  }
}

extension $MovementResponseCopyWith on MovementResponse {
  /// Returns a callable class that can be used as follows: `instanceOfMovementResponse.copyWith(...)` or like so:`instanceOfMovementResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementResponseCWProxy get copyWith => _$MovementResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementResponse _$MovementResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MovementResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module', 'action']);
      final val = MovementResponse(
        item: $checkedConvert(
          'item',
          (v) => StockMovement.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MovementResponseToJson(MovementResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
      'action': instance.action,
    };
