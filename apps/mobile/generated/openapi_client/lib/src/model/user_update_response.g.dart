// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserUpdateResponseCWProxy {
  UserUpdateResponse item(CompanyUser item);

  UserUpdateResponse module(Object? module);

  UserUpdateResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserUpdateResponse call({CompanyUser item, Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserUpdateResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserUpdateResponse.copyWith.fieldName(...)`
class _$UserUpdateResponseCWProxyImpl implements _$UserUpdateResponseCWProxy {
  const _$UserUpdateResponseCWProxyImpl(this._value);

  final UserUpdateResponse _value;

  @override
  UserUpdateResponse item(CompanyUser item) => this(item: item);

  @override
  UserUpdateResponse module(Object? module) => this(module: module);

  @override
  UserUpdateResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserUpdateResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return UserUpdateResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as CompanyUser,
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

extension $UserUpdateResponseCopyWith on UserUpdateResponse {
  /// Returns a callable class that can be used as follows: `instanceOfUserUpdateResponse.copyWith(...)` or like so:`instanceOfUserUpdateResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserUpdateResponseCWProxy get copyWith =>
      _$UserUpdateResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateResponse _$UserUpdateResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserUpdateResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module']);
      final val = UserUpdateResponse(
        item: $checkedConvert(
          'item',
          (v) => CompanyUser.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$UserUpdateResponseToJson(UserUpdateResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
      'action': ?instance.action,
    };
