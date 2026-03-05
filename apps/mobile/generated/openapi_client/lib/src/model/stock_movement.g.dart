// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StockMovementCWProxy {
  StockMovement id(String id);

  StockMovement companyId(String companyId);

  StockMovement productId(String productId);

  StockMovement createdById(String createdById);

  StockMovement movementType(MovementType movementType);

  StockMovement quantity(String quantity);

  StockMovement beforeQty(String beforeQty);

  StockMovement afterQty(String afterQty);

  StockMovement comment(String? comment);

  StockMovement createdAt(DateTime createdAt);

  StockMovement product(MovementProduct product);

  StockMovement createdBy(MovementActor createdBy);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockMovement(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockMovement(...).copyWith(id: 12, name: "My name")
  /// ````
  StockMovement call({
    String id,
    String companyId,
    String productId,
    String createdById,
    MovementType movementType,
    String quantity,
    String beforeQty,
    String afterQty,
    String? comment,
    DateTime createdAt,
    MovementProduct product,
    MovementActor createdBy,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStockMovement.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStockMovement.copyWith.fieldName(...)`
class _$StockMovementCWProxyImpl implements _$StockMovementCWProxy {
  const _$StockMovementCWProxyImpl(this._value);

  final StockMovement _value;

  @override
  StockMovement id(String id) => this(id: id);

  @override
  StockMovement companyId(String companyId) => this(companyId: companyId);

  @override
  StockMovement productId(String productId) => this(productId: productId);

  @override
  StockMovement createdById(String createdById) =>
      this(createdById: createdById);

  @override
  StockMovement movementType(MovementType movementType) =>
      this(movementType: movementType);

  @override
  StockMovement quantity(String quantity) => this(quantity: quantity);

  @override
  StockMovement beforeQty(String beforeQty) => this(beforeQty: beforeQty);

  @override
  StockMovement afterQty(String afterQty) => this(afterQty: afterQty);

  @override
  StockMovement comment(String? comment) => this(comment: comment);

  @override
  StockMovement createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  StockMovement product(MovementProduct product) => this(product: product);

  @override
  StockMovement createdBy(MovementActor createdBy) =>
      this(createdBy: createdBy);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StockMovement(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StockMovement(...).copyWith(id: 12, name: "My name")
  /// ````
  StockMovement call({
    Object? id = const $CopyWithPlaceholder(),
    Object? companyId = const $CopyWithPlaceholder(),
    Object? productId = const $CopyWithPlaceholder(),
    Object? createdById = const $CopyWithPlaceholder(),
    Object? movementType = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? beforeQty = const $CopyWithPlaceholder(),
    Object? afterQty = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? product = const $CopyWithPlaceholder(),
    Object? createdBy = const $CopyWithPlaceholder(),
  }) {
    return StockMovement(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      companyId: companyId == const $CopyWithPlaceholder()
          ? _value.companyId
          // ignore: cast_nullable_to_non_nullable
          : companyId as String,
      productId: productId == const $CopyWithPlaceholder()
          ? _value.productId
          // ignore: cast_nullable_to_non_nullable
          : productId as String,
      createdById: createdById == const $CopyWithPlaceholder()
          ? _value.createdById
          // ignore: cast_nullable_to_non_nullable
          : createdById as String,
      movementType: movementType == const $CopyWithPlaceholder()
          ? _value.movementType
          // ignore: cast_nullable_to_non_nullable
          : movementType as MovementType,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as String,
      beforeQty: beforeQty == const $CopyWithPlaceholder()
          ? _value.beforeQty
          // ignore: cast_nullable_to_non_nullable
          : beforeQty as String,
      afterQty: afterQty == const $CopyWithPlaceholder()
          ? _value.afterQty
          // ignore: cast_nullable_to_non_nullable
          : afterQty as String,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      product: product == const $CopyWithPlaceholder()
          ? _value.product
          // ignore: cast_nullable_to_non_nullable
          : product as MovementProduct,
      createdBy: createdBy == const $CopyWithPlaceholder()
          ? _value.createdBy
          // ignore: cast_nullable_to_non_nullable
          : createdBy as MovementActor,
    );
  }
}

extension $StockMovementCopyWith on StockMovement {
  /// Returns a callable class that can be used as follows: `instanceOfStockMovement.copyWith(...)` or like so:`instanceOfStockMovement.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StockMovementCWProxy get copyWith => _$StockMovementCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StockMovement', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'companyId',
          'productId',
          'createdById',
          'movementType',
          'quantity',
          'beforeQty',
          'afterQty',
          'createdAt',
          'product',
          'createdBy',
        ],
      );
      final val = StockMovement(
        id: $checkedConvert('id', (v) => v as String),
        companyId: $checkedConvert('companyId', (v) => v as String),
        productId: $checkedConvert('productId', (v) => v as String),
        createdById: $checkedConvert('createdById', (v) => v as String),
        movementType: $checkedConvert(
          'movementType',
          (v) => $enumDecode(_$MovementTypeEnumMap, v),
        ),
        quantity: $checkedConvert('quantity', (v) => v as String),
        beforeQty: $checkedConvert('beforeQty', (v) => v as String),
        afterQty: $checkedConvert('afterQty', (v) => v as String),
        comment: $checkedConvert('comment', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        product: $checkedConvert(
          'product',
          (v) => MovementProduct.fromJson(v as Map<String, dynamic>),
        ),
        createdBy: $checkedConvert(
          'createdBy',
          (v) => MovementActor.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StockMovementToJson(StockMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'productId': instance.productId,
      'createdById': instance.createdById,
      'movementType': _$MovementTypeEnumMap[instance.movementType]!,
      'quantity': instance.quantity,
      'beforeQty': instance.beforeQty,
      'afterQty': instance.afterQty,
      'comment': ?instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'product': instance.product.toJson(),
      'createdBy': instance.createdBy.toJson(),
    };

const _$MovementTypeEnumMap = {
  MovementType.INCOME: 'INCOME',
  MovementType.EXPENSE: 'EXPENSE',
  MovementType.ADJUSTMENT: 'ADJUSTMENT',
  MovementType.INVENTORY_DIFF: 'INVENTORY_DIFF',
};
