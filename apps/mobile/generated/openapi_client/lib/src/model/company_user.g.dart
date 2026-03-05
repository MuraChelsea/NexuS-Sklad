// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompanyUserCWProxy {
  CompanyUser id(String id);

  CompanyUser companyId(String companyId);

  CompanyUser name(String name);

  CompanyUser email(String? email);

  CompanyUser phone(String? phone);

  CompanyUser role(UserRole role);

  CompanyUser isActive(bool isActive);

  CompanyUser createdAt(DateTime createdAt);

  CompanyUser inviteExpiresAt(DateTime? inviteExpiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyUser(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyUser call({
    String id,
    String companyId,
    String name,
    String? email,
    String? phone,
    UserRole role,
    bool isActive,
    DateTime createdAt,
    DateTime? inviteExpiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompanyUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompanyUser.copyWith.fieldName(...)`
class _$CompanyUserCWProxyImpl implements _$CompanyUserCWProxy {
  const _$CompanyUserCWProxyImpl(this._value);

  final CompanyUser _value;

  @override
  CompanyUser id(String id) => this(id: id);

  @override
  CompanyUser companyId(String companyId) => this(companyId: companyId);

  @override
  CompanyUser name(String name) => this(name: name);

  @override
  CompanyUser email(String? email) => this(email: email);

  @override
  CompanyUser phone(String? phone) => this(phone: phone);

  @override
  CompanyUser role(UserRole role) => this(role: role);

  @override
  CompanyUser isActive(bool isActive) => this(isActive: isActive);

  @override
  CompanyUser createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  CompanyUser inviteExpiresAt(DateTime? inviteExpiresAt) =>
      this(inviteExpiresAt: inviteExpiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyUser(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyUser call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? inviteExpiresAt = const $CopyWithPlaceholder(),
  }) {
    return CompanyUser(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      companyId: companyId == const $CopyWithPlaceholder()
          ? _value.companyId
          // ignore: cast_nullable_to_non_nullable
          : companyId as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UserRole,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      inviteExpiresAt: inviteExpiresAt == const $CopyWithPlaceholder()
          ? _value.inviteExpiresAt
          // ignore: cast_nullable_to_non_nullable
          : inviteExpiresAt as DateTime?,
    );
  }
}

extension $CompanyUserCopyWith on CompanyUser {
  /// Returns a callable class that can be used as follows: `instanceOfCompanyUser.copyWith(...)` or like so:`instanceOfCompanyUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompanyUserCWProxy get copyWith => _$CompanyUserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyUser _$CompanyUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CompanyUser', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'companyId',
          'name',
          'role',
          'isActive',
          'createdAt',
        ],
      );
      final val = CompanyUser(
        id: $checkedConvert('id', (v) => v as String),
        companyId: $checkedConvert('companyId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String?),
        role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
        isActive: $checkedConvert('isActive', (v) => v as bool),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        inviteExpiresAt: $checkedConvert(
          'inviteExpiresAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CompanyUserToJson(CompanyUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'name': instance.name,
      'email': ?instance.email,
      'phone': ?instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'inviteExpiresAt': ?instance.inviteExpiresAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.OWNER: 'OWNER',
  UserRole.MANAGER: 'MANAGER',
  UserRole.STAFF: 'STAFF',
};
