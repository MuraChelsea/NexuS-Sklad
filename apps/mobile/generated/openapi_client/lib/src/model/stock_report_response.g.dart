// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_report_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StockReportResponseCWProxy {
  StockReportResponse item(StockReport item);

  StockReportResponse module(Object? module);

  StockReportResponse report(Object? report);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReportResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReportResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReportResponse call({StockReport item, Object? module, Object? report});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStockReportResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStockReportResponse.copyWith.fieldName(...)`
class _$StockReportResponseCWProxyImpl implements _$StockReportResponseCWProxy {
  const _$StockReportResponseCWProxyImpl(this._value);

  final StockReportResponse _value;

  @override
  StockReportResponse item(StockReport item) => this(item: item);

  @override
  StockReportResponse module(Object? module) => this(module: module);

  @override
  StockReportResponse report(Object? report) => this(report: report);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockReportResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockReportResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  StockReportResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? report = const $CopyWithPlaceholder(),
  }) {
    return StockReportResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as StockReport,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
      report: report == const $CopyWithPlaceholder()
          ? _value.report
          // ignore: cast_nullable_to_non_nullable
          : report as Object?,
    );
  }
}

extension $StockReportResponseCopyWith on StockReportResponse {
  /// Returns a callable class that can be used as follows: `instanceOfStockReportResponse.copyWith(...)` or like so:`instanceOfStockReportResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StockReportResponseCWProxy get copyWith =>
      _$StockReportResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockReportResponse _$StockReportResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StockReportResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module', 'report']);
      final val = StockReportResponse(
        item: $checkedConvert(
          'item',
          (v) => StockReport.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        report: $checkedConvert('report', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$StockReportResponseToJson(
  StockReportResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'report': instance.report,
};
