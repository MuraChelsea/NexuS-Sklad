//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/company.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CompanyResponse {
  /// Returns a new [CompanyResponse] instance.
  CompanyResponse({

    required  this.item,

    required  this.module,
  });

  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final Company item;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CompanyResponse &&
      other.item == item &&
      other.module == module;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode);

  factory CompanyResponse.fromJson(Map<String, dynamic> json) => _$CompanyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

