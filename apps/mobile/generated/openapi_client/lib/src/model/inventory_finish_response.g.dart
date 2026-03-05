// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_finish_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryFinishResponseCWProxy {
  InventoryFinishResponse item(InventorySession item);

  InventoryFinishResponse module(Object? module);

  InventoryFinishResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryFinishResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryFinishResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryFinishResponse call({
    InventorySession item,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryFinishResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryFinishResponse.copyWith.fieldName(...)`
class _$InventoryFinishResponseCWProxyImpl
    implements _$InventoryFinishResponseCWProxy {
  const _$InventoryFinishResponseCWProxyImpl(this._value);

  final InventoryFinishResponse _value;

  @override
  InventoryFinishResponse item(InventorySession item) => this(item: item);

  @override
  InventoryFinishResponse module(Object? module) => this(module: module);

  @override
  InventoryFinishResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryFinishResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryFinishResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryFinishResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return InventoryFinishResponse(
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

extension $InventoryFinishResponseCopyWith on InventoryFinishResponse {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryFinishResponse.copyWith(...)` or like so:`instanceOfInventoryFinishResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryFinishResponseCWProxy get copyWith =>
      _$InventoryFinishResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryFinishResponse _$InventoryFinishResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InventoryFinishResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module']);
  final val = InventoryFinishResponse(
    item: $checkedConvert(
      'item',
      (v) => InventorySession.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$InventoryFinishResponseToJson(
  InventoryFinishResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': ?instance.action,
};
