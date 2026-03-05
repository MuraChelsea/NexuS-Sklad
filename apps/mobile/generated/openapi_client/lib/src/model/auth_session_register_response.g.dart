// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_register_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthSessionRegisterResponseCWProxy {
  AuthSessionRegisterResponse accessToken(String accessToken);

  AuthSessionRegisterResponse refreshToken(String refreshToken);

  AuthSessionRegisterResponse user(AuthUser user);

  AuthSessionRegisterResponse module(Object? module);

  AuthSessionRegisterResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionRegisterResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionRegisterResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionRegisterResponse call({
    String accessToken,
    String refreshToken,
    AuthUser user,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthSessionRegisterResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthSessionRegisterResponse.copyWith.fieldName(...)`
class _$AuthSessionRegisterResponseCWProxyImpl
    implements _$AuthSessionRegisterResponseCWProxy {
  const _$AuthSessionRegisterResponseCWProxyImpl(this._value);

  final AuthSessionRegisterResponse _value;

  @override
  AuthSessionRegisterResponse accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  AuthSessionRegisterResponse refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  AuthSessionRegisterResponse user(AuthUser user) => this(user: user);

  @override
  AuthSessionRegisterResponse module(Object? module) => this(module: module);

  @override
  AuthSessionRegisterResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSessionRegisterResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSessionRegisterResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSessionRegisterResponse call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthSessionRegisterResponse(
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

extension $AuthSessionRegisterResponseCopyWith on AuthSessionRegisterResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAuthSessionRegisterResponse.copyWith(...)` or like so:`instanceOfAuthSessionRegisterResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthSessionRegisterResponseCWProxy get copyWith =>
      _$AuthSessionRegisterResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionRegisterResponse _$AuthSessionRegisterResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthSessionRegisterResponse', json, ($checkedConvert) {
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
  final val = AuthSessionRegisterResponse(
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

Map<String, dynamic> _$AuthSessionRegisterResponseToJson(
  AuthSessionRegisterResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user.toJson(),
  'module': instance.module,
  'action': instance.action,
};
