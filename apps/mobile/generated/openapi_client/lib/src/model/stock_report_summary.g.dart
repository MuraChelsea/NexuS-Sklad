// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_report_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StockReportSummaryCWProxy {
  StockReportSummary totalItems(int totalItems);

  StockReportSummary lowStockItems(int lowStockItems);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReportSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReportSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReportSummary call({int totalItems, int lowStockItems});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStockReportSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStockReportSummary.copyWith.fieldName(...)`
class _$StockReportSummaryCWProxyImpl implements _$StockReportSummaryCWProxy {
  const _$StockReportSummaryCWProxyImpl(this._value);

  final StockReportSummary _value;

  @override
  StockReportSummary totalItems(int totalItems) => this(totalItems: totalItems);

  @override
  StockReportSummary lowStockItems(int lowStockItems) =>
      this(lowStockItems: lowStockItems);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReportSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReportSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReportSummary call({
    Object? totalItems = const $CopyWithPlaceholder(),
    Object? lowStockItems = const $CopyWithPlaceholder(),
  }) {
    return StockReportSummary(
      totalItems: totalItems == const $CopyWithPlaceholder()
          ? _value.totalItems
          // ignore: cast_nullable_to_non_nullable
          : totalItems as int,
      lowStockItems: lowStockItems == const $CopyWithPlaceholder()
          ? _value.lowStockItems
          // ignore: cast_nullable_to_non_nullable
          : lowStockItems as int,
    );
  }
}

extension $StockReportSummaryCopyWith on StockReportSummary {
  /// Returns a callable class that can be used as follows: `instanceOfStockReportSummary.copyWith(...)` or like so:`instanceOfStockReportSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StockReportSummaryCWProxy get copyWith =>
      _$StockReportSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockReportSummary _$StockReportSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StockReportSummary', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['totalItems', 'lowStockItems']);
      final val = StockReportSummary(
        totalItems: $checkedConvert('totalItems', (v) => (v as num).toInt()),
        lowStockItems: $checkedConvert(
          'lowStockItems',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StockReportSummaryToJson(StockReportSummary instance) =>
    <String, dynamic>{
      'totalItems': instance.totalItems,
      'lowStockItems': instance.lowStockItems,
    };
