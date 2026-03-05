//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/product_category.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Product {
  /// Returns a new [Product] instance.
  Product({

    required  this.id,

    required  this.companyId,

     this.categoryId,

    required  this.name,

     this.sku,

     this.barcode,

    required  this.unit,

     this.description,

    required  this.minStock,

    required  this.currentStock,

    required  this.createdAt,

    required  this.updatedAt,

     this.category,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'companyId',
    required: true,
    includeIfNull: false,
  )


  final String companyId;



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
    required: true,
    includeIfNull: false,
  )


  final String minStock;



  @JsonKey(
    
    name: r'currentStock',
    required: true,
    includeIfNull: false,
  )


  final String currentStock;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final ProductCategory? category;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Product &&
      other.id == id &&
      other.companyId == companyId &&
      other.categoryId == categoryId &&
      other.name == name &&
      other.sku == sku &&
      other.barcode == barcode &&
      other.unit == unit &&
      other.description == description &&
      other.minStock == minStock &&
      other.currentStock == currentStock &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.category == category;

    @override
    int get hashCode =>
        id.hashCode +
        companyId.hashCode +
        (categoryId == null ? 0 : categoryId.hashCode) +
        name.hashCode +
        (sku == null ? 0 : sku.hashCode) +
        (barcode == null ? 0 : barcode.hashCode) +
        unit.hashCode +
        (description == null ? 0 : description.hashCode) +
        minStock.hashCode +
        currentStock.hashCode +
        createdAt.hashCode +
        updatedAt.hashCode +
        (category == null ? 0 : category.hashCode);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

