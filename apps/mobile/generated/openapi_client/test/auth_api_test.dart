import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for AuthApi
void main() {
  final instance = NexusSkladOpenapiClient().getAuthApi();

  group(AuthApi, () {
    // Accept invite
    //
    //Future<AuthSessionAcceptInviteResponse> v1AuthAcceptInvitePost(AcceptInviteRequest acceptInviteRequest) async
    test('test v1AuthAcceptInvitePost', () async {
      // TODO
    });

    // Login
    //
    //Future<AuthSessionLoginResponse> v1AuthLoginPost(LoginRequest loginRequest) async
    test('test v1AuthLoginPost', () async {
      // TODO
    });

    // Logout
    //
    //Future v1AuthLogoutPost(LogoutRequest logoutRequest) async
    test('test v1AuthLogoutPost', () async {
      // TODO
    });

    // Current user
    //
    //Future<AuthMeResponse> v1AuthMeGet() async
    test('test v1AuthMeGet', () async {
      // TODO
    });

    // Refresh session
    //
    //Future<AuthSessionRefreshResponse> v1AuthRefreshPost(RefreshRequest refreshRequest) async
    test('test v1AuthRefreshPost', () async {
      // TODO
    });

    // Register company and owner
    //
    //Future<AuthSessionRegisterResponse> v1AuthRegisterPost(RegisterRequest registerRequest) async
    test('test v1AuthRegisterPost', () async {
      // TODO
    });

  });
}
