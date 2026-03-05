// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_refresh_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthSessionRefreshResponseCWProxy {
  AuthSessionRefreshResponse accessToken(String accessToken);

  AuthSessionRefreshResponse refreshToken(String refreshToken);

  AuthSessionRefreshResponse user(AuthUser user);

  AuthSessionRefreshResponse module(Object? module);

  AuthSessionRefreshResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionRefreshResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionRefreshResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionRefreshResponse call({
    String accessToken,
    String refreshToken,
    AuthUser user,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthSessionRefreshResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthSessionRefreshResponse.copyWith.fieldName(...)`
class _$AuthSessionRefreshResponseCWProxyImpl
    implements _$AuthSessionRefreshResponseCWProxy {
  const _$AuthSessionRefreshResponseCWProxyImpl(this._value);

  final AuthSessionRefreshResponse _value;

  @override
  AuthSessionRefreshResponse accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  AuthSessionRefreshResponse refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  AuthSessionRefreshResponse user(AuthUser user) => this(user: user);

  @override
  AuthSessionRefreshResponse module(Object? module) => this(module: module);

  @override
  AuthSessionRefreshResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionRefreshResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionRefreshResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionRefreshResponse call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthSessionRefreshResponse(
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

extension $AuthSessionRefreshResponseCopyWith on AuthSessionRefreshResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAuthSessionRefreshResponse.copyWith(...)` or like so:`instanceOfAuthSessionRefreshResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthSessionRefreshResponseCWProxy get copyWith =>
      _$AuthSessionRefreshResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionRefreshResponse _$AuthSessionRefreshResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthSessionRefreshResponse', json, ($checkedConvert) {
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
  final val = AuthSessionRefreshResponse(
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

Map<String, dynamic> _$AuthSessionRefreshResponseToJson(
  AuthSessionRefreshResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user.toJson(),
  'module': instance.module,
  'action': instance.action,
};
