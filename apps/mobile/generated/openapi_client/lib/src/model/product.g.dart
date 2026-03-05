// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProductCWProxy {
  Product id(String id);

  Product companyId(String companyId);

  Product categoryId(String? categoryId);

  Product name(String name);

  Product sku(String? sku);

  Product barcode(String? barcode);

  Product unit(String unit);

  Product description(String? description);

  Product minStock(String minStock);

  Product currentStock(String currentStock);

  Product createdAt(DateTime createdAt);

  Product updatedAt(DateTime updatedAt);

  Product category(ProductCategory? category);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Product(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Product(...).copyWith(id: 12, name: "My name")
  /// ````
  Product call({
    String id,
    String companyId,
    String? categoryId,
    String name,
    String? sku,
    String? barcode,
    String unit,
    String? description,
    String minStock,
    String currentStock,
    DateTime createdAt,
    DateTime updatedAt,
    ProductCategory? category,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProduct.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProduct.copyWith.fieldName(...)`
class _$ProductCWProxyImpl implements _$ProductCWProxy {
  const _$ProductCWProxyImpl(this._value);

  final Product _value;

  @override
  Product id(String id) => this(id: id);

  @override
  Product companyId(String companyId) => this(companyId: companyId);

  @override
  Product categoryId(String? categoryId) => this(categoryId: categoryId);

  @override
  Product name(String name) => this(name: name);

  @override
  Product sku(String? sku) => this(sku: sku);

  @override
  Product barcode(String? barcode) => this(barcode: barcode);

  @override
  Product unit(String unit) => this(unit: unit);

  @override
  Product description(String? description) => this(description: description);

  @override
  Product minStock(String minStock) => this(minStock: minStock);

  @override
  Product currentStock(String currentStock) => this(currentStock: currentStock);

  @override
  Product createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Product updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  Product category(ProductCategory? category) => this(category: category);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Product(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Product(...).copyWith(id: 12, name: "My name")
  /// ````
  Product call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? sku = const $CopyWithPlaceholder(),
    Object? barcode = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? minStock = const $CopyWithPlaceholder(),
    Object? currentStock = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
  }) {
    return Product(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      companyId: companyId == const $CopyWithPlaceholder()
          ? _value.companyId
          // ignore: cast_nullable_to_non_nullable
          : companyId as String,
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      sku: sku == const $CopyWithPlaceholder()
          ? _value.sku
          // ignore: cast_nullable_to_non_nullable
          : sku as String?,
      barcode: barcode == const $CopyWithPlaceholder()
          ? _value.barcode
          // ignore: cast_nullable_to_non_nullable
          : barcode as String?,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as String,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      minStock: minStock == const $CopyWithPlaceholder()
          ? _value.minStock
          // ignore: cast_nullable_to_non_nullable
          : minStock as String,
      currentStock: currentStock == const $CopyWithPlaceholder()
          ? _value.currentStock
          // ignore: cast_nullable_to_non_nullable
          : currentStock as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as ProductCategory?,
    );
  }
}

extension $ProductCopyWith on Product {
  /// Returns a callable class that can be used as follows: `instanceOfProduct.copyWith(...)` or like so:`instanceOfProduct.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProductCWProxy get copyWith => _$ProductCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Product', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'companyId',
      'name',
      'unit',
      'minStock',
      'currentStock',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = Product(
    id: $checkedConvert('id', (v) => v as String),
    companyId: $checkedConvert('companyId', (v) => v as String),
    categoryId: $checkedConvert('categoryId', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String),
    sku: $checkedConvert('sku', (v) => v as String?),
    barcode: $checkedConvert('barcode', (v) => v as String?),
    unit: $checkedConvert('unit', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    minStock: $checkedConvert('minStock', (v) => v as String),
    currentStock: $checkedConvert('currentStock', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    category: $checkedConvert(
      'category',
      (v) => v == null
          ? null
          : ProductCategory.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'companyId': instance.companyId,
  'categoryId': ?instance.categoryId,
  'name': instance.name,
  'sku': ?instance.sku,
  'barcode': ?instance.barcode,
  'unit': instance.unit,
  'description': ?instance.description,
  'minStock': instance.minStock,
  'currentStock': instance.currentStock,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'category': ?instance.category?.toJson(),
};
