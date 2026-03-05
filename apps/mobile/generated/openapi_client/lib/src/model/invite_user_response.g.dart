// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_user_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InviteUserResponseCWProxy {
  InviteUserResponse user(CompanyUser user);

  InviteUserResponse inviteToken(String inviteToken);

  InviteUserResponse module(Object? module);

  InviteUserResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InviteUserResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InviteUserResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InviteUserResponse call({
    CompanyUser user,
    String inviteToken,
    Object? module,
    Object? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInviteUserResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInviteUserResponse.copyWith.fieldName(...)`
class _$InviteUserResponseCWProxyImpl implements _$InviteUserResponseCWProxy {
  const _$InviteUserResponseCWProxyImpl(this._value);

  final InviteUserResponse _value;

  @override
  InviteUserResponse user(CompanyUser user) => this(user: user);

  @override
  InviteUserResponse inviteToken(String inviteToken) =>
      this(inviteToken: inviteToken);

  @override
  InviteUserResponse module(Object? module) => this(module: module);

  @override
  InviteUserResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InviteUserResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InviteUserResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  InviteUserResponse call({
    Object? user = const $CopyWithPlaceholder(),
    Object? inviteToken = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return InviteUserResponse(
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as CompanyUser,
      inviteToken: inviteToken == const $CopyWithPlaceholder()
          ? _value.inviteToken
          // ignore: cast_nullable_to_non_nullable
          : inviteToken as String,
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

extension $InviteUserResponseCopyWith on InviteUserResponse {
  /// Returns a callable class that can be used as follows: `instanceOfInviteUserResponse.copyWith(...)` or like so:`instanceOfInviteUserResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InviteUserResponseCWProxy get copyWith =>
      _$InviteUserResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteUserResponse _$InviteUserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InviteUserResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['user', 'inviteToken', 'module', 'action'],
      );
      final val = InviteUserResponse(
        user: $checkedConvert(
          'user',
          (v) => CompanyUser.fromJson(v as Map<String, dynamic>),
        ),
        inviteToken: $checkedConvert('inviteToken', (v) => v as String),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$InviteUserResponseToJson(InviteUserResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'inviteToken': instance.inviteToken,
      'module': instance.module,
      'action': instance.action,
    };
