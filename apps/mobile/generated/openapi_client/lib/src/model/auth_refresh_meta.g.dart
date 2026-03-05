// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthRefreshMetaCWProxy {
  AuthRefreshMeta module(Object? module);

  AuthRefreshMeta action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthRefreshMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthRefreshMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthRefreshMeta call({Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthRefreshMeta.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthRefreshMeta.copyWith.fieldName(...)`
class _$AuthRefreshMetaCWProxyImpl implements _$AuthRefreshMetaCWProxy {
  const _$AuthRefreshMetaCWProxyImpl(this._value);

  final AuthRefreshMeta _value;

  @override
  AuthRefreshMeta module(Object? module) => this(module: module);

  @override
  AuthRefreshMeta action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthRefreshMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthRefreshMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthRefreshMeta call({
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthRefreshMeta(
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

extension $AuthRefreshMetaCopyWith on AuthRefreshMeta {
  /// Returns a callable class that can be used as follows: `instanceOfAuthRefreshMeta.copyWith(...)` or like so:`instanceOfAuthRefreshMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthRefreshMetaCWProxy get copyWith => _$AuthRefreshMetaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshMeta _$AuthRefreshMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthRefreshMeta', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['module', 'action']);
      final val = AuthRefreshMeta(
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$AuthRefreshMetaToJson(AuthRefreshMeta instance) =>
    <String, dynamic>{'module': instance.module, 'action': instance.action};
