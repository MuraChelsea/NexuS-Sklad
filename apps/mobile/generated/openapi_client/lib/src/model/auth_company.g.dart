// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_company.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthCompanyCWProxy {
  AuthCompany id(String id);

  AuthCompany name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthCompany(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthCompany(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthCompany call({String id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthCompany.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthCompany.copyWith.fieldName(...)`
class _$AuthCompanyCWProxyImpl implements _$AuthCompanyCWProxy {
  const _$AuthCompanyCWProxyImpl(this._value);

  final AuthCompany _value;

  @override
  AuthCompany id(String id) => this(id: id);

  @override
  AuthCompany name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthCompany(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthCompany(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthCompany call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return AuthCompany(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $AuthCompanyCopyWith on AuthCompany {
  /// Returns a callable class that can be used as follows: `instanceOfAuthCompany.copyWith(...)` or like so:`instanceOfAuthCompany.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthCompanyCWProxy get copyWith => _$AuthCompanyCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCompany _$AuthCompanyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthCompany', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name']);
      final val = AuthCompany(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AuthCompanyToJson(AuthCompany instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
