// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_actor.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MovementActorCWProxy {
  MovementActor id(String id);

  MovementActor name(String name);

  MovementActor role(UserRole role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementActor(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementActor(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementActor call({String id, String name, UserRole role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMovementActor.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMovementActor.copyWith.fieldName(...)`
class _$MovementActorCWProxyImpl implements _$MovementActorCWProxy {
  const _$MovementActorCWProxyImpl(this._value);

  final MovementActor _value;

  @override
  MovementActor id(String id) => this(id: id);

  @override
  MovementActor name(String name) => this(name: name);

  @override
  MovementActor role(UserRole role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MovementActor(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MovementActor(...).copyWith(id: 12, name: "My name")
  /// ````
  MovementActor call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return MovementActor(
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

extension $MovementActorCopyWith on MovementActor {
  /// Returns a callable class that can be used as follows: `instanceOfMovementActor.copyWith(...)` or like so:`instanceOfMovementActor.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MovementActorCWProxy get copyWith => _$MovementActorCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementActor _$MovementActorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MovementActor', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'role']);
      final val = MovementActor(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
      );
      return val;
    });

Map<String, dynamic> _$MovementActorToJson(MovementActor instance) =>
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
