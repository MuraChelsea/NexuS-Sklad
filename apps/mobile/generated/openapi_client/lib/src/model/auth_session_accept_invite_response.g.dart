// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_accept_invite_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthSessionAcceptInviteResponseCWProxy {
  AuthSessionAcceptInviteResponse accessToken(String accessToken);

  AuthSessionAcceptInviteResponse refreshToken(String refreshToken);

  AuthSessionAcceptInviteResponse user(AuthUser user);

  AuthSessionAcceptInviteResponse module(Object? module);

  AuthSessionAcceptInviteResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionAcceptInviteResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionAcceptInviteResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionAcceptInviteResponse call({
    String accessToken,
    String refreshToken,
    AuthUser user,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthSessionAcceptInviteResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthSessionAcceptInviteResponse.copyWith.fieldName(...)`
class _$AuthSessionAcceptInviteResponseCWProxyImpl
    implements _$AuthSessionAcceptInviteResponseCWProxy {
  const _$AuthSessionAcceptInviteResponseCWProxyImpl(this._value);

  final AuthSessionAcceptInviteResponse _value;

  @override
  AuthSessionAcceptInviteResponse accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  AuthSessionAcceptInviteResponse refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  AuthSessionAcceptInviteResponse user(AuthUser user) => this(user: user);

  @override
  AuthSessionAcceptInviteResponse module(Object? module) =>
      this(module: module);

  @override
  AuthSessionAcceptInviteResponse action(Object? action) =>
      this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionAcceptInviteResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionAcceptInviteResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionAcceptInviteResponse call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthSessionAcceptInviteResponse(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as AuthUser,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as Object?,
    );
  }
}

extension $AuthSessionAcceptInviteResponseCopyWith
    on AuthSessionAcceptInviteResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAuthSessionAcceptInviteResponse.copyWith(...)` or like so:`instanceOfAuthSessionAcceptInviteResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthSessionAcceptInviteResponseCWProxy get copyWith =>
      _$AuthSessionAcceptInviteResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionAcceptInviteResponse _$AuthSessionAcceptInviteResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthSessionAcceptInviteResponse', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'accessToken',
      'refreshToken',
      'user',
      'module',
      'action',
    ],
  );
  final val = AuthSessionAcceptInviteResponse(
    accessToken: $checkedConvert('accessToken', (v) => v as String),
    refreshToken: $checkedConvert('refreshToken', (v) => v as String),
    user: $checkedConvert(
      'user',
      (v) => AuthUser.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$AuthSessionAcceptInviteResponseToJson(
  AuthSessionAcceptInviteResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user.toJson(),
  'module': instance.module,
  'action': instance.action,
};
