// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_product.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryProductCWProxy {
  InventoryProduct id(String id);

  InventoryProduct name(String name);

  InventoryProduct sku(String? sku);

  InventoryProduct unit(String unit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryProduct(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryProduct(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryProduct call({String id, String name, String? sku, String unit});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryProduct.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryProduct.copyWith.fieldName(...)`
class _$InventoryProductCWProxyImpl implements _$InventoryProductCWProxy {
  const _$InventoryProductCWProxyImpl(this._value);

  final InventoryProduct _value;

  @override
  InventoryProduct id(String id) => this(id: id);

  @override
  InventoryProduct name(String name) => this(name: name);

  @override
  InventoryProduct sku(String? sku) => this(sku: sku);

  @override
  InventoryProduct unit(String unit) => this(unit: unit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryProduct(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryProduct(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryProduct call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? sku = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
  }) {
    return InventoryProduct(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      sku: sku == const $CopyWithPlaceholder()
          ? _value.sku
          // ignore: cast_nullable_to_non_nullable
          : sku as String?,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as String,
    );
  }
}

extension $InventoryProductCopyWith on InventoryProduct {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryProduct.copyWith(...)` or like so:`instanceOfInventoryProduct.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryProductCWProxy get copyWith => _$InventoryProductCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryProduct _$InventoryProductFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InventoryProduct', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'unit']);
      final val = InventoryProduct(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        sku: $checkedConvert('sku', (v) => v as String?),
        unit: $checkedConvert('unit', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$InventoryProductToJson(InventoryProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': ?instance.sku,
      'unit': instance.unit,
    };
