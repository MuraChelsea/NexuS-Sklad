//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/daily_report.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_report_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyReportResponse {
  /// Returns a new [DailyReportResponse] instance.
  DailyReportResponse({

    required  this.item,

    required  this.module,

    required  this.report,
  });

  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final DailyReport item;



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
    bool operator ==(Object other) => identical(this, other) || other is DailyReportResponse &&
      other.item == item &&
      other.module == module &&
      other.report == report;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode) +
        (report == null ? 0 : report.hashCode);

  factory DailyReportResponse.fromJson(Map<String, dynamic> json) => _$DailyReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DailyReportResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

