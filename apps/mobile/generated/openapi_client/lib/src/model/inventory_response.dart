//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/inventory_session.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InventoryResponse {
  /// Returns a new [InventoryResponse] instance.
  InventoryResponse({

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


  final String? action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InventoryResponse &&
      other.item == item &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode) +
        action.hashCode;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) => _$InventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

