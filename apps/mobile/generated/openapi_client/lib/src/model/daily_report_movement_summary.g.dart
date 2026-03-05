// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_report_movement_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyReportMovementSummaryCWProxy {
  DailyReportMovementSummary INCOME(DailyMovementSummaryItem? INCOME);

  DailyReportMovementSummary EXPENSE(DailyMovementSummaryItem? EXPENSE);

  DailyReportMovementSummary ADJUSTMENT(DailyMovementSummaryItem? ADJUSTMENT);

  DailyReportMovementSummary INVENTORY_DIFF(
    DailyMovementSummaryItem? INVENTORY_DIFF,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportMovementSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportMovementSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportMovementSummary call({
    DailyMovementSummaryItem? INCOME,
    DailyMovementSummaryItem? EXPENSE,
    DailyMovementSummaryItem? ADJUSTMENT,
    DailyMovementSummaryItem? INVENTORY_DIFF,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyReportMovementSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyReportMovementSummary.copyWith.fieldName(...)`
class _$DailyReportMovementSummaryCWProxyImpl
    implements _$DailyReportMovementSummaryCWProxy {
  const _$DailyReportMovementSummaryCWProxyImpl(this._value);

  final DailyReportMovementSummary _value;

  @override
  DailyReportMovementSummary INCOME(DailyMovementSummaryItem? INCOME) =>
      this(INCOME: INCOME);

  @override
  DailyReportMovementSummary EXPENSE(DailyMovementSummaryItem? EXPENSE) =>
      this(EXPENSE: EXPENSE);

  @override
  DailyReportMovementSummary ADJUSTMENT(DailyMovementSummaryItem? ADJUSTMENT) =>
      this(ADJUSTMENT: ADJUSTMENT);

  @override
  DailyReportMovementSummary INVENTORY_DIFF(
    DailyMovementSummaryItem? INVENTORY_DIFF,
  ) => this(INVENTORY_DIFF: INVENTORY_DIFF);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportMovementSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportMovementSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportMovementSummary call({
    Object? INCOME = const $CopyWithPlaceholder(),
    Object? EXPENSE = const $CopyWithPlaceholder(),
    Object? ADJUSTMENT = const $CopyWithPlaceholder(),
    Object? INVENTORY_DIFF = const $CopyWithPlaceholder(),
  }) {
    return DailyReportMovementSummary(
      INCOME: INCOME == const $CopyWithPlaceholder()
          ? _value.INCOME
          // ignore: cast_nullable_to_non_nullable
          : INCOME as DailyMovementSummaryItem?,
      EXPENSE: EXPENSE == const $CopyWithPlaceholder()
          ? _value.EXPENSE
          // ignore: cast_nullable_to_non_nullable
          : EXPENSE as DailyMovementSummaryItem?,
      ADJUSTMENT: ADJUSTMENT == const $CopyWithPlaceholder()
          ? _value.ADJUSTMENT
          // ignore: cast_nullable_to_non_nullable
          : ADJUSTMENT as DailyMovementSummaryItem?,
      INVENTORY_DIFF: INVENTORY_DIFF == const $CopyWithPlaceholder()
          ? _value.INVENTORY_DIFF
          // ignore: cast_nullable_to_non_nullable
          : INVENTORY_DIFF as DailyMovementSummaryItem?,
    );
  }
}

extension $DailyReportMovementSummaryCopyWith on DailyReportMovementSummary {
  /// Returns a callable class that can be used as follows: `instanceOfDailyReportMovementSummary.copyWith(...)` or like so:`instanceOfDailyReportMovementSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyReportMovementSummaryCWProxy get copyWith =>
      _$DailyReportMovementSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReportMovementSummary _$DailyReportMovementSummaryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyReportMovementSummary', json, ($checkedConvert) {
  final val = DailyReportMovementSummary(
    INCOME: $checkedConvert(
      'INCOME',
      (v) => v == null
          ? null
          : DailyMovementSummaryItem.fromJson(v as Map<String, dynamic>),
    ),
    EXPENSE: $checkedConvert(
      'EXPENSE',
      (v) => v == null
          ? null
          : DailyMovementSummaryItem.fromJson(v as Map<String, dynamic>),
    ),
    ADJUSTMENT: $checkedConvert(
      'ADJUSTMENT',
      (v) => v == null
          ? null
          : DailyMovementSummaryItem.fromJson(v as Map<String, dynamic>),
    ),
    INVENTORY_DIFF: $checkedConvert(
      'INVENTORY_DIFF',
      (v) => v == null
          ? null
          : DailyMovementSummaryItem.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$DailyReportMovementSummaryToJson(
  DailyReportMovementSummary instance,
) => <String, dynamic>{
  'INCOME': ?instance.INCOME?.toJson(),
  'EXPENSE': ?instance.EXPENSE?.toJson(),
  'ADJUSTMENT': ?instance.ADJUSTMENT?.toJson(),
  'INVENTORY_DIFF': ?instance.INVENTORY_DIFF?.toJson(),
};
