// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_list_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditListResponseCWProxy {
  AuditListResponse items(List<AuditLog> items);

  AuditListResponse module(Object? module);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditListResponse call({List<AuditLog> items, Object? module});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditListResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditListResponse.copyWith.fieldName(...)`
class _$AuditListResponseCWProxyImpl implements _$AuditListResponseCWProxy {
  const _$AuditListResponseCWProxyImpl(this._value);

  final AuditListResponse _value;

  @override
  AuditListResponse items(List<AuditLog> items) => this(items: items);

  @override
  AuditListResponse module(Object? module) => this(module: module);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditListResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditListResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditListResponse call({
    Object? items = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
  }) {
    return AuditListResponse(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AuditLog>,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
    );
  }
}

extension $AuditListResponseCopyWith on AuditListResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAuditListResponse.copyWith(...)` or like so:`instanceOfAuditListResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditListResponseCWProxy get copyWith =>
      _$AuditListResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditListResponse _$AuditListResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditListResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'module']);
      final val = AuditListResponse(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AuditLog.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        module: $checkedConvert('module', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$AuditListResponseToJson(AuditListResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'module': instance.module,
    };
