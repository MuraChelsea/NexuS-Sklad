import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../network/json_reader.dart';

class LocalCacheStore {
  LocalCacheStore._();

  static final LocalCacheStore instance = LocalCacheStore._();

  Future<void> writeJson(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  Future<JsonMap?> readJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is JsonMap) {
        return decoded;
      }
    } catch (_) {
      await prefs.remove(key);
    }

    return null;
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
