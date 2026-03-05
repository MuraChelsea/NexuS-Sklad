import 'auth_session.dart';

abstract class AuthGateway {
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  Future<AuthSession> refresh(String refreshToken);

  Future<void> logout(String refreshToken);

  Future<MobileUser> me(String accessToken);

  Future<void> persistSession(AuthSession session);

  Future<AuthSession?> readCachedSession();

  Future<void> clearCachedSession();
}
