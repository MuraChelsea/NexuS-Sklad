# nexussklad_openapi_client.api.AuditApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1AuditGet**](AuditApi.md#v1auditget) | **GET** /v1/audit | List audit logs


# **v1AuditGet**
> AuditListResponse v1AuditGet(userId, entityType, action, limit)

List audit logs

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getAuditApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String entityType = entityType_example; // String | 
final String action = action_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1AuditGet(userId, entityType, action, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuditApi->v1AuditGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | [optional] 
 **entityType** | **String**|  | [optional] 
 **action** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] 

### Return type

[**AuditListResponse**](AuditListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

