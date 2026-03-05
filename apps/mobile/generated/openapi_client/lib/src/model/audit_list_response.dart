//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/audit_log.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_list_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditListResponse {
  /// Returns a new [AuditListResponse] instance.
  AuditListResponse({

    required  this.items,

    required  this.module,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<AuditLog> items;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditListResponse &&
      other.items == items &&
      other.module == module;

    @override
    int get hashCode =>
        items.hashCode +
        (module == null ? 0 : module.hashCode);

  factory AuditListResponse.fromJson(Map<String, dynamic> json) => _$AuditListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuditListResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

