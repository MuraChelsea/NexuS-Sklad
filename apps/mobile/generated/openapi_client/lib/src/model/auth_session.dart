//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/auth_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_session.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthSession {
  /// Returns a new [AuthSession] instance.
  AuthSession({

    required  this.accessToken,

    required  this.refreshToken,

    required  this.user,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthSession &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.user == user;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        user.hashCode;

  factory AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

