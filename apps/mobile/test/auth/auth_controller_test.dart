import 'package:flutter_test/flutter_test.dart';
import 'package:nexussklad_mobile/core/network/api_exception.dart';
import 'package:nexussklad_mobile/features/auth/application/auth_controller.dart';
import 'package:nexussklad_mobile/features/auth/data/auth_gateway.dart';
import 'package:nexussklad_mobile/features/auth/data/auth_session.dart';

void main() {
  test('tryRefreshSession restores session and sets notice', () async {
    final repository = _FakeAuthRepository(
      refreshResult: _demoSession(
        accessToken: 'next-access',
        refreshToken: 'next-refresh',
      ),
      meResult: _demoUser(name: 'Recovered User'),
    );
    final controller = AuthController.seeded(
      repository,
      session: _demoSession(),
    );

    final refreshed = await controller.tryRefreshSession();

    expect(refreshed, isTrue);
    expect(controller.status, AuthStatus.signedIn);
    expect(controller.session?.accessToken, 'next-access');
    expect(controller.session?.refreshToken, 'next-refresh');
    expect(controller.currentUser?.name, 'Recovered User');
    expect(controller.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
    expect(controller.errorMessage, isNull);
    expect(repository.persistedSessions, hasLength(1));
  });

  test('recoverSession expires session when refresh fails', () async {
    final repository = _FakeAuthRepository(
      refreshError: const ApiException(
        'Сессия истекла. Войди снова.',
        statusCode: 401,
        code: 'AUTH_REFRESH_REVOKED',
      ),
    );
    final controller = AuthController.seeded(
      repository,
      session: _demoSession(),
    );

    final recovered = await controller.recoverSession(
      const ApiException(
        'Сессия истекла. Войди снова.',
        statusCode: 401,
        code: 'AUTH_TOKEN_EXPIRED',
      ),
    );

    expect(recovered, isFalse);
    expect(controller.status, AuthStatus.signedOut);
    expect(controller.session, isNull);
    expect(controller.errorMessage, 'Сессия истекла. Войди снова.');
    expect(controller.noticeMessage, 'Сессия завершена. Войди снова.');
    expect(repository.clearCachedSessionCalls, 1);
  });

  test('expireSession ignores non-auth errors', () async {
    final repository = _FakeAuthRepository();
    final controller = AuthController.seeded(
      repository,
      session: _demoSession(),
    );

    final expired = await controller.expireSession(
      const ApiException(
        'Недостаточно прав для этого действия.',
        statusCode: 403,
        code: 'FORBIDDEN',
      ),
    );

    expect(expired, isFalse);
    expect(controller.status, AuthStatus.signedIn);
    expect(controller.session, isNotNull);
    expect(repository.clearCachedSessionCalls, 0);
  });
}

class _FakeAuthRepository implements AuthGateway {
  _FakeAuthRepository({
    this.refreshResult,
    this.refreshError,
    this.meResult,
  });

  final AuthSession? refreshResult;
  final ApiException? refreshError;
  final MobileUser? meResult;

  final List<AuthSession> persistedSessions = <AuthSession>[];
  int clearCachedSessionCalls = 0;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    if (refreshError != null) {
      throw refreshError!;
    }
    return refreshResult ?? _demoSession();
  }

  @override
  Future<MobileUser> me(String accessToken) async {
    return meResult ?? _demoUser();
  }

  @override
  Future<void> persistSession(AuthSession session) async {
    persistedSessions.add(session);
  }

  @override
  Future<void> clearCachedSession() async {
    clearCachedSessionCalls += 1;
  }

  @override
  Future<AuthSession?> readCachedSession() async => null;

  @override
  Future<void> logout(String refreshToken) async {}
}

AuthSession _demoSession({
  String accessToken = 'demo-access',
  String refreshToken = 'demo-refresh',
  MobileUser? user,
}) {
  return AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user ?? _demoUser(),
  );
}

MobileUser _demoUser({
  String name = 'Owner',
}) {
  return MobileUser(
    id: 'user-1',
    companyId: 'company-1',
    name: name,
    email: 'owner@nexussklad.local',
    phone: '+7 900 000-00-00',
    role: 'OWNER',
    companyName: 'NexusSklad Demo Company',
  );
}
