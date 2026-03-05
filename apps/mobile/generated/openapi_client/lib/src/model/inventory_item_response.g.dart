// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryItemResponseCWProxy {
  InventoryItemResponse item(InventoryItem item);

  InventoryItemResponse module(Object? module);

  InventoryItemResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryItemResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryItemResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryItemResponse call({
    InventoryItem item,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryItemResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryItemResponse.copyWith.fieldName(...)`
class _$InventoryItemResponseCWProxyImpl
    implements _$InventoryItemResponseCWProxy {
  const _$InventoryItemResponseCWProxyImpl(this._value);

  final InventoryItemResponse _value;

  @override
  InventoryItemResponse item(InventoryItem item) => this(item: item);

  @override
  InventoryItemResponse module(Object? module) => this(module: module);

  @override
  InventoryItemResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryItemResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryItemResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryItemResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return InventoryItemResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as InventoryItem,
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

extension $InventoryItemResponseCopyWith on InventoryItemResponse {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryItemResponse.copyWith(...)` or like so:`instanceOfInventoryItemResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryItemResponseCWProxy get copyWith =>
      _$InventoryItemResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItemResponse _$InventoryItemResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InventoryItemResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module', 'action']);
  final val = InventoryItemResponse(
    item: $checkedConvert(
      'item',
      (v) => InventoryItem.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$InventoryItemResponseToJson(
  InventoryItemResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': instance.action,
};
