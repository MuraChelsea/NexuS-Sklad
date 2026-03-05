// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProductCategoryCWProxy {
  ProductCategory id(String id);

  ProductCategory name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductCategory call({String id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProductCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProductCategory.copyWith.fieldName(...)`
class _$ProductCategoryCWProxyImpl implements _$ProductCategoryCWProxy {
  const _$ProductCategoryCWProxyImpl(this._value);

  final ProductCategory _value;

  @override
  ProductCategory id(String id) => this(id: id);

  @override
  ProductCategory name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProductCategory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProductCategory(...).copyWith(id: 12, name: "My name")
  /// ````
  ProductCategory call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return ProductCategory(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $ProductCategoryCopyWith on ProductCategory {
  /// Returns a callable class that can be used as follows: `instanceOfProductCategory.copyWith(...)` or like so:`instanceOfProductCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProductCategoryCWProxy get copyWith => _$ProductCategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProductCategory', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name']);
      final val = ProductCategory(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
