//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_category_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateCategoryRequest {
  /// Returns a new [UpdateCategoryRequest] instance.
  UpdateCategoryRequest({

     this.name,

     this.parentId,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'parentId',
    required: false,
    includeIfNull: false,
  )


  final String? parentId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateCategoryRequest &&
      other.name == name &&
      other.parentId == parentId;

    @override
    int get hashCode =>
        name.hashCode +
        (parentId == null ? 0 : parentId.hashCode);

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) => _$UpdateCategoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCategoryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

