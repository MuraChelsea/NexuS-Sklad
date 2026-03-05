// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_actor.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditActorCWProxy {
  AuditActor id(String id);

  AuditActor name(String name);

  AuditActor role(UserRole role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditActor(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditActor(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditActor call({String id, String name, UserRole role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditActor.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditActor.copyWith.fieldName(...)`
class _$AuditActorCWProxyImpl implements _$AuditActorCWProxy {
  const _$AuditActorCWProxyImpl(this._value);

  final AuditActor _value;

  @override
  AuditActor id(String id) => this(id: id);

  @override
  AuditActor name(String name) => this(name: name);

  @override
  AuditActor role(UserRole role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditActor(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditActor(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditActor call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return AuditActor(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UserRole,
    );
  }
}

extension $AuditActorCopyWith on AuditActor {
  /// Returns a callable class that can be used as follows: `instanceOfAuditActor.copyWith(...)` or like so:`instanceOfAuditActor.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditActorCWProxy get copyWith => _$AuditActorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditActor _$AuditActorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditActor', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'role']);
      final val = AuditActor(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
      );
      return val;
    });

Map<String, dynamic> _$AuditActorToJson(AuditActor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.OWNER: 'OWNER',
  UserRole.MANAGER: 'MANAGER',
  UserRole.STAFF: 'STAFF',
};
