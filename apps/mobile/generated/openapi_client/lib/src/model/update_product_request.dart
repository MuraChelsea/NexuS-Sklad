//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_product_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateProductRequest {
  /// Returns a new [UpdateProductRequest] instance.
  UpdateProductRequest({

     this.categoryId,

     this.name,

     this.sku,

     this.barcode,

     this.unit,

     this.description,

     this.minStock,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final String? categoryId;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



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
    required: false,
    includeIfNull: false,
  )


  final String? unit;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateProductRequest &&
      other.categoryId == categoryId &&
      other.name == name &&
      other.sku == sku &&
      other.barcode == barcode &&
      other.unit == unit &&
      other.description == description &&
      other.minStock == minStock;

    @override
    int get hashCode =>
        (categoryId == null ? 0 : categoryId.hashCode) +
        name.hashCode +
        (sku == null ? 0 : sku.hashCode) +
        (barcode == null ? 0 : barcode.hashCode) +
        unit.hashCode +
        (description == null ? 0 : description.hashCode) +
        minStock.hashCode;

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) => _$UpdateProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProductRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

