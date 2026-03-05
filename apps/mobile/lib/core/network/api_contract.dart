import 'api_exception.dart';
import 'json_reader.dart';

final class ApiContract {
  const ApiContract._();

  static T item<T>(
    JsonMap json, {
    required String module,
    String? action,
    required T Function(JsonMap item) decode,
  }) {
    _expectModule(json, module);
    _expectOptionalConstant(json, 'action', action);
    return decode(JsonReader.object(json, 'item'));
  }

  static List<T> list<T>(
    JsonMap json, {
    required String module,
    required T Function(JsonMap item) decode,
  }) {
    _expectModule(json, module);
    return JsonReader.objectList(json, 'items').map(decode).toList(growable: false);
  }

  static T report<T>(
    JsonMap json, {
    required String report,
    required T Function(JsonMap item) decode,
  }) {
    _expectModule(json, 'reports');
    _expectConstant(json, 'report', report);
    return decode(JsonReader.object(json, 'item'));
  }

  static T authSession<T>(
    JsonMap json, {
    required String action,
    required T Function(JsonMap json) decode,
  }) {
    _expectModule(json, 'auth');
    _expectConstant(json, 'action', action);
    return decode(json);
  }

  static T authMe<T>(
    JsonMap json, {
    required T Function(JsonMap user) decode,
  }) {
    _expectModule(json, 'auth');
    _expectConstant(json, 'action', 'me');
    return decode(JsonReader.object(json, 'user'));
  }

  static T invite<T>(
    JsonMap json, {
    required T Function(JsonMap json) decode,
  }) {
    _expectModule(json, 'users');
    _expectConstant(json, 'action', 'invite');
    return decode(json);
  }

  static void _expectModule(JsonMap json, String expected) {
    _expectConstant(json, 'module', expected);
  }

  static void _expectOptionalConstant(JsonMap json, String key, String? expected) {
    if (expected == null) {
      return;
    }
    _expectConstant(json, key, expected);
  }

  static void _expectConstant(JsonMap json, String key, String expected) {
    final value = json[key];
    if (value != expected) {
      throw ApiContractException('Unexpected "$key": expected "$expected"');
    }
  }
}
