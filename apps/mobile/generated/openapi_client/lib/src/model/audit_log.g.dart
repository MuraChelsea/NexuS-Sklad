// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditLogCWProxy {
  AuditLog id(String id);

  AuditLog companyId(String companyId);

  AuditLog userId(String userId);

  AuditLog action(String action);

  AuditLog entityType(String entityType);

  AuditLog entityId(String? entityId);

  AuditLog payload(Map<String, Object>? payload);

  AuditLog createdAt(DateTime createdAt);

  AuditLog user(AuditActor user);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditLog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditLog(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditLog call({
    String id,
    String companyId,
    String userId,
    String action,
    String entityType,
    String? entityId,
    Map<String, Object>? payload,
    DateTime createdAt,
    AuditActor user,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditLog.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditLog.copyWith.fieldName(...)`
class _$AuditLogCWProxyImpl implements _$AuditLogCWProxy {
  const _$AuditLogCWProxyImpl(this._value);

  final AuditLog _value;

  @override
  AuditLog id(String id) => this(id: id);

  @override
  AuditLog companyId(String companyId) => this(companyId: companyId);

  @override
  AuditLog userId(String userId) => this(userId: userId);

  @override
  AuditLog action(String action) => this(action: action);

  @override
  AuditLog entityType(String entityType) => this(entityType: entityType);

  @override
  AuditLog entityId(String? entityId) => this(entityId: entityId);

  @override
  AuditLog payload(Map<String, Object>? payload) => this(payload: payload);

  @override
  AuditLog createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AuditLog user(AuditActor user) => this(user: user);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditLog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditLog(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditLog call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
    Object? entityType = const $CopyWithPlaceholder(),
    Object? entityId = const $CopyWithPlaceholder(),
    Object? payload = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
  }) {
    return AuditLog(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      companyId: companyId == const $CopyWithPlaceholder()
          ? _value.companyId
          // ignore: cast_nullable_to_non_nullable
          : companyId as String,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String,
      entityType: entityType == const $CopyWithPlaceholder()
          ? _value.entityType
          // ignore: cast_nullable_to_non_nullable
          : entityType as String,
      entityId: entityId == const $CopyWithPlaceholder()
          ? _value.entityId
          // ignore: cast_nullable_to_non_nullable
          : entityId as String?,
      payload: payload == const $CopyWithPlaceholder()
          ? _value.payload
          // ignore: cast_nullable_to_non_nullable
          : payload as Map<String, Object>?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as AuditActor,
    );
  }
}

extension $AuditLogCopyWith on AuditLog {
  /// Returns a callable class that can be used as follows: `instanceOfAuditLog.copyWith(...)` or like so:`instanceOfAuditLog.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditLogCWProxy get copyWith => _$AuditLogCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLog _$AuditLogFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuditLog', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'companyId',
      'userId',
      'action',
      'entityType',
      'createdAt',
      'user',
    ],
  );
  final val = AuditLog(
    id: $checkedConvert('id', (v) => v as String),
    companyId: $checkedConvert('companyId', (v) => v as String),
    userId: $checkedConvert('userId', (v) => v as String),
    action: $checkedConvert('action', (v) => v as String),
    entityType: $checkedConvert('entityType', (v) => v as String),
    entityId: $checkedConvert('entityId', (v) => v as String?),
    payload: $checkedConvert(
      'payload',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as Object)),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    user: $checkedConvert(
      'user',
      (v) => AuditActor.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'companyId': instance.companyId,
  'userId': instance.userId,
  'action': instance.action,
  'entityType': instance.entityType,
  'entityId': ?instance.entityId,
  'payload': ?instance.payload,
  'createdAt': instance.createdAt.toIso8601String(),
  'user': instance.user.toJson(),
};
