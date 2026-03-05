// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateUserRequestCWProxy {
  CreateUserRequest name(String name);

  CreateUserRequest email(String email);

  CreateUserRequest phone(String? phone);

  CreateUserRequest password(String password);

  CreateUserRequest role(CreateUserRequestRoleEnum role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateUserRequest call({
    String name,
    String email,
    String? phone,
    String password,
    CreateUserRequestRoleEnum role,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateUserRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateUserRequest.copyWith.fieldName(...)`
class _$CreateUserRequestCWProxyImpl implements _$CreateUserRequestCWProxy {
  const _$CreateUserRequestCWProxyImpl(this._value);

  final CreateUserRequest _value;

  @override
  CreateUserRequest name(String name) => this(name: name);

  @override
  CreateUserRequest email(String email) => this(email: email);

  @override
  CreateUserRequest phone(String? phone) => this(phone: phone);

  @override
  CreateUserRequest password(String password) => this(password: password);

  @override
  CreateUserRequest role(CreateUserRequestRoleEnum role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateUserRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return CreateUserRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as CreateUserRequestRoleEnum,
    );
  }
}

extension $CreateUserRequestCopyWith on CreateUserRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateUserRequest.copyWith(...)` or like so:`instanceOfCreateUserRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateUserRequestCWProxy get copyWith =>
      _$CreateUserRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateUserRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['name', 'email', 'password', 'role'],
      );
      final val = CreateUserRequest(
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String?),
        password: $checkedConvert('password', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$CreateUserRequestRoleEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': ?instance.phone,
      'password': instance.password,
      'role': _$CreateUserRequestRoleEnumEnumMap[instance.role]!,
    };

const _$CreateUserRequestRoleEnumEnumMap = {
  CreateUserRequestRoleEnum.MANAGER: 'MANAGER',
  CreateUserRequestRoleEnum.STAFF: 'STAFF',
};
