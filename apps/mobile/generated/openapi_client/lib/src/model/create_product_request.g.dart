// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateProductRequestCWProxy {
  CreateProductRequest categoryId(String? categoryId);

  CreateProductRequest name(String name);

  CreateProductRequest sku(String? sku);

  CreateProductRequest barcode(String? barcode);

  CreateProductRequest unit(String unit);

  CreateProductRequest description(String? description);

  CreateProductRequest minStock(num? minStock);

  CreateProductRequest currentStock(num? currentStock);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateProductRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateProductRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateProductRequest call({
    String? categoryId,
    String name,
    String? sku,
    String? barcode,
    String unit,
    String? description,
    num? minStock,
    num? currentStock,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateProductRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateProductRequest.copyWith.fieldName(...)`
class _$CreateProductRequestCWProxyImpl
    implements _$CreateProductRequestCWProxy {
  const _$CreateProductRequestCWProxyImpl(this._value);

  final CreateProductRequest _value;

  @override
  CreateProductRequest categoryId(String? categoryId) =>
      this(categoryId: categoryId);

  @override
  CreateProductRequest name(String name) => this(name: name);

  @override
  CreateProductRequest sku(String? sku) => this(sku: sku);

  @override
  CreateProductRequest barcode(String? barcode) => this(barcode: barcode);

  @override
  CreateProductRequest unit(String unit) => this(unit: unit);

  @override
  CreateProductRequest description(String? description) =>
      this(description: description);

  @override
  CreateProductRequest minStock(num? minStock) => this(minStock: minStock);

  @override
  CreateProductRequest currentStock(num? currentStock) =>
      this(currentStock: currentStock);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateProductRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateProductRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateProductRequest call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? sku = const $CopyWithPlaceholder(),
    Object? barcode = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? minStock = const $CopyWithPlaceholder(),
    Object? currentStock = const $CopyWithPlaceholder(),
  }) {
    return CreateProductRequest(
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
          : minStock as num?,
      currentStock: currentStock == const $CopyWithPlaceholder()
          ? _value.currentStock
          // ignore: cast_nullable_to_non_nullable
          : currentStock as num?,
    );
  }
}

extension $CreateProductRequestCopyWith on CreateProductRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateProductRequest.copyWith(...)` or like so:`instanceOfCreateProductRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateProductRequestCWProxy get copyWith =>
      _$CreateProductRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductRequest _$CreateProductRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateProductRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'unit']);
  final val = CreateProductRequest(
    categoryId: $checkedConvert('categoryId', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String),
    sku: $checkedConvert('sku', (v) => v as String?),
    barcode: $checkedConvert('barcode', (v) => v as String?),
    unit: $checkedConvert('unit', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    minStock: $checkedConvert('minStock', (v) => v as num?),
    currentStock: $checkedConvert('currentStock', (v) => v as num?),
  );
  return val;
});

Map<String, dynamic> _$CreateProductRequestToJson(
  CreateProductRequest instance,
) => <String, dynamic>{
  'categoryId': ?instance.categoryId,
  'name': instance.name,
  'sku': ?instance.sku,
  'barcode': ?instance.barcode,
  'unit': instance.unit,
  'description': ?instance.description,
  'minStock': ?instance.minStock,
  'currentStock': ?instance.currentStock,
};
