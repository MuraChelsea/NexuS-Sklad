import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/transport_mapper.dart';
import 'auth_gateway.dart';
import 'auth_session.dart';
import 'auth_session_store.dart';

class AuthRepository implements AuthGateway {
  AuthRepository(
    this._apiClient, {
    AuthSessionStore? sessionStore,
  }) : _sessionStore = sessionStore ?? AuthSessionStore();

  final ApiClient _apiClient;
  final AuthSessionStore _sessionStore;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final json = await _apiClient.post(
      '/v1/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    return ApiContract.authSession(
      json,
      action: 'login',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.AuthSessionLoginResponse.fromJson,
        toDomain: AuthSession.fromLoginTransport,
      ),
    );
  }

  Future<AuthSession> refresh(String refreshToken) async {
    final json = await _apiClient.post(
      '/v1/auth/refresh',
      body: {
        'refreshToken': refreshToken,
      },
    );

    return ApiContract.authSession(
      json,
      action: 'refresh',
      decode: (payload) => mapTransport(
        payload,
        decodeTransport: generated.AuthSessionRefreshResponse.fromJson,
        toDomain: AuthSession.fromRefreshTransport,
      ),
    );
  }

  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      '/v1/auth/logout',
      body: {
        'refreshToken': refreshToken,
      },
    );
  }

  Future<MobileUser> me(String accessToken) async {
    final json = await _apiClient.get(
      '/v1/auth/me',
      accessToken: accessToken,
    );

    return ApiContract.authMe(
      json,
      decode: (payload) => MobileUser.fromTransport(
        generated.AuthMeResponse.fromJson(payload).user,
      ),
    );
  }

  Future<void> persistSession(AuthSession session) {
    return _sessionStore.write(session.toJson());
  }

  Future<AuthSession?> readCachedSession() async {
    final json = await _sessionStore.read();
    if (json == null) {
      return null;
    }
    return AuthSession.fromJson(json);
  }

  Future<void> clearCachedSession() {
    return _sessionStore.clear();
  }
}
