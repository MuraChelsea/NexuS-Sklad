//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_report_stock.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyReportStock {
  /// Returns a new [DailyReportStock] instance.
  DailyReportStock({

    required  this.totalProducts,

    required  this.lowStockCount,
  });

  @JsonKey(
    
    name: r'totalProducts',
    required: true,
    includeIfNull: false,
  )


  final int totalProducts;



  @JsonKey(
    
    name: r'lowStockCount',
    required: true,
    includeIfNull: false,
  )


  final int lowStockCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyReportStock &&
      other.totalProducts == totalProducts &&
      other.lowStockCount == lowStockCount;

    @override
    int get hashCode =>
        totalProducts.hashCode +
        lowStockCount.hashCode;

  factory DailyReportStock.fromJson(Map<String, dynamic> json) => _$DailyReportStockFromJson(json);

  Map<String, dynamic> toJson() => _$DailyReportStockToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

