// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_product.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementProductCWProxy {
  MovementProduct id(String id);

  MovementProduct name(String name);

  MovementProduct sku(String? sku);

  MovementProduct unit(String unit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementProduct(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementProduct(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementProduct call({String id, String name, String? sku, String unit});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementProduct.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementProduct.copyWith.fieldName(...)`
class _$MovementProductCWProxyImpl implements _$MovementProductCWProxy {
  const _$MovementProductCWProxyImpl(this._value);

  final MovementProduct _value;

  @override
  MovementProduct id(String id) => this(id: id);

  @override
  MovementProduct name(String name) => this(name: name);

  @override
  MovementProduct sku(String? sku) => this(sku: sku);

  @override
  MovementProduct unit(String unit) => this(unit: unit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementProduct(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementProduct(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementProduct call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? sku = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
  }) {
    return MovementProduct(
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

extension $MovementProductCopyWith on MovementProduct {
  /// Returns a callable class that can be used as follows: `instanceOfMovementProduct.copyWith(...)` or like so:`instanceOfMovementProduct.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementProductCWProxy get copyWith => _$MovementProductCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementProduct _$MovementProductFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MovementProduct', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'unit']);
      final val = MovementProduct(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        sku: $checkedConvert('sku', (v) => v as String?),
        unit: $checkedConvert('unit', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MovementProductToJson(MovementProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': ?instance.sku,
      'unit': instance.unit,
    };
