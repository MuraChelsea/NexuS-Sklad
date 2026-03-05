// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_started_by.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryStartedByCWProxy {
  InventoryStartedBy id(String id);

  InventoryStartedBy name(String name);

  InventoryStartedBy role(UserRole role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryStartedBy(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryStartedBy(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryStartedBy call({String id, String name, UserRole role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryStartedBy.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryStartedBy.copyWith.fieldName(...)`
class _$InventoryStartedByCWProxyImpl implements _$InventoryStartedByCWProxy {
  const _$InventoryStartedByCWProxyImpl(this._value);

  final InventoryStartedBy _value;

  @override
  InventoryStartedBy id(String id) => this(id: id);

  @override
  InventoryStartedBy name(String name) => this(name: name);

  @override
  InventoryStartedBy role(UserRole role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryStartedBy(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryStartedBy(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryStartedBy call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return InventoryStartedBy(
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

extension $InventoryStartedByCopyWith on InventoryStartedBy {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryStartedBy.copyWith(...)` or like so:`instanceOfInventoryStartedBy.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryStartedByCWProxy get copyWith =>
      _$InventoryStartedByCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryStartedBy _$InventoryStartedByFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InventoryStartedBy', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'role']);
      final val = InventoryStartedBy(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
      );
      return val;
    });

Map<String, dynamic> _$InventoryStartedByToJson(InventoryStartedBy instance) =>
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
