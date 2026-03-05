//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/user_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company_user.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CompanyUser {
  /// Returns a new [CompanyUser] instance.
  CompanyUser({

    required  this.id,

    required  this.companyId,

    required  this.name,

     this.email,

     this.phone,

    required  this.role,

    required  this.isActive,

    required  this.createdAt,

     this.inviteExpiresAt,
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
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'inviteExpiresAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? inviteExpiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CompanyUser &&
      other.id == id &&
      other.companyId == companyId &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.role == role &&
      other.isActive == isActive &&
      other.createdAt == createdAt &&
      other.inviteExpiresAt == inviteExpiresAt;

    @override
    int get hashCode =>
        id.hashCode +
        companyId.hashCode +
        name.hashCode +
        (email == null ? 0 : email.hashCode) +
        (phone == null ? 0 : phone.hashCode) +
        role.hashCode +
        isActive.hashCode +
        createdAt.hashCode +
        (inviteExpiresAt == null ? 0 : inviteExpiresAt.hashCode);

  factory CompanyUser.fromJson(Map<String, dynamic> json) => _$CompanyUserFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

