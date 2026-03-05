// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateUserRequestCWProxy {
  UpdateUserRequest name(String? name);

  UpdateUserRequest email(String? email);

  UpdateUserRequest phone(String? phone);

  UpdateUserRequest password(String? password);

  UpdateUserRequest role(UpdateUserRequestRoleEnum? role);

  UpdateUserRequest isActive(bool? isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateUserRequest call({
    String? name,
    String? email,
    String? phone,
    String? password,
    UpdateUserRequestRoleEnum? role,
    bool? isActive,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateUserRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateUserRequest.copyWith.fieldName(...)`
class _$UpdateUserRequestCWProxyImpl implements _$UpdateUserRequestCWProxy {
  const _$UpdateUserRequestCWProxyImpl(this._value);

  final UpdateUserRequest _value;

  @override
  UpdateUserRequest name(String? name) => this(name: name);

  @override
  UpdateUserRequest email(String? email) => this(email: email);

  @override
  UpdateUserRequest phone(String? phone) => this(phone: phone);

  @override
  UpdateUserRequest password(String? password) => this(password: password);

  @override
  UpdateUserRequest role(UpdateUserRequestRoleEnum? role) => this(role: role);

  @override
  UpdateUserRequest isActive(bool? isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateUserRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return UpdateUserRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UpdateUserRequestRoleEnum?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $UpdateUserRequestCopyWith on UpdateUserRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateUserRequest.copyWith(...)` or like so:`instanceOfUpdateUserRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateUserRequestCWProxy get copyWith =>
      _$UpdateUserRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UpdateUserRequest', json, ($checkedConvert) {
      final val = UpdateUserRequest(
        name: $checkedConvert('name', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String?),
        password: $checkedConvert('password', (v) => v as String?),
        role: $checkedConvert(
          'role',
          (v) => $enumDecodeNullable(_$UpdateUserRequestRoleEnumEnumMap, v),
        ),
        isActive: $checkedConvert('isActive', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'email': ?instance.email,
      'phone': ?instance.phone,
      'password': ?instance.password,
      'role': ?_$UpdateUserRequestRoleEnumEnumMap[instance.role],
      'isActive': ?instance.isActive,
    };

const _$UpdateUserRequestRoleEnumEnumMap = {
  UpdateUserRequestRoleEnum.MANAGER: 'MANAGER',
  UpdateUserRequestRoleEnum.STAFF: 'STAFF',
};
