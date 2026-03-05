//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/inventory_item.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_started_by.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_session.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InventorySession {
  /// Returns a new [InventorySession] instance.
  InventorySession({

    required  this.id,

    required  this.companyId,

    required  this.startedById,

    required  this.startedBy,

    required  this.status,

     this.comment,

    required  this.startedAt,

     this.finishedAt,

    required  this.items,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'companyId',
    required: true,
    includeIfNull: false,
  )


  final String companyId;



  @JsonKey(
    
    name: r'startedById',
    required: true,
    includeIfNull: false,
  )


  final String startedById;



  @JsonKey(
    
    name: r'startedBy',
    required: true,
    includeIfNull: false,
  )


  final InventoryStartedBy startedBy;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final InventoryStatus status;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;



  @JsonKey(
    
    name: r'startedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime startedAt;



  @JsonKey(
    
    name: r'finishedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? finishedAt;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<InventoryItem> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InventorySession &&
      other.id == id &&
      other.companyId == companyId &&
      other.startedById == startedById &&
      other.startedBy == startedBy &&
      other.status == status &&
      other.comment == comment &&
      other.startedAt == startedAt &&
      other.finishedAt == finishedAt &&
      other.items == items;

    @override
    int get hashCode =>
        id.hashCode +
        companyId.hashCode +
        startedById.hashCode +
        startedBy.hashCode +
        status.hashCode +
        (comment == null ? 0 : comment.hashCode) +
        startedAt.hashCode +
        (finishedAt == null ? 0 : finishedAt.hashCode) +
        items.hashCode;

  factory InventorySession.fromJson(Map<String, dynamic> json) => _$InventorySessionFromJson(json);

  Map<String, dynamic> toJson() => _$InventorySessionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

