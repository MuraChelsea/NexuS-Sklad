//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_movement_summary_item.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyMovementSummaryItem {
  /// Returns a new [DailyMovementSummaryItem] instance.
  DailyMovementSummaryItem({

    required  this.count,

    required  this.quantity,
  });

  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;



  @JsonKey(
    
    name: r'quantity',
    required: true,
    includeIfNull: false,
  )


  final String quantity;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyMovementSummaryItem &&
      other.count == count &&
      other.quantity == quantity;

    @override
    int get hashCode =>
        count.hashCode +
        quantity.hashCode;

  factory DailyMovementSummaryItem.fromJson(Map<String, dynamic> json) => _$DailyMovementSummaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMovementSummaryItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

