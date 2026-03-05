// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProductResponseCWProxy {
  ProductResponse item(Product item);

  ProductResponse module(Object? module);

  ProductResponse action(String? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductResponse call({Product item, Object? module, String? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProductResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProductResponse.copyWith.fieldName(...)`
class _$ProductResponseCWProxyImpl implements _$ProductResponseCWProxy {
  const _$ProductResponseCWProxyImpl(this._value);

  final ProductResponse _value;

  @override
  ProductResponse item(Product item) => this(item: item);

  @override
  ProductResponse module(Object? module) => this(module: module);

  @override
  ProductResponse action(String? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return ProductResponse(
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
          : action as String?,
    );
  }
}

extension $ProductResponseCopyWith on ProductResponse {
  /// Returns a callable class that can be used as follows: `instanceOfProductResponse.copyWith(...)` or like so:`instanceOfProductResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProductResponseCWProxy get copyWith => _$ProductResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProductResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module']);
      final val = ProductResponse(
        item: $checkedConvert(
          'item',
          (v) => Product.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
      'action': ?instance.action,
    };
