//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/auth_company.dart';
import 'package:nexussklad_openapi_client/src/model/user_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthUser {
  /// Returns a new [AuthUser] instance.
  AuthUser({

    required  this.id,

    required  this.companyId,

    required  this.name,

     this.email,

     this.phone,

    required  this.role,

    required  this.company,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'companyId',
    required: true,
    includeIfNull: false,
  )


  final String companyId;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



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
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final UserRole role;



  @JsonKey(
    
    name: r'company',
    required: true,
    includeIfNull: false,
  )


  final AuthCompany company;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthUser &&
      other.id == id &&
      other.companyId == companyId &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.role == role &&
      other.company == company;

    @override
    int get hashCode =>
        id.hashCode +
        companyId.hashCode +
        name.hashCode +
        (email == null ? 0 : email.hashCode) +
        (phone == null ? 0 : phone.hashCode) +
        role.hashCode +
        company.hashCode;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

