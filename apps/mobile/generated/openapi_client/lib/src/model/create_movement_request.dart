//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_movement_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateMovementRequest {
  /// Returns a new [CreateMovementRequest] instance.
  CreateMovementRequest({

    required  this.productId,

    required  this.quantity,

     this.comment,
  });

  @JsonKey(
    
    name: r'productId',
    required: true,
    includeIfNull: false,
  )


  final String productId;



          // minimum: 0
  @JsonKey(
    
    name: r'quantity',
    required: true,
    includeIfNull: false,
  )


  final num quantity;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateMovementRequest &&
      other.productId == productId &&
      other.quantity == quantity &&
      other.comment == comment;

    @override
    int get hashCode =>
        productId.hashCode +
        quantity.hashCode +
        (comment == null ? 0 : comment.hashCode);

  factory CreateMovementRequest.fromJson(Map<String, dynamic> json) => _$CreateMovementRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMovementRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

