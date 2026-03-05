// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_report_stock.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyReportStockCWProxy {
  DailyReportStock totalProducts(int totalProducts);

  DailyReportStock lowStockCount(int lowStockCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportStock(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportStock(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportStock call({int totalProducts, int lowStockCount});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyReportStock.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyReportStock.copyWith.fieldName(...)`
class _$DailyReportStockCWProxyImpl implements _$DailyReportStockCWProxy {
  const _$DailyReportStockCWProxyImpl(this._value);

  final DailyReportStock _value;

  @override
  DailyReportStock totalProducts(int totalProducts) =>
      this(totalProducts: totalProducts);

  @override
  DailyReportStock lowStockCount(int lowStockCount) =>
      this(lowStockCount: lowStockCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportStock(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportStock(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportStock call({
    Object? totalProducts = const $CopyWithPlaceholder(),
    Object? lowStockCount = const $CopyWithPlaceholder(),
  }) {
    return DailyReportStock(
      totalProducts: totalProducts == const $CopyWithPlaceholder()
          ? _value.totalProducts
          // ignore: cast_nullable_to_non_nullable
          : totalProducts as int,
      lowStockCount: lowStockCount == const $CopyWithPlaceholder()
          ? _value.lowStockCount
          // ignore: cast_nullable_to_non_nullable
          : lowStockCount as int,
    );
  }
}

extension $DailyReportStockCopyWith on DailyReportStock {
  /// Returns a callable class that can be used as follows: `instanceOfDailyReportStock.copyWith(...)` or like so:`instanceOfDailyReportStock.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyReportStockCWProxy get copyWith => _$DailyReportStockCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReportStock _$DailyReportStockFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyReportStock', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['totalProducts', 'lowStockCount']);
  final val = DailyReportStock(
    totalProducts: $checkedConvert('totalProducts', (v) => (v as num).toInt()),
    lowStockCount: $checkedConvert('lowStockCount', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$DailyReportStockToJson(DailyReportStock instance) =>
    <String, dynamic>{
      'totalProducts': instance.totalProducts,
      'lowStockCount': instance.lowStockCount,
    };
