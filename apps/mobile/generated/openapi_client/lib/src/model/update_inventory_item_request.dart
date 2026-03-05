//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_inventory_item_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateInventoryItemRequest {
  /// Returns a new [UpdateInventoryItemRequest] instance.
  UpdateInventoryItemRequest({

    required  this.actualQty,

     this.comment,
  });

          // minimum: 0
  @JsonKey(
    
    name: r'actualQty',
    required: true,
    includeIfNull: false,
  )


  final num actualQty;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateInventoryItemRequest &&
      other.actualQty == actualQty &&
      other.comment == comment;

    @override
    int get hashCode =>
        actualQty.hashCode +
        (comment == null ? 0 : comment.hashCode);

  factory UpdateInventoryItemRequest.fromJson(Map<String, dynamic> json) => _$UpdateInventoryItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateInventoryItemRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

