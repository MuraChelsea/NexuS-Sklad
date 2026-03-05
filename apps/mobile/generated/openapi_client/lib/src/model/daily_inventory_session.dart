//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/daily_inventory_session_count.dart';
import 'package:nexussklad_openapi_client/src/model/daily_inventory_session_started_by.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_inventory_session.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyInventorySession {
  /// Returns a new [DailyInventorySession] instance.
  DailyInventorySession({

    required  this.id,

    required  this.status,

    required  this.startedAt,

     this.finishedAt,

     this.comment,

    required  this.startedBy,

    required  this.count,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



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
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;



  @JsonKey(
    
    name: r'startedBy',
    required: true,
    includeIfNull: false,
  )


  final DailyInventorySessionStartedBy startedBy;



  @JsonKey(
    
    name: r'_count',
    required: true,
    includeIfNull: false,
  )


  final DailyInventorySessionCount count;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyInventorySession &&
      other.id == id &&
      other.status == status &&
      other.startedAt == startedAt &&
      other.finishedAt == finishedAt &&
      other.comment == comment &&
      other.startedBy == startedBy &&
      other.count == count;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        startedAt.hashCode +
        (finishedAt == null ? 0 : finishedAt.hashCode) +
        (comment == null ? 0 : comment.hashCode) +
        startedBy.hashCode +
        count.hashCode;

  factory DailyInventorySession.fromJson(Map<String, dynamic> json) => _$DailyInventorySessionFromJson(json);

  Map<String, dynamic> toJson() => _$DailyInventorySessionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

