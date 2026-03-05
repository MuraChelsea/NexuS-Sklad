# nexussklad_openapi_client.api.AuthApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1AuthAcceptInvitePost**](AuthApi.md#v1authacceptinvitepost) | **POST** /v1/auth/accept-invite | Accept invite
[**v1AuthLoginPost**](AuthApi.md#v1authloginpost) | **POST** /v1/auth/login | Login
[**v1AuthLogoutPost**](AuthApi.md#v1authlogoutpost) | **POST** /v1/auth/logout | Logout
[**v1AuthMeGet**](AuthApi.md#v1authmeget) | **GET** /v1/auth/me | Current user
[**v1AuthRefreshPost**](AuthApi.md#v1authrefreshpost) | **POST** /v1/auth/refresh | Refresh session
[**v1AuthRegisterPost**](AuthApi.md#v1authregisterpost) | **POST** /v1/auth/register | Register company and owner


# **v1AuthAcceptInvitePost**
> AuthSessionAcceptInviteResponse v1AuthAcceptInvitePost(acceptInviteRequest)

Accept invite

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuthApi();
final AcceptInviteRequest acceptInviteRequest = ; // AcceptInviteRequest | 

try {
    final response = api.v1AuthAcceptInvitePost(acceptInviteRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->v1AuthAcceptInvitePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **acceptInviteRequest** | [**AcceptInviteRequest**](AcceptInviteRequest.md)|  | 

### Return type

[**AuthSessionAcceptInviteResponse**](AuthSessionAcceptInviteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthLoginPost**
> AuthSessionLoginResponse v1AuthLoginPost(loginRequest)

Login

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuthApi();
final LoginRequest loginRequest = ; // LoginRequest | 

try {
    final response = api.v1AuthLoginPost(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->v1AuthLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**AuthSessionLoginResponse**](AuthSessionLoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthLogoutPost**
> v1AuthLogoutPost(logoutRequest)

Logout

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuthApi();
final LogoutRequest logoutRequest = ; // LogoutRequest | 

try {
    api.v1AuthLogoutPost(logoutRequest);
} on DioException catch (e) {
    print('Exception when calling AuthApi->v1AuthLogoutPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **logoutRequest** | [**LogoutRequest**](LogoutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthMeGet**
> AuthMeResponse v1AuthMeGet()

Current user

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuthApi();

try {
    final response = api.v1AuthMeGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->v1AuthMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthMeResponse**](AuthMeResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthRefreshPost**
> AuthSessionRefreshResponse v1AuthRefreshPost(refreshRequest)

Refresh session

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuthApi();
final RefreshRequest refreshRequest = ; // RefreshRequest | 

try {
    final response = api.v1AuthRefreshPost(refreshRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->v1AuthRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | 

### Return type

[**AuthSessionRefreshResponse**](AuthSessionRefreshResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthRegisterPost**
> AuthSessionRegisterResponse v1AuthRegisterPost(registerRequest)

Register company and owner

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuthApi();
final RegisterRequest registerRequest = ; // RegisterRequest | 

try {
    final response = api.v1AuthRegisterPost(registerRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->v1AuthRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  | 

### Return type

[**AuthSessionRegisterResponse**](AuthSessionRegisterResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

