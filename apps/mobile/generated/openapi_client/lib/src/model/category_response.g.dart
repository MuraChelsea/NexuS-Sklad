// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryResponseCWProxy {
  CategoryResponse item(Category item);

  CategoryResponse module(Object? module);

  CategoryResponse action(String? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryResponse call({Category item, Object? module, String? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCategoryResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCategoryResponse.copyWith.fieldName(...)`
class _$CategoryResponseCWProxyImpl implements _$CategoryResponseCWProxy {
  const _$CategoryResponseCWProxyImpl(this._value);

  final CategoryResponse _value;

  @override
  CategoryResponse item(Category item) => this(item: item);

  @override
  CategoryResponse module(Object? module) => this(module: module);

  @override
  CategoryResponse action(String? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return CategoryResponse(
      item: item == const $CopyWithPlaceholder()
          ? _value.item
          // ignore: cast_nullable_to_non_nullable
          : item as Category,
      module: module == const $CopyWithPlaceholder()
          ? _value.module
          // ignore: cast_nullable_to_non_nullable
          : module as Object?,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String?,
    );
  }
}

extension $CategoryResponseCopyWith on CategoryResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCategoryResponse.copyWith(...)` or like so:`instanceOfCategoryResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryResponseCWProxy get copyWith => _$CategoryResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CategoryResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['item', 'module']);
      final val = CategoryResponse(
        item: $checkedConvert(
          'item',
          (v) => Category.fromJson(v as Map<String, dynamic>),
        ),
        module: $checkedConvert('module', (v) => v),
        action: $checkedConvert('action', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
      'module': instance.module,
      'action': ?instance.action,
    };
