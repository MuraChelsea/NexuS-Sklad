import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'json_reader.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
  });

  final String baseUrl;

  Future<JsonMap> get(
    String path, {
    String? accessToken,
  }) async {
    final response = await _send(
      () => http.get(
        _buildUri(path),
        headers: _headers(accessToken),
      ),
    );

    return _decode(response);
  }

  Future<JsonMap> post(
    String path, {
    String? accessToken,
    JsonMap? body,
  }) async {
    final response = await _send(
      () => http.post(
        _buildUri(path),
        headers: _headers(accessToken),
        body: body == null ? null : jsonEncode(body),
      ),
    );

    return _decode(response);
  }

  Future<JsonMap> patch(
    String path, {
    String? accessToken,
    JsonMap? body,
  }) async {
    final response = await _send(
      () => http.patch(
        _buildUri(path),
        headers: _headers(accessToken),
        body: body == null ? null : jsonEncode(body),
      ),
    );

    return _decode(response);
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NetworkApiException('Нет соединения с сервером.');
    } on http.ClientException {
      throw const NetworkApiException('Не удалось связаться с сервером.');
    } on TimeoutException {
      throw const NetworkApiException('Сервер не ответил вовремя.');
    }
  }

  Uri _buildUri(String path) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath');
  }

  Map<String, String> _headers(String? accessToken) {
    return {
      'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }

  JsonMap _decode(http.Response response) {
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! JsonMap) {
      throw const ApiException('Unexpected response format');
    }

    if (response.statusCode >= 400) {
      throw parseApiError(
        decoded,
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }
}
