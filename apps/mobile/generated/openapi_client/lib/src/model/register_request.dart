//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RegisterRequest {
  /// Returns a new [RegisterRequest] instance.
  RegisterRequest({

    required  this.companyName,

     this.companyCity,

     this.companyPhone,

    required  this.ownerName,

    required  this.email,

     this.phone,

    required  this.password,
  });

  @JsonKey(
    
    name: r'companyName',
    required: true,
    includeIfNull: false,
  )


  final String companyName;



  @JsonKey(
    
    name: r'companyCity',
    required: false,
    includeIfNull: false,
  )


  final String? companyCity;



  @JsonKey(
    
    name: r'companyPhone',
    required: false,
    includeIfNull: false,
  )


  final String? companyPhone;



  @JsonKey(
    
    name: r'ownerName',
    required: true,
    includeIfNull: false,
  )


  final String ownerName;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is RegisterRequest &&
      other.companyName == companyName &&
      other.companyCity == companyCity &&
      other.companyPhone == companyPhone &&
      other.ownerName == ownerName &&
      other.email == email &&
      other.phone == phone &&
      other.password == password;

    @override
    int get hashCode =>
        companyName.hashCode +
        (companyCity == null ? 0 : companyCity.hashCode) +
        (companyPhone == null ? 0 : companyPhone.hashCode) +
        ownerName.hashCode +
        email.hashCode +
        (phone == null ? 0 : phone.hashCode) +
        password.hashCode;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

