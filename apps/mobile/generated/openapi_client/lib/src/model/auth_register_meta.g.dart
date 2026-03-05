// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_register_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthRegisterMetaCWProxy {
  AuthRegisterMeta module(Object? module);

  AuthRegisterMeta action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthRegisterMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthRegisterMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthRegisterMeta call({Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthRegisterMeta.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthRegisterMeta.copyWith.fieldName(...)`
class _$AuthRegisterMetaCWProxyImpl implements _$AuthRegisterMetaCWProxy {
  const _$AuthRegisterMetaCWProxyImpl(this._value);

  final AuthRegisterMeta _value;

  @override
  AuthRegisterMeta module(Object? module) => this(module: module);

  @override
  AuthRegisterMeta action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthRegisterMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthRegisterMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthRegisterMeta call({
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return AuthRegisterMeta(
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

extension $AuthRegisterMetaCopyWith on AuthRegisterMeta {
  /// Returns a callable class that can be used as follows: `instanceOfAuthRegisterMeta.copyWith(...)` or like so:`instanceOfAuthRegisterMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthRegisterMetaCWProxy get copyWith => _$AuthRegisterMetaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRegisterMeta _$AuthRegisterMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthRegisterMeta', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['module', 'action']);
      final val = AuthRegisterMeta(
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$AuthRegisterMetaToJson(AuthRegisterMeta instance) =>
    <String, dynamic>{'module': instance.module, 'action': instance.action};
