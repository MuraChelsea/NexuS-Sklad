// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_adjustment_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateAdjustmentRequestCWProxy {
  CreateAdjustmentRequest productId(String productId);

  CreateAdjustmentRequest targetQty(num targetQty);

  CreateAdjustmentRequest comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateAdjustmentRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateAdjustmentRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateAdjustmentRequest call({
    String productId,
    num targetQty,
    String? comment,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateAdjustmentRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateAdjustmentRequest.copyWith.fieldName(...)`
class _$CreateAdjustmentRequestCWProxyImpl
    implements _$CreateAdjustmentRequestCWProxy {
  const _$CreateAdjustmentRequestCWProxyImpl(this._value);

  final CreateAdjustmentRequest _value;

  @override
  CreateAdjustmentRequest productId(String productId) =>
      this(productId: productId);

  @override
  CreateAdjustmentRequest targetQty(num targetQty) =>
      this(targetQty: targetQty);

  @override
  CreateAdjustmentRequest comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateAdjustmentRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateAdjustmentRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateAdjustmentRequest call({
    Object? productId = const $CopyWithPlaceholder(),
    Object? targetQty = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return CreateAdjustmentRequest(
      productId: productId == const $CopyWithPlaceholder()
          ? _value.productId
          // ignore: cast_nullable_to_non_nullable
          : productId as String,
      targetQty: targetQty == const $CopyWithPlaceholder()
          ? _value.targetQty
          // ignore: cast_nullable_to_non_nullable
          : targetQty as num,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $CreateAdjustmentRequestCopyWith on CreateAdjustmentRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateAdjustmentRequest.copyWith(...)` or like so:`instanceOfCreateAdjustmentRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateAdjustmentRequestCWProxy get copyWith =>
      _$CreateAdjustmentRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAdjustmentRequest _$CreateAdjustmentRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateAdjustmentRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['productId', 'targetQty']);
  final val = CreateAdjustmentRequest(
    productId: $checkedConvert('productId', (v) => v as String),
    targetQty: $checkedConvert('targetQty', (v) => v as num),
    comment: $checkedConvert('comment', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CreateAdjustmentRequestToJson(
  CreateAdjustmentRequest instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'targetQty': instance.targetQty,
  'comment': ?instance.comment,
};
