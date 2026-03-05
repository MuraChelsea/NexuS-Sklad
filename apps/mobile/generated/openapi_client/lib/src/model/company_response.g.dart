// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompanyResponseCWProxy {
  CompanyResponse item(Company item);

  CompanyResponse module(Object? module);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyResponse call({Company item, Object? module});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompanyResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompanyResponse.copyWith.fieldName(...)`
class _$CompanyResponseCWProxyImpl implements _$CompanyResponseCWProxy {
  const _$CompanyResponseCWProxyImpl(this._value);

  final CompanyResponse _value;

  @override
  CompanyResponse item(Company item) => this(item: item);

  @override
  CompanyResponse module(Object? module) => this(module: module);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
  }) {
    return CompanyResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as Company,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
    );
  }
}

extension $CompanyResponseCopyWith on CompanyResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCompanyResponse.copyWith(...)` or like so:`instanceOfCompanyResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompanyResponseCWProxy get copyWith => _$CompanyResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyResponse _$CompanyResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CompanyResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module']);
      final val = CompanyResponse(
        item: $checkedConvert(
          'item',
          (v) => Company.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$CompanyResponseToJson(CompanyResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
    };
