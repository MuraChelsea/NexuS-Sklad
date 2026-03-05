//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/auth_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_session_accept_invite_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthSessionAcceptInviteResponse {
  /// Returns a new [AuthSessionAcceptInviteResponse] instance.
  AuthSessionAcceptInviteResponse({

    required  this.accessToken,

    required  this.refreshToken,

    required  this.user,

    required  this.module,

    required  this.action,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'refreshToken',
    required: true,
    includeIfNull: false,
  )


  final String refreshToken;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final AuthUser user;



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
    bool operator ==(Object other) => identical(this, other) || other is AuthSessionAcceptInviteResponse &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.user == user &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        user.hashCode +
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory AuthSessionAcceptInviteResponse.fromJson(Map<String, dynamic> json) => _$AuthSessionAcceptInviteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionAcceptInviteResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

