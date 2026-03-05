//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/stock_movement.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movement_adjustment_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MovementAdjustmentResponse {
  /// Returns a new [MovementAdjustmentResponse] instance.
  MovementAdjustmentResponse({

    required  this.item,

    required  this.module,

    required  this.action,
  });

  @JsonKey(
    
    name: r'item',
    required: true,
    includeIfNull: false,
  )


  final StockMovement item;



  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: true,
  )


  final Object? action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MovementAdjustmentResponse &&
      other.item == item &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        item.hashCode +
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory MovementAdjustmentResponse.fromJson(Map<String, dynamic> json) => _$MovementAdjustmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovementAdjustmentResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

