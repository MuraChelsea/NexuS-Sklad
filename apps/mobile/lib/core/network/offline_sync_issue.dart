import 'api_exception.dart';

enum OfflineSyncIssueKind {
  conflict,
  auth,
  validation,
  server,
}

class OfflineSyncIssue {
  const OfflineSyncIssue({
    required this.kind,
    required this.message,
    this.code,
  });

  final OfflineSyncIssueKind kind;
  final String message;
  final String? code;

  bool get isConflict => kind == OfflineSyncIssueKind.conflict;

  factory OfflineSyncIssue.fromApiException(ApiException error) {
    final code = error.code;
    final statusCode = error.statusCode ?? 500;

    if (statusCode == 401 || statusCode == 403) {
      return const OfflineSyncIssue(
        kind: OfflineSyncIssueKind.auth,
        message: 'Синхронизация остановлена: нужно заново войти или проверить права доступа.',
      );
    }

    if (_isConflictStatus(statusCode) || _isConflictCode(code)) {
      return OfflineSyncIssue(
        kind: OfflineSyncIssueKind.conflict,
        code: code,
        message: _conflictMessage(error),
      );
    }

    if (statusCode >= 400 && statusCode < 500) {
      return OfflineSyncIssue(
        kind: OfflineSyncIssueKind.validation,
        code: code,
        message: 'Синхронизация отклонена сервером: ${error.message}',
      );
    }

    return OfflineSyncIssue(
      kind: OfflineSyncIssueKind.server,
      code: code,
      message: error.message,
    );
  }
}

bool _isConflictStatus(int statusCode) => statusCode == 404 || statusCode == 409;

bool _isConflictCode(String? code) {
  if (code == null || code.isEmpty) {
    return false;
  }

  return code == 'INSUFFICIENT_STOCK' ||
      code == 'INVENTORY_STALE_STOCK' ||
      code == 'INVENTORY_NOT_ACTIVE' ||
      code == 'OWNER_USER_PROTECTED' ||
      code.endsWith('_NOT_FOUND') ||
      code.endsWith('_TAKEN') ||
      code.endsWith('_CONFLICT');
}

String _conflictMessage(ApiException error) {
  switch (error.code) {
    case 'INSUFFICIENT_STOCK':
      return 'Конфликт синхронизации: остаток уже изменился, расход нужно проверить вручную.';
    case 'INVENTORY_STALE_STOCK':
      return 'Конфликт синхронизации: остатки изменились после старта инвентаризации.';
    case 'INVENTORY_NOT_ACTIVE':
      return 'Конфликт синхронизации: сессия инвентаризации уже закрыта или недоступна.';
    case 'OWNER_USER_PROTECTED':
      return 'Конфликт синхронизации: owner-пользователь изменяется только из отдельного контура.';
    case 'USER_EMAIL_TAKEN':
      return 'Конфликт синхронизации: email уже занят на сервере.';
    case 'PRODUCT_SKU_TAKEN':
      return 'Конфликт синхронизации: SKU уже занят на сервере.';
    case 'PRODUCT_BARCODE_TAKEN':
      return 'Конфликт синхронизации: штрихкод уже занят на сервере.';
  }

  if (error.code != null && error.code!.endsWith('_NOT_FOUND')) {
    return 'Конфликт синхронизации: запись на сервере уже удалена или изменена.';
  }

  return 'Конфликт синхронизации: ${error.message}';
}
