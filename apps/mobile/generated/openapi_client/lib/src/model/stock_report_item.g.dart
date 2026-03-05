// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_report_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StockReportItemCWProxy {
  StockReportItem id(String id);

  StockReportItem name(String name);

  StockReportItem sku(String? sku);

  StockReportItem unit(String unit);

  StockReportItem currentStock(String currentStock);

  StockReportItem minStock(String minStock);

  StockReportItem isLowStock(bool isLowStock);

  StockReportItem category(ProductCategory? category);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReportItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReportItem(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReportItem call({
    String id,
    String name,
    String? sku,
    String unit,
    String currentStock,
    String minStock,
    bool isLowStock,
    ProductCategory? category,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStockReportItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStockReportItem.copyWith.fieldName(...)`
class _$StockReportItemCWProxyImpl implements _$StockReportItemCWProxy {
  const _$StockReportItemCWProxyImpl(this._value);

  final StockReportItem _value;

  @override
  StockReportItem id(String id) => this(id: id);

  @override
  StockReportItem name(String name) => this(name: name);

  @override
  StockReportItem sku(String? sku) => this(sku: sku);

  @override
  StockReportItem unit(String unit) => this(unit: unit);

  @override
  StockReportItem currentStock(String currentStock) =>
      this(currentStock: currentStock);

  @override
  StockReportItem minStock(String minStock) => this(minStock: minStock);

  @override
  StockReportItem isLowStock(bool isLowStock) => this(isLowStock: isLowStock);

  @override
  StockReportItem category(ProductCategory? category) =>
      this(category: category);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReportItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReportItem(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReportItem call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? sku = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? currentStock = const $CopyWithPlaceholder(),
    Object? minStock = const $CopyWithPlaceholder(),
    Object? isLowStock = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
  }) {
    return StockReportItem(
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
      currentStock: currentStock == const $CopyWithPlaceholder()
          ? _value.currentStock
          // ignore: cast_nullable_to_non_nullable
          : currentStock as String,
      minStock: minStock == const $CopyWithPlaceholder()
          ? _value.minStock
          // ignore: cast_nullable_to_non_nullable
          : minStock as String,
      isLowStock: isLowStock == const $CopyWithPlaceholder()
          ? _value.isLowStock
          // ignore: cast_nullable_to_non_nullable
          : isLowStock as bool,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as ProductCategory?,
    );
  }
}

extension $StockReportItemCopyWith on StockReportItem {
  /// Returns a callable class that can be used as follows: `instanceOfStockReportItem.copyWith(...)` or like so:`instanceOfStockReportItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StockReportItemCWProxy get copyWith => _$StockReportItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockReportItem _$StockReportItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StockReportItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'unit',
          'currentStock',
          'minStock',
          'isLowStock',
        ],
      );
      final val = StockReportItem(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        sku: $checkedConvert('sku', (v) => v as String?),
        unit: $checkedConvert('unit', (v) => v as String),
        currentStock: $checkedConvert('currentStock', (v) => v as String),
        minStock: $checkedConvert('minStock', (v) => v as String),
        isLowStock: $checkedConvert('isLowStock', (v) => v as bool),
        category: $checkedConvert(
          'category',
          (v) => v == null
              ? null
              : ProductCategory.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StockReportItemToJson(StockReportItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': ?instance.sku,
      'unit': instance.unit,
      'currentStock': instance.currentStock,
      'minStock': instance.minStock,
      'isLowStock': instance.isLowStock,
      'category': ?instance.category?.toJson(),
    };
