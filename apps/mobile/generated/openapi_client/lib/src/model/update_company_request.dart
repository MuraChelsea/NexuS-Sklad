//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_company_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateCompanyRequest {
  /// Returns a new [UpdateCompanyRequest] instance.
  UpdateCompanyRequest({

     this.name,

     this.city,

     this.phone,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'city',
    required: false,
    includeIfNull: false,
  )


  final String? city;



  @JsonKey(
    
    name: r'phone',
    required: false,
    includeIfNull: false,
  )


  final String? phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateCompanyRequest &&
      other.name == name &&
      other.city == city &&
      other.phone == phone;

    @override
    int get hashCode =>
        name.hashCode +
        (city == null ? 0 : city.hashCode) +
        (phone == null ? 0 : phone.hashCode);

  factory UpdateCompanyRequest.fromJson(Map<String, dynamic> json) => _$UpdateCompanyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCompanyRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

