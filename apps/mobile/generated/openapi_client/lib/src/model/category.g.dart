// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryCWProxy {
  Category id(String id);

  Category companyId(String companyId);

  Category parentId(String? parentId);

  Category name(String name);

  Category createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Category(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Category(...).copyWith(id: 12, name: "My name")
  /// ````
  Category call({
    String id,
    String companyId,
    String? parentId,
    String name,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCategory.copyWith.fieldName(...)`
class _$CategoryCWProxyImpl implements _$CategoryCWProxy {
  const _$CategoryCWProxyImpl(this._value);

  final Category _value;

  @override
  Category id(String id) => this(id: id);

  @override
  Category companyId(String companyId) => this(companyId: companyId);

  @override
  Category parentId(String? parentId) => this(parentId: parentId);

  @override
  Category name(String name) => this(name: name);

  @override
  Category createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Category(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Category(...).copyWith(id: 12, name: "My name")
  /// ````
  Category call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? parentId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return Category(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      companyId: companyId == const $CopyWithPlaceholder()
          ? _value.companyId
          // ignore: cast_nullable_to_non_nullable
          : companyId as String,
      parentId: parentId == const $CopyWithPlaceholder()
          ? _value.parentId
          // ignore: cast_nullable_to_non_nullable
          : parentId as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $CategoryCopyWith on Category {
  /// Returns a callable class that can be used as follows: `instanceOfCategory.copyWith(...)` or like so:`instanceOfCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryCWProxy get copyWith => _$CategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Category', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'companyId', 'name', 'createdAt'],
      );
      final val = Category(
        id: $checkedConvert('id', (v) => v as String),
        companyId: $checkedConvert('companyId', (v) => v as String),
        parentId: $checkedConvert('parentId', (v) => v as String?),
        name: $checkedConvert('name', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'companyId': instance.companyId,
  'parentId': ?instance.parentId,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
};
