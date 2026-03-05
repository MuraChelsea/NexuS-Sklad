//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/inventory_product.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_item.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InventoryItem {
  /// Returns a new [InventoryItem] instance.
  InventoryItem({

    required  this.id,

    required  this.sessionId,

    required  this.productId,

    required  this.expectedQty,

    required  this.actualQty,

    required  this.difference,

     this.comment,

    required  this.product,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'sessionId',
    required: true,
    includeIfNull: false,
  )


  final String sessionId;



  @JsonKey(
    
    name: r'productId',
    required: true,
    includeIfNull: false,
  )


  final String productId;



  @JsonKey(
    
    name: r'expectedQty',
    required: true,
    includeIfNull: false,
  )


  final String expectedQty;



  @JsonKey(
    
    name: r'actualQty',
    required: true,
    includeIfNull: false,
  )


  final String actualQty;



  @JsonKey(
    
    name: r'difference',
    required: true,
    includeIfNull: false,
  )


  final String difference;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;



  @JsonKey(
    
    name: r'product',
    required: true,
    includeIfNull: false,
  )


  final InventoryProduct product;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InventoryItem &&
      other.id == id &&
      other.sessionId == sessionId &&
      other.productId == productId &&
      other.expectedQty == expectedQty &&
      other.actualQty == actualQty &&
      other.difference == difference &&
      other.comment == comment &&
      other.product == product;

    @override
    int get hashCode =>
        id.hashCode +
        sessionId.hashCode +
        productId.hashCode +
        expectedQty.hashCode +
        actualQty.hashCode +
        difference.hashCode +
        (comment == null ? 0 : comment.hashCode) +
        product.hashCode;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

