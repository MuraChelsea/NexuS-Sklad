// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_company_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateCompanyRequestCWProxy {
  UpdateCompanyRequest name(String? name);

  UpdateCompanyRequest city(String? city);

  UpdateCompanyRequest phone(String? phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateCompanyRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateCompanyRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateCompanyRequest call({String? name, String? city, String? phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateCompanyRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateCompanyRequest.copyWith.fieldName(...)`
class _$UpdateCompanyRequestCWProxyImpl
    implements _$UpdateCompanyRequestCWProxy {
  const _$UpdateCompanyRequestCWProxyImpl(this._value);

  final UpdateCompanyRequest _value;

  @override
  UpdateCompanyRequest name(String? name) => this(name: name);

  @override
  UpdateCompanyRequest city(String? city) => this(city: city);

  @override
  UpdateCompanyRequest phone(String? phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateCompanyRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateCompanyRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateCompanyRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
  }) {
    return UpdateCompanyRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
    );
  }
}

extension $UpdateCompanyRequestCopyWith on UpdateCompanyRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateCompanyRequest.copyWith(...)` or like so:`instanceOfUpdateCompanyRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateCompanyRequestCWProxy get copyWith =>
      _$UpdateCompanyRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCompanyRequest _$UpdateCompanyRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateCompanyRequest', json, ($checkedConvert) {
  final val = UpdateCompanyRequest(
    name: $checkedConvert('name', (v) => v as String?),
    city: $checkedConvert('city', (v) => v as String?),
    phone: $checkedConvert('phone', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UpdateCompanyRequestToJson(
  UpdateCompanyRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'city': ?instance.city,
  'phone': ?instance.phone,
};
