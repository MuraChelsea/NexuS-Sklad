import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for UsersApi
void main() {
  final instance = NexusSkladOpenapiClient().getUsersApi();

  group(UsersApi, () {
    // List company users
    //
    //Future<UserListResponse> v1UsersGet() async
    test('test v1UsersGet', () async {
      // TODO
    });

    // Invite user
    //
    //Future<InviteUserResponse> v1UsersInvitePost(InviteUserRequest inviteUserRequest) async
    test('test v1UsersInvitePost', () async {
      // TODO
    });

    // Create user
    //
    //Future<UserResponse> v1UsersPost(CreateUserRequest createUserRequest) async
    test('test v1UsersPost', () async {
      // TODO
    });

    // Update user
    //
    //Future<UserUpdateResponse> v1UsersUserIdPatch(String userId, UpdateUserRequest updateUserRequest) async
    test('test v1UsersUserIdPatch', () async {
      // TODO
    });

  });
}
