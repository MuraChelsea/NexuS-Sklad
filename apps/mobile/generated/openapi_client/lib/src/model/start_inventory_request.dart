//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_inventory_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StartInventoryRequest {
  /// Returns a new [StartInventoryRequest] instance.
  StartInventoryRequest({

     this.categoryId,

     this.productIds,

     this.comment,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final String? categoryId;



  @JsonKey(
    
    name: r'productIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? productIds;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StartInventoryRequest &&
      other.categoryId == categoryId &&
      other.productIds == productIds &&
      other.comment == comment;

    @override
    int get hashCode =>
        categoryId.hashCode +
        productIds.hashCode +
        (comment == null ? 0 : comment.hashCode);

  factory StartInventoryRequest.fromJson(Map<String, dynamic> json) => _$StartInventoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StartInventoryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

