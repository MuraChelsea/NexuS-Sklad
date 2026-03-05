//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/stock_report.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_report_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StockReportResponse {
  /// Returns a new [StockReportResponse] instance.
  StockReportResponse({

    required  this.item,

    required  this.module,

    required  this.report,
  });

  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final StockReport item;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;



  @JsonKey(
    
    name: r'report',
    required: true,
    includeIfNull: true,
  )


  final Object? report;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StockReportResponse &&
      other.item == item &&
      other.module == module &&
      other.report == report;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode) +
        (report == null ? 0 : report.hashCode);

  factory StockReportResponse.fromJson(Map<String, dynamic> json) => _$StockReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

