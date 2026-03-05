//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/movement_product.dart';
import 'package:nexussklad_openapi_client/src/model/movement_actor.dart';
import 'package:nexussklad_openapi_client/src/model/movement_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_movement.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StockMovement {
  /// Returns a new [StockMovement] instance.
  StockMovement({

    required  this.id,

    required  this.companyId,

    required  this.productId,

    required  this.createdById,

    required  this.movementType,

    required  this.quantity,

    required  this.beforeQty,

    required  this.afterQty,

     this.comment,

    required  this.createdAt,

    required  this.product,

    required  this.createdBy,
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
    
    name: r'productId',
    required: true,
    includeIfNull: false,
  )


  final String productId;



  @JsonKey(
    
    name: r'createdById',
    required: true,
    includeIfNull: false,
  )


  final String createdById;



  @JsonKey(
    
    name: r'movementType',
    required: true,
    includeIfNull: false,
  )


  final MovementType movementType;



  @JsonKey(
    
    name: r'quantity',
    required: true,
    includeIfNull: false,
  )


  final String quantity;



  @JsonKey(
    
    name: r'beforeQty',
    required: true,
    includeIfNull: false,
  )


  final String beforeQty;



  @JsonKey(
    
    name: r'afterQty',
    required: true,
    includeIfNull: false,
  )


  final String afterQty;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'product',
    required: true,
    includeIfNull: false,
  )


  final MovementProduct product;



  @JsonKey(
    
    name: r'createdBy',
    required: true,
    includeIfNull: false,
  )


  final MovementActor createdBy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StockMovement &&
      other.id == id &&
      other.companyId == companyId &&
      other.productId == productId &&
      other.createdById == createdById &&
      other.movementType == movementType &&
      other.quantity == quantity &&
      other.beforeQty == beforeQty &&
      other.afterQty == afterQty &&
      other.comment == comment &&
      other.createdAt == createdAt &&
      other.product == product &&
      other.createdBy == createdBy;

    @override
    int get hashCode =>
        id.hashCode +
        companyId.hashCode +
        productId.hashCode +
        createdById.hashCode +
        movementType.hashCode +
        quantity.hashCode +
        beforeQty.hashCode +
        afterQty.hashCode +
        (comment == null ? 0 : comment.hashCode) +
        createdAt.hashCode +
        product.hashCode +
        createdBy.hashCode;

  factory StockMovement.fromJson(Map<String, dynamic> json) => _$StockMovementFromJson(json);

  Map<String, dynamic> toJson() => _$StockMovementToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

