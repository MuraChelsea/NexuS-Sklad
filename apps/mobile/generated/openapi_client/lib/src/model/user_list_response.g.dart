// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserListResponseCWProxy {
  UserListResponse items(List<CompanyUser> items);

  UserListResponse module(Object? module);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserListResponse call({List<CompanyUser> items, Object? module});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserListResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserListResponse.copyWith.fieldName(...)`
class _$UserListResponseCWProxyImpl implements _$UserListResponseCWProxy {
  const _$UserListResponseCWProxyImpl(this._value);

  final UserListResponse _value;

  @override
  UserListResponse items(List<CompanyUser> items) => this(items: items);

  @override
  UserListResponse module(Object? module) => this(module: module);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserListResponse call({
    Object? items = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
  }) {
    return UserListResponse(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<CompanyUser>,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
    );
  }
}

extension $UserListResponseCopyWith on UserListResponse {
  /// Returns a callable class that can be used as follows: `instanceOfUserListResponse.copyWith(...)` or like so:`instanceOfUserListResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserListResponseCWProxy get copyWith => _$UserListResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListResponse _$UserListResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserListResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'module']);
      final val = UserListResponse(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => CompanyUser.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        module: $checkedConvert('module', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$UserListResponseToJson(UserListResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'module': instance.module,
    };
