//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'accept_invite_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AcceptInviteRequest {
  /// Returns a new [AcceptInviteRequest] instance.
  AcceptInviteRequest({

    required  this.inviteToken,

    required  this.name,

     this.phone,

    required  this.password,
  });

  @JsonKey(
    
    name: r'inviteToken',
    required: true,
    includeIfNull: false,
  )


  final String inviteToken;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



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
    bool operator ==(Object other) => identical(this, other) || other is AcceptInviteRequest &&
      other.inviteToken == inviteToken &&
      other.name == name &&
      other.phone == phone &&
      other.password == password;

    @override
    int get hashCode =>
        inviteToken.hashCode +
        name.hashCode +
        (phone == null ? 0 : phone.hashCode) +
        password.hashCode;

  factory AcceptInviteRequest.fromJson(Map<String, dynamic> json) => _$AcceptInviteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptInviteRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

