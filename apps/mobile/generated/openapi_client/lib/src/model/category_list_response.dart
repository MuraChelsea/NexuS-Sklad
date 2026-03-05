//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/category.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_list_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CategoryListResponse {
  /// Returns a new [CategoryListResponse] instance.
  CategoryListResponse({

    required  this.items,

    required  this.module,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<Category> items;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CategoryListResponse &&
      other.items == items &&
      other.module == module;

    @override
    int get hashCode =>
        items.hashCode +
        (module == null ? 0 : module.hashCode);

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) => _$CategoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

