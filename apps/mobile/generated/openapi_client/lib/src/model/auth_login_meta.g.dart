// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthLoginMetaCWProxy {
  AuthLoginMeta module(Object? module);

  AuthLoginMeta action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthLoginMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthLoginMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthLoginMeta call({Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthLoginMeta.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthLoginMeta.copyWith.fieldName(...)`
class _$AuthLoginMetaCWProxyImpl implements _$AuthLoginMetaCWProxy {
  const _$AuthLoginMetaCWProxyImpl(this._value);

  final AuthLoginMeta _value;

  @override
  AuthLoginMeta module(Object? module) => this(module: module);

  @override
  AuthLoginMeta action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthLoginMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthLoginMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthLoginMeta call({
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthLoginMeta(
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

extension $AuthLoginMetaCopyWith on AuthLoginMeta {
  /// Returns a callable class that can be used as follows: `instanceOfAuthLoginMeta.copyWith(...)` or like so:`instanceOfAuthLoginMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthLoginMetaCWProxy get copyWith => _$AuthLoginMetaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthLoginMeta _$AuthLoginMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthLoginMeta', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['module', 'action']);
      final val = AuthLoginMeta(
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$AuthLoginMetaToJson(AuthLoginMeta instance) =>
    <String, dynamic>{'module': instance.module, 'action': instance.action};
