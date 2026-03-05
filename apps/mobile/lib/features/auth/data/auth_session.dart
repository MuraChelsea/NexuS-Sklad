import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/json_reader.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final MobileUser user;

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    MobileUser? user,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  factory AuthSession.fromLoginTransport(generated.AuthSessionLoginResponse transport) {
    return AuthSession(
      accessToken: transport.accessToken,
      refreshToken: transport.refreshToken,
      user: MobileUser.fromTransport(transport.user),
    );
  }

  factory AuthSession.fromRefreshTransport(generated.AuthSessionRefreshResponse transport) {
    return AuthSession(
      accessToken: transport.accessToken,
      refreshToken: transport.refreshToken,
      user: MobileUser.fromTransport(transport.user),
    );
  }

  JsonMap toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  factory AuthSession.fromJson(JsonMap json) {
    return AuthSession(
      accessToken: JsonReader.string(json, 'accessToken'),
      refreshToken: JsonReader.string(json, 'refreshToken'),
      user: MobileUser.fromJson(JsonReader.object(json, 'user')),
    );
  }
}

class MobileUser {
  const MobileUser({
    required this.id,
    required this.companyId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.companyName,
  });

  final String id;
  final String companyId;
  final String name;
  final String? email;
  final String? phone;
  final String role;
  final String companyName;

  factory MobileUser.fromTransport(generated.AuthUser transport) {
    return MobileUser(
      id: transport.id,
      companyId: transport.companyId,
      name: transport.name,
      email: transport.email,
      phone: transport.phone,
      role: transport.role.value,
      companyName: transport.company.name,
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'companyName': companyName,
    };
  }

  factory MobileUser.fromJson(JsonMap json) {
    return MobileUser(
      id: JsonReader.string(json, 'id'),
      companyId: JsonReader.string(json, 'companyId'),
      name: JsonReader.string(json, 'name'),
      email: JsonReader.nullableString(json, 'email'),
      phone: JsonReader.nullableString(json, 'phone'),
      role: JsonReader.string(json, 'role'),
      companyName: JsonReader.string(json, 'companyName'),
    );
  }
}
