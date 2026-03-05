//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite_user_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InviteUserRequest {
  /// Returns a new [InviteUserRequest] instance.
  InviteUserRequest({

    required  this.email,

    required  this.role,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final InviteUserRequestRoleEnum role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InviteUserRequest &&
      other.email == email &&
      other.role == role;

    @override
    int get hashCode =>
        email.hashCode +
        role.hashCode;

  factory InviteUserRequest.fromJson(Map<String, dynamic> json) => _$InviteUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InviteUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum InviteUserRequestRoleEnum {
@JsonValue(r'MANAGER')
MANAGER(r'MANAGER'),
@JsonValue(r'STAFF')
STAFF(r'STAFF');

const InviteUserRequestRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


