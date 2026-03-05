//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_company.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthCompany {
  /// Returns a new [AuthCompany] instance.
  AuthCompany({

    required  this.id,

    required  this.name,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthCompany &&
      other.id == id &&
      other.name == name;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode;

  factory AuthCompany.fromJson(Map<String, dynamic> json) => _$AuthCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCompanyToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

