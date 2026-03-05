//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_inventory_session_started_by.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyInventorySessionStartedBy {
  /// Returns a new [DailyInventorySessionStartedBy] instance.
  DailyInventorySessionStartedBy({

    required  this.id,

    required  this.name,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyInventorySessionStartedBy &&
      other.id == id &&
      other.name == name;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode;

  factory DailyInventorySessionStartedBy.fromJson(Map<String, dynamic> json) => _$DailyInventorySessionStartedByFromJson(json);

  Map<String, dynamic> toJson() => _$DailyInventorySessionStartedByToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

