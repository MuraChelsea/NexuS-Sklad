// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateProductRequestCWProxy {
  UpdateProductRequest categoryId(String? categoryId);

  UpdateProductRequest name(String? name);

  UpdateProductRequest sku(String? sku);

  UpdateProductRequest barcode(String? barcode);

  UpdateProductRequest unit(String? unit);

  UpdateProductRequest description(String? description);

  UpdateProductRequest minStock(num? minStock);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateProductRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateProductRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateProductRequest call({
    String? categoryId,
    String? name,
    String? sku,
    String? barcode,
    String? unit,
    String? description,
    num? minStock,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateProductRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateProductRequest.copyWith.fieldName(...)`
class _$UpdateProductRequestCWProxyImpl
    implements _$UpdateProductRequestCWProxy {
  const _$UpdateProductRequestCWProxyImpl(this._value);

  final UpdateProductRequest _value;

  @override
  UpdateProductRequest categoryId(String? categoryId) =>
      this(categoryId: categoryId);

  @override
  UpdateProductRequest name(String? name) => this(name: name);

  @override
  UpdateProductRequest sku(String? sku) => this(sku: sku);

  @override
  UpdateProductRequest barcode(String? barcode) => this(barcode: barcode);

  @override
  UpdateProductRequest unit(String? unit) => this(unit: unit);

  @override
  UpdateProductRequest description(String? description) =>
      this(description: description);

  @override
  UpdateProductRequest minStock(num? minStock) => this(minStock: minStock);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateProductRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateProductRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateProductRequest call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? sku = const $CopyWithPlaceholder(),
    Object? barcode = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? minStock = const $CopyWithPlaceholder(),
  }) {
    return UpdateProductRequest(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
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
          : unit as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      minStock: minStock == const $CopyWithPlaceholder()
          ? _value.minStock
          // ignore: cast_nullable_to_non_nullable
          : minStock as num?,
    );
  }
}

extension $UpdateProductRequestCopyWith on UpdateProductRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateProductRequest.copyWith(...)` or like so:`instanceOfUpdateProductRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateProductRequestCWProxy get copyWith =>
      _$UpdateProductRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProductRequest _$UpdateProductRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateProductRequest', json, ($checkedConvert) {
  final val = UpdateProductRequest(
    categoryId: $checkedConvert('categoryId', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String?),
    sku: $checkedConvert('sku', (v) => v as String?),
    barcode: $checkedConvert('barcode', (v) => v as String?),
    unit: $checkedConvert('unit', (v) => v as String?),
    description: $checkedConvert('description', (v) => v as String?),
    minStock: $checkedConvert('minStock', (v) => v as num?),
  );
  return val;
});

Map<String, dynamic> _$UpdateProductRequestToJson(
  UpdateProductRequest instance,
) => <String, dynamic>{
  'categoryId': ?instance.categoryId,
  'name': ?instance.name,
  'sku': ?instance.sku,
  'barcode': ?instance.barcode,
  'unit': ?instance.unit,
  'description': ?instance.description,
  'minStock': ?instance.minStock,
};
