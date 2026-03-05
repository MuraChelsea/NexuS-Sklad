import 'api_exception.dart';

typedef JsonMap = Map<String, dynamic>;

final class JsonReader {
  const JsonReader._();

  static String string(JsonMap json, String key) {
    final value = json[key];
    if (value is String) {
      return value;
    }

    throw ApiException('Expected string at "$key"');
  }

  static String? nullableString(JsonMap json, String key) {
    final value = json[key];
    if (value == null || value is String) {
      return value;
    }

    throw ApiException('Expected nullable string at "$key"');
  }

  static bool boolean(JsonMap json, String key, {bool defaultValue = false}) {
    final value = json[key];
    if (value == null) {
      return defaultValue;
    }
    if (value is bool) {
      return value;
    }

    throw ApiException('Expected bool at "$key"');
  }

  static int integer(JsonMap json, String key, {int defaultValue = 0}) {
    final value = json[key];
    if (value == null) {
      return defaultValue;
    }
    if (value is int) {
      return value;
    }

    throw ApiException('Expected int at "$key"');
  }

  static String decimalString(JsonMap json, String key, {String defaultValue = '0'}) {
    final value = json[key];
    if (value == null) {
      return defaultValue;
    }
    if (value is num || value is String) {
      return value.toString();
    }

    throw ApiException('Expected numeric value at "$key"');
  }

  static DateTime dateTime(JsonMap json, String key) {
    return DateTime.parse(string(json, key));
  }

  static JsonMap object(JsonMap json, String key) {
    final value = json[key];
    if (value is JsonMap) {
      return value;
    }

    throw ApiException('Expected object at "$key"');
  }

  static JsonMap? nullableObject(JsonMap json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is JsonMap) {
      return value;
    }

    throw ApiException('Expected nullable object at "$key"');
  }

  static List<JsonMap> objectList(JsonMap json, String key) {
    final value = json[key];
    if (value == null) {
      return const <JsonMap>[];
    }
    if (value is! List) {
      throw ApiException('Expected list at "$key"');
    }

    return value.map((entry) {
      if (entry is JsonMap) {
        return entry;
      }
      throw ApiException('Expected object list entry at "$key"');
    }).toList(growable: false);
  }
}
