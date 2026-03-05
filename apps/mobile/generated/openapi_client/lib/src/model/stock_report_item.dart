//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/product_category.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_report_item.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StockReportItem {
  /// Returns a new [StockReportItem] instance.
  StockReportItem({

    required  this.id,

    required  this.name,

     this.sku,

    required  this.unit,

    required  this.currentStock,

    required  this.minStock,

    required  this.isLowStock,

     this.category,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'sku',
    required: false,
    includeIfNull: false,
  )


  final String? sku;



  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: false,
  )


  final String unit;



  @JsonKey(
    
    name: r'currentStock',
    required: true,
    includeIfNull: false,
  )


  final String currentStock;



  @JsonKey(
    
    name: r'minStock',
    required: true,
    includeIfNull: false,
  )


  final String minStock;



  @JsonKey(
    
    name: r'isLowStock',
    required: true,
    includeIfNull: false,
  )


  final bool isLowStock;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final ProductCategory? category;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StockReportItem &&
      other.id == id &&
      other.name == name &&
      other.sku == sku &&
      other.unit == unit &&
      other.currentStock == currentStock &&
      other.minStock == minStock &&
      other.isLowStock == isLowStock &&
      other.category == category;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        (sku == null ? 0 : sku.hashCode) +
        unit.hashCode +
        currentStock.hashCode +
        minStock.hashCode +
        isLowStock.hashCode +
        (category == null ? 0 : category.hashCode);

  factory StockReportItem.fromJson(Map<String, dynamic> json) => _$StockReportItemFromJson(json);

  Map<String, dynamic> toJson() => _$StockReportItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

