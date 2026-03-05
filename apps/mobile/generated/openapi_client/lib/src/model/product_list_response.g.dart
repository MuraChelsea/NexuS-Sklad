// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProductListResponseCWProxy {
  ProductListResponse items(List<Product> items);

  ProductListResponse module(Object? module);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductListResponse call({List<Product> items, Object? module});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProductListResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProductListResponse.copyWith.fieldName(...)`
class _$ProductListResponseCWProxyImpl implements _$ProductListResponseCWProxy {
  const _$ProductListResponseCWProxyImpl(this._value);

  final ProductListResponse _value;

  @override
  ProductListResponse items(List<Product> items) => this(items: items);

  @override
  ProductListResponse module(Object? module) => this(module: module);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductListResponse call({
    Object? items = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
  }) {
    return ProductListResponse(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Product>,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
    );
  }
}

extension $ProductListResponseCopyWith on ProductListResponse {
  /// Returns a callable class that can be used as follows: `instanceOfProductListResponse.copyWith(...)` or like so:`instanceOfProductListResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProductListResponseCWProxy get copyWith =>
      _$ProductListResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListResponse _$ProductListResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProductListResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'module']);
      final val = ProductListResponse(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        module: $checkedConvert('module', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$ProductListResponseToJson(
  ProductListResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'module': instance.module,
};
