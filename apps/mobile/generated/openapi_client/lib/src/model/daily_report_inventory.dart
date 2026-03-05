//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/daily_inventory_session.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_report_inventory.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyReportInventory {
  /// Returns a new [DailyReportInventory] instance.
  DailyReportInventory({

    required  this.sessionsCount,

    required  this.sessions,
  });

  @JsonKey(
    
    name: r'sessionsCount',
    required: true,
    includeIfNull: false,
  )


  final int sessionsCount;



  @JsonKey(
    
    name: r'sessions',
    required: true,
    includeIfNull: false,
  )


  final List<DailyInventorySession> sessions;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyReportInventory &&
      other.sessionsCount == sessionsCount &&
      other.sessions == sessions;

    @override
    int get hashCode =>
        sessionsCount.hashCode +
        sessions.hashCode;

  factory DailyReportInventory.fromJson(Map<String, dynamic> json) => _$DailyReportInventoryFromJson(json);

  Map<String, dynamic> toJson() => _$DailyReportInventoryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

