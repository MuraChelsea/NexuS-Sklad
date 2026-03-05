//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/daily_report_stock.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report_movement_summary.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report_inventory.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_report.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyReport {
  /// Returns a new [DailyReport] instance.
  DailyReport({

    required  this.date,

    required  this.movementSummary,

    required  this.inventory,

    required  this.stock,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



  @JsonKey(
    
    name: r'movementSummary',
    required: true,
    includeIfNull: false,
  )


  final DailyReportMovementSummary movementSummary;



  @JsonKey(
    
    name: r'inventory',
    required: true,
    includeIfNull: false,
  )


  final DailyReportInventory inventory;



  @JsonKey(
    
    name: r'stock',
    required: true,
    includeIfNull: false,
  )


  final DailyReportStock stock;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyReport &&
      other.date == date &&
      other.movementSummary == movementSummary &&
      other.inventory == inventory &&
      other.stock == stock;

    @override
    int get hashCode =>
        date.hashCode +
        movementSummary.hashCode +
        inventory.hashCode +
        stock.hashCode;

  factory DailyReport.fromJson(Map<String, dynamic> json) => _$DailyReportFromJson(json);

  Map<String, dynamic> toJson() => _$DailyReportToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

