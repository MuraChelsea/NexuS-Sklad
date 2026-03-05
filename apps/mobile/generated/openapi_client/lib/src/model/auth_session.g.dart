// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthSessionCWProxy {
  AuthSession accessToken(String accessToken);

  AuthSession refreshToken(String refreshToken);

  AuthSession user(AuthUser user);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSession(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSession(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSession call({String accessToken, String refreshToken, AuthUser user});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthSession.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthSession.copyWith.fieldName(...)`
class _$AuthSessionCWProxyImpl implements _$AuthSessionCWProxy {
  const _$AuthSessionCWProxyImpl(this._value);

  final AuthSession _value;

  @override
  AuthSession accessToken(String accessToken) => this(accessToken: accessToken);

  @override
  AuthSession refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  AuthSession user(AuthUser user) => this(user: user);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthSession(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthSession(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthSession call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
  }) {
    return AuthSession(
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
    );
  }
}

extension $AuthSessionCopyWith on AuthSession {
  /// Returns a callable class that can be used as follows: `instanceOfAuthSession.copyWith(...)` or like so:`instanceOfAuthSession.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthSessionCWProxy get copyWith => _$AuthSessionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthSession', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['accessToken', 'refreshToken', 'user'],
      );
      final val = AuthSession(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        user: $checkedConvert(
          'user',
          (v) => AuthUser.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuthSessionToJson(AuthSession instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user.toJson(),
    };
