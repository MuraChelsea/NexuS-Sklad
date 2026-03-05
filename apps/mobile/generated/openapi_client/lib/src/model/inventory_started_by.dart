//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/user_role.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_started_by.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InventoryStartedBy {
  /// Returns a new [InventoryStartedBy] instance.
  InventoryStartedBy({

    required  this.id,

    required  this.name,

    required  this.role,
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



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final UserRole role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InventoryStartedBy &&
      other.id == id &&
      other.name == name &&
      other.role == role;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        role.hashCode;

  factory InventoryStartedBy.fromJson(Map<String, dynamic> json) => _$InventoryStartedByFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryStartedByToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

