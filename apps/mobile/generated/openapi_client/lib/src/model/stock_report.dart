//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/stock_report_item.dart';
import 'package:nexussklad_openapi_client/src/model/stock_report_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_report.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StockReport {
  /// Returns a new [StockReport] instance.
  StockReport({

    required  this.summary,

    required  this.items,
  });

  @JsonKey(
    
    name: r'summary',
    required: true,
    includeIfNull: false,
  )


  final StockReportSummary summary;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<StockReportItem> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StockReport &&
      other.summary == summary &&
      other.items == items;

    @override
    int get hashCode =>
        summary.hashCode +
        items.hashCode;

  factory StockReport.fromJson(Map<String, dynamic> json) => _$StockReportFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

