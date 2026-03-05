// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompanyCWProxy {
  Company id(String id);

  Company name(String name);

  Company city(String? city);

  Company phone(String? phone);

  Company createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Company(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Company(...).copyWith(id: 12, name: "My name")
  /// ````
  Company call({
    String id,
    String name,
    String? city,
    String? phone,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompany.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompany.copyWith.fieldName(...)`
class _$CompanyCWProxyImpl implements _$CompanyCWProxy {
  const _$CompanyCWProxyImpl(this._value);

  final Company _value;

  @override
  Company id(String id) => this(id: id);

  @override
  Company name(String name) => this(name: name);

  @override
  Company city(String? city) => this(city: city);

  @override
  Company phone(String? phone) => this(phone: phone);

  @override
  Company createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Company(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Company(...).copyWith(id: 12, name: "My name")
  /// ````
  Company call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return Company(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $CompanyCopyWith on Company {
  /// Returns a callable class that can be used as follows: `instanceOfCompany.copyWith(...)` or like so:`instanceOfCompany.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompanyCWProxy get copyWith => _$CompanyCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Company', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'createdAt']);
      final val = Company(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'city': ?instance.city,
  'phone': ?instance.phone,
  'createdAt': instance.createdAt.toIso8601String(),
};
