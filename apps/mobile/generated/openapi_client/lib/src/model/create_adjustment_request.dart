//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_adjustment_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateAdjustmentRequest {
  /// Returns a new [CreateAdjustmentRequest] instance.
  CreateAdjustmentRequest({

    required  this.productId,

    required  this.targetQty,

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
    
    name: r'targetQty',
    required: true,
    includeIfNull: false,
  )


  final num targetQty;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateAdjustmentRequest &&
      other.productId == productId &&
      other.targetQty == targetQty &&
      other.comment == comment;

    @override
    int get hashCode =>
        productId.hashCode +
        targetQty.hashCode +
        (comment == null ? 0 : comment.hashCode);

  factory CreateAdjustmentRequest.fromJson(Map<String, dynamic> json) => _$CreateAdjustmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAdjustmentRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

