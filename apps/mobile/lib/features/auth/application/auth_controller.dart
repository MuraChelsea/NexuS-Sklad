import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_gateway.dart';
import '../data/auth_session.dart';

enum AuthStatus {
  signedOut,
  loading,
  signedIn,
}

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  AuthController.seeded(
    this._repository, {
    required AuthSession session,
  })  : _session = session,
        _status = AuthStatus.signedIn;

  final AuthGateway _repository;

  AuthStatus _status = AuthStatus.signedOut;
  AuthSession? _session;
  String? _errorMessage;
  String? _noticeMessage;

  AuthStatus get status => _status;
  AuthSession? get session => _session;
  String? get errorMessage => _errorMessage;
  String? get noticeMessage => _noticeMessage;
  MobileUser? get currentUser => _session?.user;

  bool isSessionExpiredError(ApiException error) => isSessionExpiredApiError(error);

  Future<bool> tryRefreshSession() async {
    final currentSession = _session;
    if (currentSession == null) {
      return false;
    }

    try {
      final refreshed = await _repository.refresh(currentSession.refreshToken);
      final me = await _repository.me(refreshed.accessToken);
      _session = refreshed.copyWith(user: me);
      _status = AuthStatus.signedIn;
      _errorMessage = null;
      _noticeMessage = 'Сессия восстановлена. Продолжаем работу.';
      await _repository.persistSession(_session!);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> bootstrap() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _noticeMessage = null;
    notifyListeners();

    final cachedSession = await _repository.readCachedSession();
    if (cachedSession == null) {
      _status = AuthStatus.signedOut;
      notifyListeners();
      return;
    }

    _session = cachedSession;
    _status = AuthStatus.signedIn;
    notifyListeners();

    await _refreshSessionProfile(cachedSession);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _noticeMessage = null;
    notifyListeners();

    try {
      final session = await _repository.login(email: email, password: password);
      final me = await _repository.me(session.accessToken);
      _session = session.copyWith(user: me);
      await _repository.persistSession(_session!);
      _status = AuthStatus.signedIn;
      _noticeMessage = null;
    } on ApiException catch (error) {
      _status = AuthStatus.signedOut;
      _errorMessage = error.message;
    } catch (_) {
      _status = AuthStatus.signedOut;
      _errorMessage = 'Не удалось выполнить вход';
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final currentSession = _session;
    _session = null;
    _status = AuthStatus.signedOut;
    _errorMessage = null;
    _noticeMessage = null;
    notifyListeners();
    await _repository.clearCachedSession();

    if (currentSession == null) {
      return;
    }

    try {
      await _repository.logout(currentSession.refreshToken);
    } catch (_) {
      // Silent logout in local shell.
    }
  }

  Future<void> updateCompanyNameLocally(String companyName) async {
    final currentSession = _session;
    if (currentSession == null) {
      return;
    }

    final user = currentSession.user;
    _session = currentSession.copyWith(
      user: MobileUser(
        id: user.id,
        companyId: user.companyId,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        companyName: companyName,
      ),
    );
    await _repository.persistSession(_session!);
    notifyListeners();
  }

  Future<void> refreshCurrentUser() async {
    final currentSession = _session;
    if (currentSession == null) {
      return;
    }

    await _refreshSessionProfile(currentSession);
  }

  Future<void> _refreshSessionProfile(AuthSession baseSession) async {
    try {
      final me = await _repository.me(baseSession.accessToken);
      _session = baseSession.copyWith(user: me);
      await _repository.persistSession(_session!);
      notifyListeners();
    } on ApiException catch (error) {
      if (error.statusCode != 401) {
        return;
      }

      try {
        final refreshed = await _repository.refresh(baseSession.refreshToken);
        final me = await _repository.me(refreshed.accessToken);
        _session = refreshed.copyWith(user: me);
        await _repository.persistSession(_session!);
        _status = AuthStatus.signedIn;
        _errorMessage = null;
        _noticeMessage = 'Сессия восстановлена. Продолжаем работу.';
        notifyListeners();
      } catch (_) {
        await expireSession(
          const ApiException(
            'Сессия истекла. Войди снова.',
            statusCode: 401,
            code: 'AUTH_REFRESH_REVOKED',
          ),
        );
      }
    } catch (_) {
      // Keep cached session if API is unreachable.
    }
  }

  Future<bool> expireSession(ApiException error) async {
    if (!isSessionExpiredError(error)) {
      return false;
    }

    _session = null;
    _status = AuthStatus.signedOut;
    _errorMessage = error.message;
    _noticeMessage = 'Сессия завершена. Войди снова.';
    await _repository.clearCachedSession();
    notifyListeners();
    return true;
  }

  Future<bool> recoverSession(ApiException error) async {
    if (!isSessionExpiredError(error)) {
      return false;
    }

    if (await tryRefreshSession()) {
      return true;
    }

    await expireSession(error);
    return false;
  }

  void clearNotice() {
    if (_noticeMessage == null) {
      return;
    }
    _noticeMessage = null;
    notifyListeners();
  }
}
