//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/company_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_list_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserListResponse {
  /// Returns a new [UserListResponse] instance.
  UserListResponse({

    required  this.items,

    required  this.module,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<CompanyUser> items;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserListResponse &&
      other.items == items &&
      other.module == module;

    @override
    int get hashCode =>
        items.hashCode +
        (module == null ? 0 : module.hashCode);

  factory UserListResponse.fromJson(Map<String, dynamic> json) => _$UserListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserListResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

