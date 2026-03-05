//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum InventoryStatus {
      @JsonValue(r'DRAFT')
      DRAFT(r'DRAFT'),
      @JsonValue(r'IN_PROGRESS')
      IN_PROGRESS(r'IN_PROGRESS'),
      @JsonValue(r'COMPLETED')
      COMPLETED(r'COMPLETED');

  const InventoryStatus(this.value);

  final String value;

  @override
  String toString() => value;
}
