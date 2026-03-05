//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:nexussklad_openapi_client/src/model/audit_actor.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_log.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditLog {
  /// Returns a new [AuditLog] instance.
  AuditLog({

    required  this.id,

    required  this.companyId,

    required  this.userId,

    required  this.action,

    required  this.entityType,

     this.entityId,

     this.payload,

    required  this.createdAt,

    required  this.user,
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
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



  @JsonKey(
    
    name: r'entityType',
    required: true,
    includeIfNull: false,
  )


  final String entityType;



  @JsonKey(
    
    name: r'entityId',
    required: false,
    includeIfNull: false,
  )


  final String? entityId;



  @JsonKey(
    
    name: r'payload',
    required: false,
    includeIfNull: false,
  )


  final Map<String, Object>? payload;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final AuditActor user;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditLog &&
      other.id == id &&
      other.companyId == companyId &&
      other.userId == userId &&
      other.action == action &&
      other.entityType == entityType &&
      other.entityId == entityId &&
      other.payload == payload &&
      other.createdAt == createdAt &&
      other.user == user;

    @override
    int get hashCode =>
        id.hashCode +
        companyId.hashCode +
        userId.hashCode +
        action.hashCode +
        entityType.hashCode +
        (entityId == null ? 0 : entityId.hashCode) +
        (payload == null ? 0 : payload.hashCode) +
        createdAt.hashCode +
        user.hashCode;

  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

  Map<String, dynamic> toJson() => _$AuditLogToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

