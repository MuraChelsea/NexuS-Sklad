//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_report_summary.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StockReportSummary {
  /// Returns a new [StockReportSummary] instance.
  StockReportSummary({

    required  this.totalItems,

    required  this.lowStockItems,
  });

  @JsonKey(
    
    name: r'totalItems',
    required: true,
    includeIfNull: false,
  )


  final int totalItems;



  @JsonKey(
    
    name: r'lowStockItems',
    required: true,
    includeIfNull: false,
  )


  final int lowStockItems;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StockReportSummary &&
      other.totalItems == totalItems &&
      other.lowStockItems == lowStockItems;

    @override
    int get hashCode =>
        totalItems.hashCode +
        lowStockItems.hashCode;

  factory StockReportSummary.fromJson(Map<String, dynamic> json) => _$StockReportSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

