// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserResponseCWProxy {
  UserResponse item(CompanyUser item);

  UserResponse module(Object? module);

  UserResponse action(String? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserResponse call({CompanyUser item, Object? module, String? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserResponse.copyWith.fieldName(...)`
class _$UserResponseCWProxyImpl implements _$UserResponseCWProxy {
  const _$UserResponseCWProxyImpl(this._value);

  final UserResponse _value;

  @override
  UserResponse item(CompanyUser item) => this(item: item);

  @override
  UserResponse module(Object? module) => this(module: module);

  @override
  UserResponse action(String? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return UserResponse(
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
          : action as String?,
    );
  }
}

extension $UserResponseCopyWith on UserResponse {
  /// Returns a callable class that can be used as follows: `instanceOfUserResponse.copyWith(...)` or like so:`instanceOfUserResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserResponseCWProxy get copyWith => _$UserResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module']);
      final val = UserResponse(
        item: $checkedConvert(
          'item',
          (v) => CompanyUser.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
      'action': ?instance.action,
    };
