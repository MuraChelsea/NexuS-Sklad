// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_update_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryUpdateResponseCWProxy {
  CategoryUpdateResponse item(Category item);

  CategoryUpdateResponse module(Object? module);

  CategoryUpdateResponse action(Object? action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryUpdateResponse call({Category item, Object? module, Object? action});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCategoryUpdateResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCategoryUpdateResponse.copyWith.fieldName(...)`
class _$CategoryUpdateResponseCWProxyImpl
    implements _$CategoryUpdateResponseCWProxy {
  const _$CategoryUpdateResponseCWProxyImpl(this._value);

  final CategoryUpdateResponse _value;

  @override
  CategoryUpdateResponse item(Category item) => this(item: item);

  @override
  CategoryUpdateResponse module(Object? module) => this(module: module);

  @override
  CategoryUpdateResponse action(Object? action) => this(action: action);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryUpdateResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryUpdateResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryUpdateResponse call({
    Object? item = const $CopyWithPlaceholder(),
    Object? module = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return CategoryUpdateResponse(
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
          : action as Object?,
    );
  }
}

extension $CategoryUpdateResponseCopyWith on CategoryUpdateResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCategoryUpdateResponse.copyWith(...)` or like so:`instanceOfCategoryUpdateResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryUpdateResponseCWProxy get copyWith =>
      _$CategoryUpdateResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryUpdateResponse _$CategoryUpdateResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CategoryUpdateResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['item', 'module']);
  final val = CategoryUpdateResponse(
    item: $checkedConvert(
      'item',
      (v) => Category.fromJson(v as Map<String, dynamic>),
    ),
    module: $checkedConvert('module', (v) => v),
    action: $checkedConvert('action', (v) => v),
  );
  return val;
});

Map<String, dynamic> _$CategoryUpdateResponseToJson(
  CategoryUpdateResponse instance,
) => <String, dynamic>{
  'item': instance.item.toJson(),
  'module': instance.module,
  'action': ?instance.action,
};
