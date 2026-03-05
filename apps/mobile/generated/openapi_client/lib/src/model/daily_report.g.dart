// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_report.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyReportCWProxy {
  DailyReport date(DateTime date);

  DailyReport movementSummary(DailyReportMovementSummary movementSummary);

  DailyReport inventory(DailyReportInventory inventory);

  DailyReport stock(DailyReportStock stock);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReport(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReport call({
    DateTime date,
    DailyReportMovementSummary movementSummary,
    DailyReportInventory inventory,
    DailyReportStock stock,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyReport.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyReport.copyWith.fieldName(...)`
class _$DailyReportCWProxyImpl implements _$DailyReportCWProxy {
  const _$DailyReportCWProxyImpl(this._value);

  final DailyReport _value;

  @override
  DailyReport date(DateTime date) => this(date: date);

  @override
  DailyReport movementSummary(DailyReportMovementSummary movementSummary) =>
      this(movementSummary: movementSummary);

  @override
  DailyReport inventory(DailyReportInventory inventory) =>
      this(inventory: inventory);

  @override
  DailyReport stock(DailyReportStock stock) => this(stock: stock);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReport(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReport call({
    Object? date = const $CopyWithPlaceholder(),
    Object? movementSummary = const $CopyWithPlaceholder(),
    Object? inventory = const $CopyWithPlaceholder(),
    Object? stock = const $CopyWithPlaceholder(),
  }) {
    return DailyReport(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime,
      movementSummary: movementSummary == const $CopyWithPlaceholder()
          ? _value.movementSummary
          // ignore: cast_nullable_to_non_nullable
          : movementSummary as DailyReportMovementSummary,
      inventory: inventory == const $CopyWithPlaceholder()
          ? _value.inventory
          // ignore: cast_nullable_to_non_nullable
          : inventory as DailyReportInventory,
      stock: stock == const $CopyWithPlaceholder()
          ? _value.stock
          // ignore: cast_nullable_to_non_nullable
          : stock as DailyReportStock,
    );
  }
}

extension $DailyReportCopyWith on DailyReport {
  /// Returns a callable class that can be used as follows: `instanceOfDailyReport.copyWith(...)` or like so:`instanceOfDailyReport.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyReportCWProxy get copyWith => _$DailyReportCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReport _$DailyReportFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DailyReport', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['date', 'movementSummary', 'inventory', 'stock'],
      );
      final val = DailyReport(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        movementSummary: $checkedConvert(
          'movementSummary',
          (v) => DailyReportMovementSummary.fromJson(v as Map<String, dynamic>),
        ),
        inventory: $checkedConvert(
          'inventory',
          (v) => DailyReportInventory.fromJson(v as Map<String, dynamic>),
        ),
        stock: $checkedConvert(
          'stock',
          (v) => DailyReportStock.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DailyReportToJson(DailyReport instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'movementSummary': instance.movementSummary.toJson(),
      'inventory': instance.inventory.toJson(),
      'stock': instance.stock.toJson(),
    };
