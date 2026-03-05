// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RegisterRequestCWProxy {
  RegisterRequest companyName(String companyName);

  RegisterRequest companyCity(String? companyCity);

  RegisterRequest companyPhone(String? companyPhone);

  RegisterRequest ownerName(String ownerName);

  RegisterRequest email(String email);

  RegisterRequest phone(String? phone);

  RegisterRequest password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RegisterRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RegisterRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  RegisterRequest call({
    String companyName,
    String? companyCity,
    String? companyPhone,
    String ownerName,
    String email,
    String? phone,
    String password,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRegisterRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRegisterRequest.copyWith.fieldName(...)`
class _$RegisterRequestCWProxyImpl implements _$RegisterRequestCWProxy {
  const _$RegisterRequestCWProxyImpl(this._value);

  final RegisterRequest _value;

  @override
  RegisterRequest companyName(String companyName) =>
      this(companyName: companyName);

  @override
  RegisterRequest companyCity(String? companyCity) =>
      this(companyCity: companyCity);

  @override
  RegisterRequest companyPhone(String? companyPhone) =>
      this(companyPhone: companyPhone);

  @override
  RegisterRequest ownerName(String ownerName) => this(ownerName: ownerName);

  @override
  RegisterRequest email(String email) => this(email: email);

  @override
  RegisterRequest phone(String? phone) => this(phone: phone);

  @override
  RegisterRequest password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RegisterRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RegisterRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  RegisterRequest call({
    Object? companyName = const $CopyWithPlaceholder(),
    Object? companyCity = const $CopyWithPlaceholder(),
    Object? companyPhone = const $CopyWithPlaceholder(),
    Object? ownerName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return RegisterRequest(
      companyName: companyName == const $CopyWithPlaceholder()
          ? _value.companyName
          // ignore: cast_nullable_to_non_nullable
          : companyName as String,
      companyCity: companyCity == const $CopyWithPlaceholder()
          ? _value.companyCity
          // ignore: cast_nullable_to_non_nullable
          : companyCity as String?,
      companyPhone: companyPhone == const $CopyWithPlaceholder()
          ? _value.companyPhone
          // ignore: cast_nullable_to_non_nullable
          : companyPhone as String?,
      ownerName: ownerName == const $CopyWithPlaceholder()
          ? _value.ownerName
          // ignore: cast_nullable_to_non_nullable
          : ownerName as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $RegisterRequestCopyWith on RegisterRequest {
  /// Returns a callable class that can be used as follows: `instanceOfRegisterRequest.copyWith(...)` or like so:`instanceOfRegisterRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RegisterRequestCWProxy get copyWith => _$RegisterRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RegisterRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['companyName', 'ownerName', 'email', 'password'],
      );
      final val = RegisterRequest(
        companyName: $checkedConvert('companyName', (v) => v as String),
        companyCity: $checkedConvert('companyCity', (v) => v as String?),
        companyPhone: $checkedConvert('companyPhone', (v) => v as String?),
        ownerName: $checkedConvert('ownerName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String?),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'companyCity': ?instance.companyCity,
      'companyPhone': ?instance.companyPhone,
      'ownerName': instance.ownerName,
      'email': instance.email,
      'phone': ?instance.phone,
      'password': instance.password,
    };
