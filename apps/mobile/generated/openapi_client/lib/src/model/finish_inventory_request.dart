//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'finish_inventory_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FinishInventoryRequest {
  /// Returns a new [FinishInventoryRequest] instance.
  FinishInventoryRequest({

     this.comment,
  });

  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FinishInventoryRequest &&
      other.comment == comment;

    @override
    int get hashCode =>
        (comment == null ? 0 : comment.hashCode);

  factory FinishInventoryRequest.fromJson(Map<String, dynamic> json) => _$FinishInventoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FinishInventoryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

