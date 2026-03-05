// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_report.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StockReportCWProxy {
  StockReport summary(StockReportSummary summary);

  StockReport items(List<StockReportItem> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReport(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReport call({StockReportSummary summary, List<StockReportItem> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStockReport.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStockReport.copyWith.fieldName(...)`
class _$StockReportCWProxyImpl implements _$StockReportCWProxy {
  const _$StockReportCWProxyImpl(this._value);

  final StockReport _value;

  @override
  StockReport summary(StockReportSummary summary) => this(summary: summary);

  @override
  StockReport items(List<StockReportItem> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReport(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReport call({
    Object? summary = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return StockReport(
      summary: summary == const $CopyWithPlaceholder()
          ? _value.summary
          // ignore: cast_nullable_to_non_nullable
          : summary as StockReportSummary,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<StockReportItem>,
    );
  }
}

extension $StockReportCopyWith on StockReport {
  /// Returns a callable class that can be used as follows: `instanceOfStockReport.copyWith(...)` or like so:`instanceOfStockReport.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StockReportCWProxy get copyWith => _$StockReportCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockReport _$StockReportFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StockReport', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['summary', 'items']);
      final val = StockReport(
        summary: $checkedConvert(
          'summary',
          (v) => StockReportSummary.fromJson(v as Map<String, dynamic>),
        ),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => StockReportItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StockReportToJson(StockReport instance) =>
    <String, dynamic>{
      'summary': instance.summary.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
