// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_inventory_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartInventoryRequestCWProxy {
  StartInventoryRequest categoryId(String? categoryId);

  StartInventoryRequest productIds(List<String>? productIds);

  StartInventoryRequest comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartInventoryRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartInventoryRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  StartInventoryRequest call({
    String? categoryId,
    List<String>? productIds,
    String? comment,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStartInventoryRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStartInventoryRequest.copyWith.fieldName(...)`
class _$StartInventoryRequestCWProxyImpl
    implements _$StartInventoryRequestCWProxy {
  const _$StartInventoryRequestCWProxyImpl(this._value);

  final StartInventoryRequest _value;

  @override
  StartInventoryRequest categoryId(String? categoryId) =>
      this(categoryId: categoryId);

  @override
  StartInventoryRequest productIds(List<String>? productIds) =>
      this(productIds: productIds);

  @override
  StartInventoryRequest comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartInventoryRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartInventoryRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  StartInventoryRequest call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? productIds = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return StartInventoryRequest(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as String?,
      productIds: productIds == const $CopyWithPlaceholder()
          ? _value.productIds
          // ignore: cast_nullable_to_non_nullable
          : productIds as List<String>?,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $StartInventoryRequestCopyWith on StartInventoryRequest {
  /// Returns a callable class that can be used as follows: `instanceOfStartInventoryRequest.copyWith(...)` or like so:`instanceOfStartInventoryRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartInventoryRequestCWProxy get copyWith =>
      _$StartInventoryRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartInventoryRequest _$StartInventoryRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StartInventoryRequest', json, ($checkedConvert) {
  final val = StartInventoryRequest(
    categoryId: $checkedConvert('categoryId', (v) => v as String?),
    productIds: $checkedConvert(
      'productIds',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
    ),
    comment: $checkedConvert('comment', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$StartInventoryRequestToJson(
  StartInventoryRequest instance,
) => <String, dynamic>{
  'categoryId': ?instance.categoryId,
  'productIds': ?instance.productIds,
  'comment': ?instance.comment,
};
