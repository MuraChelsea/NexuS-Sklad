//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/daily_movement_summary_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_report_movement_summary.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyReportMovementSummary {
  /// Returns a new [DailyReportMovementSummary] instance.
  DailyReportMovementSummary({

     this.INCOME,

     this.EXPENSE,

     this.ADJUSTMENT,

     this.INVENTORY_DIFF,
  });

  @JsonKey(
    
    name: r'INCOME',
    required: false,
    includeIfNull: false,
  )


  final DailyMovementSummaryItem? INCOME;



  @JsonKey(
    
    name: r'EXPENSE',
    required: false,
    includeIfNull: false,
  )


  final DailyMovementSummaryItem? EXPENSE;



  @JsonKey(
    
    name: r'ADJUSTMENT',
    required: false,
    includeIfNull: false,
  )


  final DailyMovementSummaryItem? ADJUSTMENT;



  @JsonKey(
    
    name: r'INVENTORY_DIFF',
    required: false,
    includeIfNull: false,
  )


  final DailyMovementSummaryItem? INVENTORY_DIFF;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyReportMovementSummary &&
      other.INCOME == INCOME &&
      other.EXPENSE == EXPENSE &&
      other.ADJUSTMENT == ADJUSTMENT &&
      other.INVENTORY_DIFF == INVENTORY_DIFF;

    @override
    int get hashCode =>
        INCOME.hashCode +
        EXPENSE.hashCode +
        ADJUSTMENT.hashCode +
        INVENTORY_DIFF.hashCode;

  factory DailyReportMovementSummary.fromJson(Map<String, dynamic> json) => _$DailyReportMovementSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DailyReportMovementSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

