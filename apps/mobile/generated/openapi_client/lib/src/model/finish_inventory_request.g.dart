// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finish_inventory_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FinishInventoryRequestCWProxy {
  FinishInventoryRequest comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FinishInventoryRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FinishInventoryRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  FinishInventoryRequest call({String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFinishInventoryRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFinishInventoryRequest.copyWith.fieldName(...)`
class _$FinishInventoryRequestCWProxyImpl
    implements _$FinishInventoryRequestCWProxy {
  const _$FinishInventoryRequestCWProxyImpl(this._value);

  final FinishInventoryRequest _value;

  @override
  FinishInventoryRequest comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FinishInventoryRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FinishInventoryRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  FinishInventoryRequest call({
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return FinishInventoryRequest(
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $FinishInventoryRequestCopyWith on FinishInventoryRequest {
  /// Returns a callable class that can be used as follows: `instanceOfFinishInventoryRequest.copyWith(...)` or like so:`instanceOfFinishInventoryRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FinishInventoryRequestCWProxy get copyWith =>
      _$FinishInventoryRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishInventoryRequest _$FinishInventoryRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('FinishInventoryRequest', json, ($checkedConvert) {
  final val = FinishInventoryRequest(
    comment: $checkedConvert('comment', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$FinishInventoryRequestToJson(
  FinishInventoryRequest instance,
) => <String, dynamic>{'comment': ?instance.comment};
