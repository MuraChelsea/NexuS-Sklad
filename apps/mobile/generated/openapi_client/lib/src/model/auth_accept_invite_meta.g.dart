// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_accept_invite_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthAcceptInviteMetaCWProxy {
  AuthAcceptInviteMeta module(Object? module);

  AuthAcceptInviteMeta action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthAcceptInviteMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthAcceptInviteMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthAcceptInviteMeta call({Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthAcceptInviteMeta.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthAcceptInviteMeta.copyWith.fieldName(...)`
class _$AuthAcceptInviteMetaCWProxyImpl
    implements _$AuthAcceptInviteMetaCWProxy {
  const _$AuthAcceptInviteMetaCWProxyImpl(this._value);

  final AuthAcceptInviteMeta _value;

  @override
  AuthAcceptInviteMeta module(Object? module) => this(module: module);

  @override
  AuthAcceptInviteMeta action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthAcceptInviteMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthAcceptInviteMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthAcceptInviteMeta call({
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthAcceptInviteMeta(
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

extension $AuthAcceptInviteMetaCopyWith on AuthAcceptInviteMeta {
  /// Returns a callable class that can be used as follows: `instanceOfAuthAcceptInviteMeta.copyWith(...)` or like so:`instanceOfAuthAcceptInviteMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthAcceptInviteMetaCWProxy get copyWith =>
      _$AuthAcceptInviteMetaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthAcceptInviteMeta _$AuthAcceptInviteMetaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuthAcceptInviteMeta', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['module', 'action']);
  final val = AuthAcceptInviteMeta(
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$AuthAcceptInviteMetaToJson(
  AuthAcceptInviteMeta instance,
) => <String, dynamic>{'module': instance.module, 'action': instance.action};
