// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_user_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InviteUserRequestCWProxy {
  InviteUserRequest email(String email);

  InviteUserRequest role(InviteUserRequestRoleEnum role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InviteUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InviteUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  InviteUserRequest call({String email, InviteUserRequestRoleEnum role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInviteUserRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInviteUserRequest.copyWith.fieldName(...)`
class _$InviteUserRequestCWProxyImpl implements _$InviteUserRequestCWProxy {
  const _$InviteUserRequestCWProxyImpl(this._value);

  final InviteUserRequest _value;

  @override
  InviteUserRequest email(String email) => this(email: email);

  @override
  InviteUserRequest role(InviteUserRequestRoleEnum role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InviteUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InviteUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  InviteUserRequest call({
    Object? email = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return InviteUserRequest(
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as InviteUserRequestRoleEnum,
    );
  }
}

extension $InviteUserRequestCopyWith on InviteUserRequest {
  /// Returns a callable class that can be used as follows: `instanceOfInviteUserRequest.copyWith(...)` or like so:`instanceOfInviteUserRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InviteUserRequestCWProxy get copyWith =>
      _$InviteUserRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteUserRequest _$InviteUserRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InviteUserRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email', 'role']);
      final val = InviteUserRequest(
        email: $checkedConvert('email', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$InviteUserRequestRoleEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$InviteUserRequestToJson(InviteUserRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'role': _$InviteUserRequestRoleEnumEnumMap[instance.role]!,
    };

const _$InviteUserRequestRoleEnumEnumMap = {
  InviteUserRequestRoleEnum.MANAGER: 'MANAGER',
  InviteUserRequestRoleEnum.STAFF: 'STAFF',
};
