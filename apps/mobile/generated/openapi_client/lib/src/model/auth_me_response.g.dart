// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_me_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthMeResponseCWProxy {
  AuthMeResponse user(AuthUser user);

  AuthMeResponse module(Object? module);

  AuthMeResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthMeResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthMeResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthMeResponse call({AuthUser user, Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthMeResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthMeResponse.copyWith.fieldName(...)`
class _$AuthMeResponseCWProxyImpl implements _$AuthMeResponseCWProxy {
  const _$AuthMeResponseCWProxyImpl(this._value);

  final AuthMeResponse _value;

  @override
  AuthMeResponse user(AuthUser user) => this(user: user);

  @override
  AuthMeResponse module(Object? module) => this(module: module);

  @override
  AuthMeResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthMeResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthMeResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthMeResponse call({
    Object? user = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthMeResponse(
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

extension $AuthMeResponseCopyWith on AuthMeResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAuthMeResponse.copyWith(...)` or like so:`instanceOfAuthMeResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthMeResponseCWProxy get copyWith => _$AuthMeResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthMeResponse _$AuthMeResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthMeResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['user', 'module', 'action']);
      final val = AuthMeResponse(
        user: $checkedConvert(
          'user',
          (v) => AuthUser.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$AuthMeResponseToJson(AuthMeResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'module': instance.module,
      'action': instance.action,
    };
