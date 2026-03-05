// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_report_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyReportResponseCWProxy {
  DailyReportResponse item(DailyReport item);

  DailyReportResponse module(Object? module);

  DailyReportResponse report(Object? report);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportResponse call({DailyReport item, Object? module, Object? report});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyReportResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyReportResponse.copyWith.fieldName(...)`
class _$DailyReportResponseCWProxyImpl implements _$DailyReportResponseCWProxy {
  const _$DailyReportResponseCWProxyImpl(this._value);

  final DailyReportResponse _value;

  @override
  DailyReportResponse item(DailyReport item) => this(item: item);

  @override
  DailyReportResponse module(Object? module) => this(module: module);

  @override
  DailyReportResponse report(Object? report) => this(report: report);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? report = const $CopyWithPlaceholder(),
  }) {
    return DailyReportResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as DailyReport,
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

extension $DailyReportResponseCopyWith on DailyReportResponse {
  /// Returns a callable class that can be used as follows: `instanceOfDailyReportResponse.copyWith(...)` or like so:`instanceOfDailyReportResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyReportResponseCWProxy get copyWith =>
      _$DailyReportResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReportResponse _$DailyReportResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DailyReportResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module', 'report']);
      final val = DailyReportResponse(
        item: $checkedConvert(
          'item',
          (v) => DailyReport.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        report: $checkedConvert('report', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$DailyReportResponseToJson(
  DailyReportResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'report': instance.report,
};
