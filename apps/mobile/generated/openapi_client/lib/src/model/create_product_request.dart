//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_product_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateProductRequest {
  /// Returns a new [CreateProductRequest] instance.
  CreateProductRequest({

     this.categoryId,

    required  this.name,

     this.sku,

     this.barcode,

    required  this.unit,

     this.description,

     this.minStock,

     this.currentStock,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final String? categoryId;



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
    
    name: r'barcode',
    required: false,
    includeIfNull: false,
  )


  final String? barcode;



  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: false,
  )


  final String unit;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'minStock',
    required: false,
    includeIfNull: false,
  )


  final num? minStock;



  @JsonKey(
    
    name: r'currentStock',
    required: false,
    includeIfNull: false,
  )


  final num? currentStock;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateProductRequest &&
      other.categoryId == categoryId &&
      other.name == name &&
      other.sku == sku &&
      other.barcode == barcode &&
      other.unit == unit &&
      other.description == description &&
      other.minStock == minStock &&
      other.currentStock == currentStock;

    @override
    int get hashCode =>
        (categoryId == null ? 0 : categoryId.hashCode) +
        name.hashCode +
        (sku == null ? 0 : sku.hashCode) +
        (barcode == null ? 0 : barcode.hashCode) +
        unit.hashCode +
        (description == null ? 0 : description.hashCode) +
        minStock.hashCode +
        currentStock.hashCode;

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) => _$CreateProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

