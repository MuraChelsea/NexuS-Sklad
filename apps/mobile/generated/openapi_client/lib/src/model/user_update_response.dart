//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/company_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_update_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserUpdateResponse {
  /// Returns a new [UserUpdateResponse] instance.
  UserUpdateResponse({

    required  this.item,

    required  this.module,

     this.action,
  });

  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final CompanyUser item;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;



  @JsonKey(
    
    name: r'action',
    required: false,
    includeIfNull: false,
  )


  final Object? action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserUpdateResponse &&
      other.item == item &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) => _$UserUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

