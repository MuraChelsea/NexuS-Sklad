// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_movement_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateMovementRequestCWProxy {
  CreateMovementRequest productId(String productId);

  CreateMovementRequest quantity(num quantity);

  CreateMovementRequest comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateMovementRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateMovementRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateMovementRequest call({String productId, num quantity, String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateMovementRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateMovementRequest.copyWith.fieldName(...)`
class _$CreateMovementRequestCWProxyImpl
    implements _$CreateMovementRequestCWProxy {
  const _$CreateMovementRequestCWProxyImpl(this._value);

  final CreateMovementRequest _value;

  @override
  CreateMovementRequest productId(String productId) =>
      this(productId: productId);

  @override
  CreateMovementRequest quantity(num quantity) => this(quantity: quantity);

  @override
  CreateMovementRequest comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateMovementRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateMovementRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateMovementRequest call({
    Object? productId = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return CreateMovementRequest(
      productId: productId == const $CopyWithPlaceholder()
          ? _value.productId
          // ignore: cast_nullable_to_non_nullable
          : productId as String,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as num,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $CreateMovementRequestCopyWith on CreateMovementRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateMovementRequest.copyWith(...)` or like so:`instanceOfCreateMovementRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateMovementRequestCWProxy get copyWith =>
      _$CreateMovementRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMovementRequest _$CreateMovementRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateMovementRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['productId', 'quantity']);
  final val = CreateMovementRequest(
    productId: $checkedConvert('productId', (v) => v as String),
    quantity: $checkedConvert('quantity', (v) => v as num),
    comment: $checkedConvert('comment', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CreateMovementRequestToJson(
  CreateMovementRequest instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
  'comment': ?instance.comment,
};
