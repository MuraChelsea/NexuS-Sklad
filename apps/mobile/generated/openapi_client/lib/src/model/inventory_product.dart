//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_product.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InventoryProduct {
  /// Returns a new [InventoryProduct] instance.
  InventoryProduct({

    required  this.id,

    required  this.name,

     this.sku,

    required  this.unit,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is InventoryProduct &&
      other.id == id &&
      other.name == name &&
      other.sku == sku &&
      other.unit == unit;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        (sku == null ? 0 : sku.hashCode) +
        unit.hashCode;

  factory InventoryProduct.fromJson(Map<String, dynamic> json) => _$InventoryProductFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryProductToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

