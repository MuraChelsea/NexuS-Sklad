// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_invite_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AcceptInviteRequestCWProxy {
  AcceptInviteRequest inviteToken(String inviteToken);

  AcceptInviteRequest name(String name);

  AcceptInviteRequest phone(String? phone);

  AcceptInviteRequest password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AcceptInviteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AcceptInviteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AcceptInviteRequest call({
    String inviteToken,
    String name,
    String? phone,
    String password,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAcceptInviteRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAcceptInviteRequest.copyWith.fieldName(...)`
class _$AcceptInviteRequestCWProxyImpl implements _$AcceptInviteRequestCWProxy {
  const _$AcceptInviteRequestCWProxyImpl(this._value);

  final AcceptInviteRequest _value;

  @override
  AcceptInviteRequest inviteToken(String inviteToken) =>
      this(inviteToken: inviteToken);

  @override
  AcceptInviteRequest name(String name) => this(name: name);

  @override
  AcceptInviteRequest phone(String? phone) => this(phone: phone);

  @override
  AcceptInviteRequest password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AcceptInviteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AcceptInviteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AcceptInviteRequest call({
    Object? inviteToken = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return AcceptInviteRequest(
      inviteToken: inviteToken == const $CopyWithPlaceholder()
          ? _value.inviteToken
          // ignore: cast_nullable_to_non_nullable
          : inviteToken as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $AcceptInviteRequestCopyWith on AcceptInviteRequest {
  /// Returns a callable class that can be used as follows: `instanceOfAcceptInviteRequest.copyWith(...)` or like so:`instanceOfAcceptInviteRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AcceptInviteRequestCWProxy get copyWith =>
      _$AcceptInviteRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptInviteRequest _$AcceptInviteRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AcceptInviteRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['inviteToken', 'name', 'password']);
      final val = AcceptInviteRequest(
        inviteToken: $checkedConvert('inviteToken', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String?),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AcceptInviteRequestToJson(
  AcceptInviteRequest instance,
) => <String, dynamic>{
  'inviteToken': instance.inviteToken,
  'name': instance.name,
  'phone': ?instance.phone,
  'password': instance.password,
};
