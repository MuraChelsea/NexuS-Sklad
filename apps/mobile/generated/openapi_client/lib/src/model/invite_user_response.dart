//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/company_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite_user_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InviteUserResponse {
  /// Returns a new [InviteUserResponse] instance.
  InviteUserResponse({

    required  this.user,

    required  this.inviteToken,

    required  this.module,

    required  this.action,
  });

  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final CompanyUser user;



  @JsonKey(
    
    name: r'inviteToken',
    required: true,
    includeIfNull: false,
  )


  final String inviteToken;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: true,
  )


  final Object? action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InviteUserResponse &&
      other.user == user &&
      other.inviteToken == inviteToken &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        user.hashCode +
        inviteToken.hashCode +
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory InviteUserResponse.fromJson(Map<String, dynamic> json) => _$InviteUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InviteUserResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

