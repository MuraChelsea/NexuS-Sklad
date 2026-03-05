# nexussklad_openapi_client.api.MovementsApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1MovementsAdjustmentPost**](MovementsApi.md#v1movementsadjustmentpost) | **POST** /v1/movements/adjustment | Create adjustment movement
[**v1MovementsExpensePost**](MovementsApi.md#v1movementsexpensepost) | **POST** /v1/movements/expense | Create expense movement
[**v1MovementsGet**](MovementsApi.md#v1movementsget) | **GET** /v1/movements | List movements
[**v1MovementsIncomePost**](MovementsApi.md#v1movementsincomepost) | **POST** /v1/movements/income | Create income movement


# **v1MovementsAdjustmentPost**
> MovementAdjustmentResponse v1MovementsAdjustmentPost(createAdjustmentRequest)

Create adjustment movement

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getMovementsApi();
final CreateAdjustmentRequest createAdjustmentRequest = ; // CreateAdjustmentRequest | 

try {
    final response = api.v1MovementsAdjustmentPost(createAdjustmentRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MovementsApi->v1MovementsAdjustmentPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAdjustmentRequest** | [**CreateAdjustmentRequest**](CreateAdjustmentRequest.md)|  | 

### Return type

[**MovementAdjustmentResponse**](MovementAdjustmentResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MovementsExpensePost**
> MovementExpenseResponse v1MovementsExpensePost(createMovementRequest)

Create expense movement

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getMovementsApi();
final CreateMovementRequest createMovementRequest = ; // CreateMovementRequest | 

try {
    final response = api.v1MovementsExpensePost(createMovementRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MovementsApi->v1MovementsExpensePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createMovementRequest** | [**CreateMovementRequest**](CreateMovementRequest.md)|  | 

### Return type

[**MovementExpenseResponse**](MovementExpenseResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MovementsGet**
> MovementListResponse v1MovementsGet(productId, movementType, limit)

List movements

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getMovementsApi();
final String productId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final MovementType movementType = ; // MovementType | 
final int limit = 56; // int | 

try {
    final response = api.v1MovementsGet(productId, movementType, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MovementsApi->v1MovementsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | [optional] 
 **movementType** | [**MovementType**](.md)|  | [optional] 
 **limit** | **int**|  | [optional] 

### Return type

[**MovementListResponse**](MovementListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MovementsIncomePost**
> MovementIncomeResponse v1MovementsIncomePost(createMovementRequest)

Create income movement

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getMovementsApi();
final CreateMovementRequest createMovementRequest = ; // CreateMovementRequest | 

try {
    final response = api.v1MovementsIncomePost(createMovementRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MovementsApi->v1MovementsIncomePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createMovementRequest** | [**CreateMovementRequest**](CreateMovementRequest.md)|  | 

### Return type

[**MovementIncomeResponse**](MovementIncomeResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

