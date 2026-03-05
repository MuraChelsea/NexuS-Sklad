//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_register_meta.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthRegisterMeta {
  /// Returns a new [AuthRegisterMeta] instance.
  AuthRegisterMeta({

    required  this.module,

    required  this.action,
  });

  @JsonKey(
    
    name: r'module',
    required: true,
    includeIfNull: true,
  )


  final Object? module;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: true,
  )


  final Object? action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuthRegisterMeta &&
      other.module == module &&
      other.action == action;

    @override
    int get hashCode =>
        (module == null ? 0 : module.hashCode) +
        (action == null ? 0 : action.hashCode);

  factory AuthRegisterMeta.fromJson(Map<String, dynamic> json) => _$AuthRegisterMetaFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRegisterMetaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

