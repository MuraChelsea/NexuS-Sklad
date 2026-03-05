// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthUserCWProxy {
  AuthUser id(String id);

  AuthUser companyId(String companyId);

  AuthUser name(String name);

  AuthUser email(String? email);

  AuthUser phone(String? phone);

  AuthUser role(UserRole role);

  AuthUser company(AuthCompany company);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUser(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUser call({
    String id,
    String companyId,
    String name,
    String? email,
    String? phone,
    UserRole role,
    AuthCompany company,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthUser.copyWith.fieldName(...)`
class _$AuthUserCWProxyImpl implements _$AuthUserCWProxy {
  const _$AuthUserCWProxyImpl(this._value);

  final AuthUser _value;

  @override
  AuthUser id(String id) => this(id: id);

  @override
  AuthUser companyId(String companyId) => this(companyId: companyId);

  @override
  AuthUser name(String name) => this(name: name);

  @override
  AuthUser email(String? email) => this(email: email);

  @override
  AuthUser phone(String? phone) => this(phone: phone);

  @override
  AuthUser role(UserRole role) => this(role: role);

  @override
  AuthUser company(AuthCompany company) => this(company: company);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthUser(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthUser call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? company = const $CopyWithPlaceholder(),
  }) {
    return AuthUser(
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
      company: company == const $CopyWithPlaceholder()
          ? _value.company
          // ignore: cast_nullable_to_non_nullable
          : company as AuthCompany,
    );
  }
}

extension $AuthUserCopyWith on AuthUser {
  /// Returns a callable class that can be used as follows: `instanceOfAuthUser.copyWith(...)` or like so:`instanceOfAuthUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthUserCWProxy get copyWith => _$AuthUserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthUser', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'companyId', 'name', 'role', 'company'],
      );
      final val = AuthUser(
        id: $checkedConvert('id', (v) => v as String),
        companyId: $checkedConvert('companyId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String?),
        role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
        company: $checkedConvert(
          'company',
          (v) => AuthCompany.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'companyId': instance.companyId,
  'name': instance.name,
  'email': ?instance.email,
  'phone': ?instance.phone,
  'role': _$UserRoleEnumMap[instance.role]!,
  'company': instance.company.toJson(),
};

const _$UserRoleEnumMap = {
  UserRole.OWNER: 'OWNER',
  UserRole.MANAGER: 'MANAGER',
  UserRole.STAFF: 'STAFF',
};
