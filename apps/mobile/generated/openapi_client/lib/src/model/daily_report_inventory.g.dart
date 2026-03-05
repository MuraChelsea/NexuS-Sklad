// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_report_inventory.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyReportInventoryCWProxy {
  DailyReportInventory sessionsCount(int sessionsCount);

  DailyReportInventory sessions(List<DailyInventorySession> sessions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportInventory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportInventory(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportInventory call({
    int sessionsCount,
    List<DailyInventorySession> sessions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyReportInventory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyReportInventory.copyWith.fieldName(...)`
class _$DailyReportInventoryCWProxyImpl
    implements _$DailyReportInventoryCWProxy {
  const _$DailyReportInventoryCWProxyImpl(this._value);

  final DailyReportInventory _value;

  @override
  DailyReportInventory sessionsCount(int sessionsCount) =>
      this(sessionsCount: sessionsCount);

  @override
  DailyReportInventory sessions(List<DailyInventorySession> sessions) =>
      this(sessions: sessions);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyReportInventory(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyReportInventory(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyReportInventory call({
    Object? sessionsCount = const $CopyWithPlaceholder(),
    Object? sessions = const $CopyWithPlaceholder(),
  }) {
    return DailyReportInventory(
      sessionsCount: sessionsCount == const $CopyWithPlaceholder()
          ? _value.sessionsCount
          // ignore: cast_nullable_to_non_nullable
          : sessionsCount as int,
      sessions: sessions == const $CopyWithPlaceholder()
          ? _value.sessions
          // ignore: cast_nullable_to_non_nullable
          : sessions as List<DailyInventorySession>,
    );
  }
}

extension $DailyReportInventoryCopyWith on DailyReportInventory {
  /// Returns a callable class that can be used as follows: `instanceOfDailyReportInventory.copyWith(...)` or like so:`instanceOfDailyReportInventory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyReportInventoryCWProxy get copyWith =>
      _$DailyReportInventoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReportInventory _$DailyReportInventoryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DailyReportInventory', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['sessionsCount', 'sessions']);
  final val = DailyReportInventory(
    sessionsCount: $checkedConvert('sessionsCount', (v) => (v as num).toInt()),
    sessions: $checkedConvert(
      'sessions',
      (v) => (v as List<dynamic>)
          .map((e) => DailyInventorySession.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$DailyReportInventoryToJson(
  DailyReportInventory instance,
) => <String, dynamic>{
  'sessionsCount': instance.sessionsCount,
  'sessions': instance.sessions.map((e) => e.toJson()).toList(),
};
