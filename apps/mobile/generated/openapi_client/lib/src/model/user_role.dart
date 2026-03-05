//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum UserRole {
      @JsonValue(r'OWNER')
      OWNER(r'OWNER'),
      @JsonValue(r'MANAGER')
      MANAGER(r'MANAGER'),
      @JsonValue(r'STAFF')
      STAFF(r'STAFF');

  const UserRole(this.value);

  final String value;

  @override
  String toString() => value;
}
