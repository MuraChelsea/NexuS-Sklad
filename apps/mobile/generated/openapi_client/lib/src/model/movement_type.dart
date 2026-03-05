//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum MovementType {
      @JsonValue(r'INCOME')
      INCOME(r'INCOME'),
      @JsonValue(r'EXPENSE')
      EXPENSE(r'EXPENSE'),
      @JsonValue(r'ADJUSTMENT')
      ADJUSTMENT(r'ADJUSTMENT'),
      @JsonValue(r'INVENTORY_DIFF')
      INVENTORY_DIFF(r'INVENTORY_DIFF');

  const MovementType(this.value);

  final String value;

  @override
  String toString() => value;
}
