// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_list_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementListResponseCWProxy {
  MovementListResponse items(List<StockMovement> items);

  MovementListResponse module(Object? module);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementListResponse call({List<StockMovement> items, Object? module});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementListResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementListResponse.copyWith.fieldName(...)`
class _$MovementListResponseCWProxyImpl
    implements _$MovementListResponseCWProxy {
  const _$MovementListResponseCWProxyImpl(this._value);

  final MovementListResponse _value;

  @override
  MovementListResponse items(List<StockMovement> items) => this(items: items);

  @override
  MovementListResponse module(Object? module) => this(module: module);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementListResponse call({
    Object? items = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
  }) {
    return MovementListResponse(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<StockMovement>,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
    );
  }
}

extension $MovementListResponseCopyWith on MovementListResponse {
  /// Returns a callable class that can be used as follows: `instanceOfMovementListResponse.copyWith(...)` or like so:`instanceOfMovementListResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementListResponseCWProxy get copyWith =>
      _$MovementListResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementListResponse _$MovementListResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MovementListResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'module']);
  final val = MovementListResponse(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => StockMovement.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    module: $checkedConvert('module', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$MovementListResponseToJson(
  MovementListResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'module': instance.module,
};
