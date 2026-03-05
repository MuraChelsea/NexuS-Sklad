# nexussklad_openapi_client.api.UsersApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1UsersGet**](UsersApi.md#v1usersget) | **GET** /v1/users | List company users
[**v1UsersInvitePost**](UsersApi.md#v1usersinvitepost) | **POST** /v1/users/invite | Invite user
[**v1UsersPost**](UsersApi.md#v1userspost) | **POST** /v1/users | Create user
[**v1UsersUserIdPatch**](UsersApi.md#v1usersuseridpatch) | **PATCH** /v1/users/{userId} | Update user


# **v1UsersGet**
> UserListResponse v1UsersGet()

List company users

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getUsersApi();

try {
    final response = api.v1UsersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserListResponse**](UserListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersInvitePost**
> InviteUserResponse v1UsersInvitePost(inviteUserRequest)

Invite user

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getUsersApi();
final InviteUserRequest inviteUserRequest = ; // InviteUserRequest | 

try {
    final response = api.v1UsersInvitePost(inviteUserRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersInvitePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inviteUserRequest** | [**InviteUserRequest**](InviteUserRequest.md)|  | 

### Return type

[**InviteUserResponse**](InviteUserResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersPost**
> UserResponse v1UsersPost(createUserRequest)

Create user

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getUsersApi();
final CreateUserRequest createUserRequest = ; // CreateUserRequest | 

try {
    final response = api.v1UsersPost(createUserRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUserRequest** | [**CreateUserRequest**](CreateUserRequest.md)|  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersUserIdPatch**
> UserUpdateResponse v1UsersUserIdPatch(userId, updateUserRequest)

Update user

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getUsersApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateUserRequest updateUserRequest = ; // UpdateUserRequest | 

try {
    final response = api.v1UsersUserIdPatch(userId, updateUserRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersUserIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **updateUserRequest** | [**UpdateUserRequest**](UpdateUserRequest.md)|  | 

### Return type

[**UserUpdateResponse**](UserUpdateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

