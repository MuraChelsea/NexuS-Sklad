// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_login_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthSessionLoginResponseCWProxy {
  AuthSessionLoginResponse accessToken(String accessToken);

  AuthSessionLoginResponse refreshToken(String refreshToken);

  AuthSessionLoginResponse user(AuthUser user);

  AuthSessionLoginResponse module(Object? module);

  AuthSessionLoginResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionLoginResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionLoginResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionLoginResponse call({
    String accessToken,
    String refreshToken,
    AuthUser user,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthSessionLoginResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthSessionLoginResponse.copyWith.fieldName(...)`
class _$AuthSessionLoginResponseCWProxyImpl
    implements _$AuthSessionLoginResponseCWProxy {
  const _$AuthSessionLoginResponseCWProxyImpl(this._value);

  final AuthSessionLoginResponse _value;

  @override
  AuthSessionLoginResponse accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  AuthSessionLoginResponse refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  AuthSessionLoginResponse user(AuthUser user) => this(user: user);

  @override
  AuthSessionLoginResponse module(Object? module) => this(module: module);

  @override
  AuthSessionLoginResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionLoginResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionLoginResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionLoginResponse call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthSessionLoginResponse(
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

extension $AuthSessionLoginResponseCopyWith on AuthSessionLoginResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAuthSessionLoginResponse.copyWith(...)` or like so:`instanceOfAuthSessionLoginResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthSessionLoginResponseCWProxy get copyWith =>
      _$AuthSessionLoginResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionLoginResponse _$AuthSessionLoginResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthSessionLoginResponse', json, ($checkedConvert) {
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
  final val = AuthSessionLoginResponse(
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

Map<String, dynamic> _$AuthSessionLoginResponseToJson(
  AuthSessionLoginResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user.toJson(),
  'module': instance.module,
  'action': instance.action,
};
