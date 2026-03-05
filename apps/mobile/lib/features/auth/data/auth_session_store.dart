import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/json_reader.dart';

class AuthSessionStore {
  AuthSessionStore({
    FlutterSecureStorage? storage,
  }) : _storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
           );

  static const _sessionKey = 'auth.session.secure';

  final FlutterSecureStorage _storage;

  Future<void> write(JsonMap value) {
    return _storage.write(
      key: _sessionKey,
      value: jsonEncode(value),
    );
  }

  Future<JsonMap?> read() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is JsonMap) {
        return decoded;
      }
    } catch (_) {
      await clear();
    }

    return null;
  }

  Future<void> clear() {
    return _storage.delete(key: _sessionKey);
  }
}
