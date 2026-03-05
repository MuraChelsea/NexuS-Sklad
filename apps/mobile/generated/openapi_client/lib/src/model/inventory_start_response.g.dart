// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_start_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryStartResponseCWProxy {
  InventoryStartResponse item(InventorySession item);

  InventoryStartResponse module(Object? module);

  InventoryStartResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryStartResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryStartResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryStartResponse call({
    InventorySession item,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryStartResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryStartResponse.copyWith.fieldName(...)`
class _$InventoryStartResponseCWProxyImpl
    implements _$InventoryStartResponseCWProxy {
  const _$InventoryStartResponseCWProxyImpl(this._value);

  final InventoryStartResponse _value;

  @override
  InventoryStartResponse item(InventorySession item) => this(item: item);

  @override
  InventoryStartResponse module(Object? module) => this(module: module);

  @override
  InventoryStartResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryStartResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryStartResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryStartResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return InventoryStartResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as InventorySession,
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

extension $InventoryStartResponseCopyWith on InventoryStartResponse {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryStartResponse.copyWith(...)` or like so:`instanceOfInventoryStartResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryStartResponseCWProxy get copyWith =>
      _$InventoryStartResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryStartResponse _$InventoryStartResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InventoryStartResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module']);
  final val = InventoryStartResponse(
    item: $checkedConvert(
      'item',
      (v) => InventorySession.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$InventoryStartResponseToJson(
  InventoryStartResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': ?instance.action,
};
