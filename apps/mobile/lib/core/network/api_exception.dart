class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.code,
    this.backendMessage,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final String? backendMessage;

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, code: $code, message: $message)';
  }
}

class ApiContractException extends ApiException {
  const ApiContractException(String message)
      : super(
          message,
          code: 'API_CONTRACT_ERROR',
        );
}

class NetworkApiException extends ApiException {
  const NetworkApiException(String message)
      : super(
          message,
          code: 'NETWORK_ERROR',
        );
}

bool isOfflineQueueableError(Object error) => error is NetworkApiException;

bool isSessionExpiredApiError(ApiException error) {
  return error.statusCode == 401 ||
      const {
        'AUTH_REQUIRED',
        'AUTH_TOKEN_INVALID',
        'AUTH_TOKEN_TYPE_INVALID',
        'AUTH_TOKEN_EXPIRED',
        'AUTH_USER_NOT_FOUND',
        'AUTH_REFRESH_REVOKED',
      }.contains(error.code);
}

ApiException parseApiError(
  Map<String, dynamic> json, {
  int? statusCode,
}) {
  final error = json['error'];
  if (error is Map<String, dynamic>) {
    final code = error['code'] as String?;
    final backendMessage = error['message'] as String? ?? 'Request failed';
    return ApiException(
      mapApiErrorMessage(
        statusCode: statusCode,
        code: code,
        backendMessage: backendMessage,
      ),
      statusCode: statusCode,
      code: code,
      backendMessage: backendMessage,
    );
  }

  return ApiException(
    mapApiErrorMessage(
      statusCode: statusCode,
      backendMessage: 'Request failed',
    ),
    statusCode: statusCode,
    backendMessage: 'Request failed',
  );
}

String mapApiErrorMessage({
  int? statusCode,
  String? code,
  String? backendMessage,
}) {
  switch (code) {
    case 'VALIDATION_ERROR':
      return 'Проверь введенные данные и повтори попытку.';
    case 'FORBIDDEN':
      return 'Недостаточно прав для этого действия.';
    case 'AUTH_REQUIRED':
    case 'AUTH_TOKEN_INVALID':
    case 'AUTH_TOKEN_TYPE_INVALID':
    case 'AUTH_TOKEN_EXPIRED':
    case 'AUTH_USER_NOT_FOUND':
    case 'AUTH_REFRESH_REVOKED':
      return 'Сессия истекла. Войди снова.';
    case 'AUTH_INVALID_CREDENTIALS':
      return 'Неверный email или пароль.';
    case 'INSUFFICIENT_STOCK':
      return 'Недостаточно остатка. Обнови данные и повтори операцию.';
    case 'INVENTORY_STALE_STOCK':
      return 'Остатки изменились после старта инвентаризации. Обнови сессию.';
    case 'INVENTORY_NOT_ACTIVE':
      return 'Сессия инвентаризации уже закрыта. Открой актуальную сессию.';
    case 'NOT_FOUND':
      return 'Запись не найдена. Возможно, она уже удалена.';
  }

  if (statusCode == 403) {
    return 'Недостаточно прав для этого действия.';
  }

  if (statusCode == 401) {
    return 'Сессия истекла. Войди снова.';
  }

  if (statusCode == 404) {
    return 'Запись не найдена. Возможно, она уже удалена.';
  }

  if (statusCode == 409) {
    return 'Данные на сервере уже изменились. Обнови экран и повтори попытку.';
  }

  return backendMessage ?? 'Request failed';
}
