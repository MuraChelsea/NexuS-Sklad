// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_update_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProductUpdateResponseCWProxy {
  ProductUpdateResponse item(Product item);

  ProductUpdateResponse module(Object? module);

  ProductUpdateResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductUpdateResponse call({Product item, Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProductUpdateResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProductUpdateResponse.copyWith.fieldName(...)`
class _$ProductUpdateResponseCWProxyImpl
    implements _$ProductUpdateResponseCWProxy {
  const _$ProductUpdateResponseCWProxyImpl(this._value);

  final ProductUpdateResponse _value;

  @override
  ProductUpdateResponse item(Product item) => this(item: item);

  @override
  ProductUpdateResponse module(Object? module) => this(module: module);

  @override
  ProductUpdateResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductUpdateResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return ProductUpdateResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as Product,
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

extension $ProductUpdateResponseCopyWith on ProductUpdateResponse {
  /// Returns a callable class that can be used as follows: `instanceOfProductUpdateResponse.copyWith(...)` or like so:`instanceOfProductUpdateResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProductUpdateResponseCWProxy get copyWith =>
      _$ProductUpdateResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductUpdateResponse _$ProductUpdateResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ProductUpdateResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module']);
  final val = ProductUpdateResponse(
    item: $checkedConvert(
      'item',
      (v) => Product.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$ProductUpdateResponseToJson(
  ProductUpdateResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': ?instance.action,
};
