//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateUserRequest {
  /// Returns a new [UpdateUserRequest] instance.
  UpdateUserRequest({

     this.name,

     this.email,

     this.phone,

     this.password,

     this.role,

     this.isActive,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    
    name: r'phone',
    required: false,
    includeIfNull: false,
  )


  final String? phone;



  @JsonKey(
    
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final String? password;



  @JsonKey(
    
    name: r'role',
    required: false,
    includeIfNull: false,
  )


  final UpdateUserRequestRoleEnum? role;



  @JsonKey(
    
    name: r'isActive',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateUserRequest &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.password == password &&
      other.role == role &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        name.hashCode +
        email.hashCode +
        (phone == null ? 0 : phone.hashCode) +
        password.hashCode +
        role.hashCode +
        isActive.hashCode;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum UpdateUserRequestRoleEnum {
@JsonValue(r'MANAGER')
MANAGER(r'MANAGER'),
@JsonValue(r'STAFF')
STAFF(r'STAFF');

const UpdateUserRequestRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


