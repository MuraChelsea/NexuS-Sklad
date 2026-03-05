//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/auth_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_me_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthMeResponse {
  /// Returns a new [AuthMeResponse] instance.
  AuthMeResponse({

    required  this.user,

    required  this.module,

    required  this.action,
  });

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
    bool operator ==(Object other) => identical(this, other) || other is AuthMeResponse &&
      other.user == user &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        user.hashCode +
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) => _$AuthMeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

