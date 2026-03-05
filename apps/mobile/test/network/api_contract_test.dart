import 'package:flutter_test/flutter_test.dart';

import 'package:nexussklad_mobile/core/network/api_contract.dart';
import 'package:nexussklad_mobile/core/network/api_exception.dart';

void main() {
  test('ApiContract.item decodes matching item envelope', () {
    final result = ApiContract.item<Map<String, dynamic>>(
      {
        'module': 'products',
        'item': {'id': 'p1'},
      },
      module: 'products',
      decode: (item) => item,
    );

    expect(result['id'], 'p1');
  });

  test('ApiContract.list rejects module mismatch', () {
    expect(
      () => ApiContract.list<Map<String, dynamic>>(
        {
          'module': 'inventory',
          'items': <Map<String, dynamic>>[],
        },
        module: 'products',
        decode: (item) => item,
      ),
      throwsA(
        isA<ApiContractException>()
            .having((error) => error.code, 'code', 'API_CONTRACT_ERROR')
            .having((error) => error.message, 'message', contains('products')),
      ),
    );
  });

  test('ApiContract.report rejects wrong report type', () {
    expect(
      () => ApiContract.report<Map<String, dynamic>>(
        {
          'module': 'reports',
          'report': 'stock',
          'item': <String, dynamic>{},
        },
        report: 'daily',
        decode: (item) => item,
      ),
      throwsA(
        isA<ApiContractException>()
            .having((error) => error.code, 'code', 'API_CONTRACT_ERROR')
            .having((error) => error.message, 'message', contains('daily')),
      ),
    );
  });

  test('ApiContract.authSession validates auth action', () {
    final result = ApiContract.authSession<String>(
      {
        'module': 'auth',
        'action': 'login',
        'accessToken': 'token',
      },
      action: 'login',
      decode: (json) => json['accessToken'] as String,
    );

    expect(result, 'token');
  });

  test('ApiContract.invite validates users invite action', () {
    final result = ApiContract.invite<String>(
      {
        'module': 'users',
        'action': 'invite',
        'inviteToken': 'invite-1',
      },
      decode: (json) => json['inviteToken'] as String,
    );

    expect(result, 'invite-1');
  });

  test('parseApiError maps stock conflicts to user-facing message and preserves backend message', () {
    final error = parseApiError(
      {
        'error': {
          'code': 'INSUFFICIENT_STOCK',
          'message': 'Недостаточно остатка',
        },
      },
      statusCode: 409,
    );

    expect(error.statusCode, 409);
    expect(error.code, 'INSUFFICIENT_STOCK');
    expect(error.message, 'Недостаточно остатка. Обнови данные и повтори операцию.');
    expect(error.backendMessage, 'Недостаточно остатка');
  });

  test('parseApiError maps validation error to stable user-facing message', () {
    final error = parseApiError(
      {
        'error': {
          'code': 'VALIDATION_ERROR',
          'message': 'body/name must be string',
        },
      },
      statusCode: 400,
    );

    expect(error.statusCode, 400);
    expect(error.code, 'VALIDATION_ERROR');
    expect(error.message, 'Проверь введенные данные и повтори попытку.');
    expect(error.backendMessage, 'body/name must be string');
  });

  test('parseApiError falls back on malformed payload', () {
    final error = parseApiError(
      {'message': 'bad'},
      statusCode: 500,
    );

    expect(error.statusCode, 500);
    expect(error.code, isNull);
    expect(error.message, 'Request failed');
    expect(error.backendMessage, 'Request failed');
  });

  test('isSessionExpiredApiError detects auth expiry conditions', () {
    expect(
      isSessionExpiredApiError(
        const ApiException(
          'expired',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      ),
      isTrue,
    );

    expect(
      isSessionExpiredApiError(
        const ApiException(
          'forbidden',
          statusCode: 403,
          code: 'FORBIDDEN',
        ),
      ),
      isFalse,
    );
  });

  test('isOfflineQueueableError allows only network exceptions into offline queue', () {
    expect(
      isOfflineQueueableError(
        const NetworkApiException('offline'),
      ),
      isTrue,
    );

    expect(
      isOfflineQueueableError(
        const ApiContractException('bad envelope'),
      ),
      isFalse,
    );
  });
}
