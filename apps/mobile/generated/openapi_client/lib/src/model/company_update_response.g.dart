// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_update_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CompanyUpdateResponseCWProxy {
  CompanyUpdateResponse item(Company item);

  CompanyUpdateResponse module(Object? module);

  CompanyUpdateResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyUpdateResponse call({Company item, Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCompanyUpdateResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCompanyUpdateResponse.copyWith.fieldName(...)`
class _$CompanyUpdateResponseCWProxyImpl
    implements _$CompanyUpdateResponseCWProxy {
  const _$CompanyUpdateResponseCWProxyImpl(this._value);

  final CompanyUpdateResponse _value;

  @override
  CompanyUpdateResponse item(Company item) => this(item: item);

  @override
  CompanyUpdateResponse module(Object? module) => this(module: module);

  @override
  CompanyUpdateResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CompanyUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CompanyUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CompanyUpdateResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return CompanyUpdateResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as Company,
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

extension $CompanyUpdateResponseCopyWith on CompanyUpdateResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCompanyUpdateResponse.copyWith(...)` or like so:`instanceOfCompanyUpdateResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CompanyUpdateResponseCWProxy get copyWith =>
      _$CompanyUpdateResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyUpdateResponse _$CompanyUpdateResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CompanyUpdateResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module', 'action']);
  final val = CompanyUpdateResponse(
    item: $checkedConvert(
      'item',
      (v) => Company.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$CompanyUpdateResponseToJson(
  CompanyUpdateResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': instance.action,
};
