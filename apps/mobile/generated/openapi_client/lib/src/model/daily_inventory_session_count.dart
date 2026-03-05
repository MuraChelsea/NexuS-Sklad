//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_inventory_session_count.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyInventorySessionCount {
  /// Returns a new [DailyInventorySessionCount] instance.
  DailyInventorySessionCount({

    required  this.items,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final int items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyInventorySessionCount &&
      other.items == items;

    @override
    int get hashCode =>
        items.hashCode;

  factory DailyInventorySessionCount.fromJson(Map<String, dynamic> json) => _$DailyInventorySessionCountFromJson(json);

  Map<String, dynamic> toJson() => _$DailyInventorySessionCountToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

