//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_user_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateUserRequest {
  /// Returns a new [CreateUserRequest] instance.
  CreateUserRequest({

    required  this.name,

    required  this.email,

     this.phone,

    required  this.password,

    required  this.role,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'phone',
    required: false,
    includeIfNull: false,
  )


  final String? phone;



  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final CreateUserRequestRoleEnum role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateUserRequest &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.password == password &&
      other.role == role;

    @override
    int get hashCode =>
        name.hashCode +
        email.hashCode +
        (phone == null ? 0 : phone.hashCode) +
        password.hashCode +
        role.hashCode;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum CreateUserRequestRoleEnum {
@JsonValue(r'MANAGER')
MANAGER(r'MANAGER'),
@JsonValue(r'STAFF')
STAFF(r'STAFF');

const CreateUserRequestRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


