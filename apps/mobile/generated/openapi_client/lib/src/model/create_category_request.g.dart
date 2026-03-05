// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateCategoryRequestCWProxy {
  CreateCategoryRequest name(String name);

  CreateCategoryRequest parentId(String? parentId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateCategoryRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateCategoryRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateCategoryRequest call({String name, String? parentId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateCategoryRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateCategoryRequest.copyWith.fieldName(...)`
class _$CreateCategoryRequestCWProxyImpl
    implements _$CreateCategoryRequestCWProxy {
  const _$CreateCategoryRequestCWProxyImpl(this._value);

  final CreateCategoryRequest _value;

  @override
  CreateCategoryRequest name(String name) => this(name: name);

  @override
  CreateCategoryRequest parentId(String? parentId) => this(parentId: parentId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateCategoryRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateCategoryRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateCategoryRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? parentId = const $CopyWithPlaceholder(),
  }) {
    return CreateCategoryRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      parentId: parentId == const $CopyWithPlaceholder()
          ? _value.parentId
          // ignore: cast_nullable_to_non_nullable
          : parentId as String?,
    );
  }
}

extension $CreateCategoryRequestCopyWith on CreateCategoryRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateCategoryRequest.copyWith(...)` or like so:`instanceOfCreateCategoryRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateCategoryRequestCWProxy get copyWith =>
      _$CreateCategoryRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryRequest _$CreateCategoryRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateCategoryRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name']);
  final val = CreateCategoryRequest(
    name: $checkedConvert('name', (v) => v as String),
    parentId: $checkedConvert('parentId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CreateCategoryRequestToJson(
  CreateCategoryRequest instance,
) => <String, dynamic>{'name': instance.name, 'parentId': ?instance.parentId};
