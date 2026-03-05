//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/inventory_session.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_start_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InventoryStartResponse {
  /// Returns a new [InventoryStartResponse] instance.
  InventoryStartResponse({

    required  this.item,

    required  this.module,

     this.action,
  });

  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final InventorySession item;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;



  @JsonKey(
    
    name: r'action',
    required: false,
    includeIfNull: false,
  )


  final Object? action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InventoryStartResponse &&
      other.item == item &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory InventoryStartResponse.fromJson(Map<String, dynamic> json) => _$InventoryStartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryStartResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

