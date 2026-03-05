// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_inventory_item_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateInventoryItemRequestCWProxy {
  UpdateInventoryItemRequest actualQty(num actualQty);

  UpdateInventoryItemRequest comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateInventoryItemRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateInventoryItemRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateInventoryItemRequest call({num actualQty, String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateInventoryItemRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateInventoryItemRequest.copyWith.fieldName(...)`
class _$UpdateInventoryItemRequestCWProxyImpl
    implements _$UpdateInventoryItemRequestCWProxy {
  const _$UpdateInventoryItemRequestCWProxyImpl(this._value);

  final UpdateInventoryItemRequest _value;

  @override
  UpdateInventoryItemRequest actualQty(num actualQty) =>
      this(actualQty: actualQty);

  @override
  UpdateInventoryItemRequest comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateInventoryItemRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateInventoryItemRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateInventoryItemRequest call({
    Object? actualQty = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return UpdateInventoryItemRequest(
      actualQty: actualQty == const $CopyWithPlaceholder()
          ? _value.actualQty
          // ignore: cast_nullable_to_non_nullable
          : actualQty as num,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $UpdateInventoryItemRequestCopyWith on UpdateInventoryItemRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateInventoryItemRequest.copyWith(...)` or like so:`instanceOfUpdateInventoryItemRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateInventoryItemRequestCWProxy get copyWith =>
      _$UpdateInventoryItemRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInventoryItemRequest _$UpdateInventoryItemRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateInventoryItemRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['actualQty']);
  final val = UpdateInventoryItemRequest(
    actualQty: $checkedConvert('actualQty', (v) => v as num),
    comment: $checkedConvert('comment', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UpdateInventoryItemRequestToJson(
  UpdateInventoryItemRequest instance,
) => <String, dynamic>{
  'actualQty': instance.actualQty,
  'comment': ?instance.comment,
};
