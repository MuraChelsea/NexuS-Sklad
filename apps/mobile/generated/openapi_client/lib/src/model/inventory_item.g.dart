// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InventoryItemCWProxy {
  InventoryItem id(String id);

  InventoryItem sessionId(String sessionId);

  InventoryItem productId(String productId);

  InventoryItem expectedQty(String expectedQty);

  InventoryItem actualQty(String actualQty);

  InventoryItem difference(String difference);

  InventoryItem comment(String? comment);

  InventoryItem product(InventoryProduct product);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryItem(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryItem call({
    String id,
    String sessionId,
    String productId,
    String expectedQty,
    String actualQty,
    String difference,
    String? comment,
    InventoryProduct product,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInventoryItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInventoryItem.copyWith.fieldName(...)`
class _$InventoryItemCWProxyImpl implements _$InventoryItemCWProxy {
  const _$InventoryItemCWProxyImpl(this._value);

  final InventoryItem _value;

  @override
  InventoryItem id(String id) => this(id: id);

  @override
  InventoryItem sessionId(String sessionId) => this(sessionId: sessionId);

  @override
  InventoryItem productId(String productId) => this(productId: productId);

  @override
  InventoryItem expectedQty(String expectedQty) =>
      this(expectedQty: expectedQty);

  @override
  InventoryItem actualQty(String actualQty) => this(actualQty: actualQty);

  @override
  InventoryItem difference(String difference) => this(difference: difference);

  @override
  InventoryItem comment(String? comment) => this(comment: comment);

  @override
  InventoryItem product(InventoryProduct product) => this(product: product);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InventoryItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InventoryItem(...).copyWith(id: 12, name: "My name")
  /// ````
  InventoryItem call({
    Object? id = const $CopyWithPlaceholder(),
    Object? sessionId = const $CopyWithPlaceholder(),
    Object? productId = const $CopyWithPlaceholder(),
    Object? expectedQty = const $CopyWithPlaceholder(),
    Object? actualQty = const $CopyWithPlaceholder(),
    Object? difference = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? product = const $CopyWithPlaceholder(),
  }) {
    return InventoryItem(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      sessionId: sessionId == const $CopyWithPlaceholder()
          ? _value.sessionId
          // ignore: cast_nullable_to_non_nullable
          : sessionId as String,
      productId: productId == const $CopyWithPlaceholder()
          ? _value.productId
          // ignore: cast_nullable_to_non_nullable
          : productId as String,
      expectedQty: expectedQty == const $CopyWithPlaceholder()
          ? _value.expectedQty
          // ignore: cast_nullable_to_non_nullable
          : expectedQty as String,
      actualQty: actualQty == const $CopyWithPlaceholder()
          ? _value.actualQty
          // ignore: cast_nullable_to_non_nullable
          : actualQty as String,
      difference: difference == const $CopyWithPlaceholder()
          ? _value.difference
          // ignore: cast_nullable_to_non_nullable
          : difference as String,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      product: product == const $CopyWithPlaceholder()
          ? _value.product
          // ignore: cast_nullable_to_non_nullable
          : product as InventoryProduct,
    );
  }
}

extension $InventoryItemCopyWith on InventoryItem {
  /// Returns a callable class that can be used as follows: `instanceOfInventoryItem.copyWith(...)` or like so:`instanceOfInventoryItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InventoryItemCWProxy get copyWith => _$InventoryItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InventoryItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'sessionId',
          'productId',
          'expectedQty',
          'actualQty',
          'difference',
          'product',
        ],
      );
      final val = InventoryItem(
        id: $checkedConvert('id', (v) => v as String),
        sessionId: $checkedConvert('sessionId', (v) => v as String),
        productId: $checkedConvert('productId', (v) => v as String),
        expectedQty: $checkedConvert('expectedQty', (v) => v as String),
        actualQty: $checkedConvert('actualQty', (v) => v as String),
        difference: $checkedConvert('difference', (v) => v as String),
        comment: $checkedConvert('comment', (v) => v as String?),
        product: $checkedConvert(
          'product',
          (v) => InventoryProduct.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'productId': instance.productId,
      'expectedQty': instance.expectedQty,
      'actualQty': instance.actualQty,
      'difference': instance.difference,
      'comment': ?instance.comment,
      'product': instance.product.toJson(),
    };
