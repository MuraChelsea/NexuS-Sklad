// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryResponseCWProxy {
  InventoryResponse item(InventorySession item);

  InventoryResponse module(Object? module);

  InventoryResponse action(String? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryResponse call({
    InventorySession item,
    Object? module,
    String? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryResponse.copyWith.fieldName(...)`
class _$InventoryResponseCWProxyImpl implements _$InventoryResponseCWProxy {
  const _$InventoryResponseCWProxyImpl(this._value);

  final InventoryResponse _value;

  @override
  InventoryResponse item(InventorySession item) => this(item: item);

  @override
  InventoryResponse module(Object? module) => this(module: module);

  @override
  InventoryResponse action(String? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return InventoryResponse(
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
          : action as String?,
    );
  }
}

extension $InventoryResponseCopyWith on InventoryResponse {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryResponse.copyWith(...)` or like so:`instanceOfInventoryResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryResponseCWProxy get copyWith =>
      _$InventoryResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryResponse _$InventoryResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InventoryResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module']);
      final val = InventoryResponse(
        item: $checkedConvert(
          'item',
          (v) => InventorySession.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$InventoryResponseToJson(InventoryResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
      'action': ?instance.action,
    };
