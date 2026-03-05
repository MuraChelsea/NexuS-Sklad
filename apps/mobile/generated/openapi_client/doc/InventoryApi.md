# nexussklad_openapi_client.api.InventoryApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1InventoryInventoryIdFinishPost**](InventoryApi.md#v1inventoryinventoryidfinishpost) | **POST** /v1/inventory/{inventoryId}/finish | Finish inventory session
[**v1InventoryInventoryIdGet**](InventoryApi.md#v1inventoryinventoryidget) | **GET** /v1/inventory/{inventoryId} | Get inventory session
[**v1InventoryInventoryIdItemsItemIdPatch**](InventoryApi.md#v1inventoryinventoryiditemsitemidpatch) | **PATCH** /v1/inventory/{inventoryId}/items/{itemId} | Update inventory item
[**v1InventoryStartPost**](InventoryApi.md#v1inventorystartpost) | **POST** /v1/inventory/start | Start inventory session


# **v1InventoryInventoryIdFinishPost**
> InventoryFinishResponse v1InventoryInventoryIdFinishPost(inventoryId, finishInventoryRequest)

Finish inventory session

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getInventoryApi();
final String inventoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final FinishInventoryRequest finishInventoryRequest = ; // FinishInventoryRequest | 

try {
    final response = api.v1InventoryInventoryIdFinishPost(inventoryId, finishInventoryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->v1InventoryInventoryIdFinishPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inventoryId** | **String**|  | 
 **finishInventoryRequest** | [**FinishInventoryRequest**](FinishInventoryRequest.md)|  | 

### Return type

[**InventoryFinishResponse**](InventoryFinishResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1InventoryInventoryIdGet**
> InventoryResponse v1InventoryInventoryIdGet(inventoryId)

Get inventory session

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getInventoryApi();
final String inventoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1InventoryInventoryIdGet(inventoryId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->v1InventoryInventoryIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inventoryId** | **String**|  | 

### Return type

[**InventoryResponse**](InventoryResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1InventoryInventoryIdItemsItemIdPatch**
> InventoryItemResponse v1InventoryInventoryIdItemsItemIdPatch(inventoryId, itemId, updateInventoryItemRequest)

Update inventory item

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getInventoryApi();
final String inventoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String itemId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateInventoryItemRequest updateInventoryItemRequest = ; // UpdateInventoryItemRequest | 

try {
    final response = api.v1InventoryInventoryIdItemsItemIdPatch(inventoryId, itemId, updateInventoryItemRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->v1InventoryInventoryIdItemsItemIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inventoryId** | **String**|  | 
 **itemId** | **String**|  | 
 **updateInventoryItemRequest** | [**UpdateInventoryItemRequest**](UpdateInventoryItemRequest.md)|  | 

### Return type

[**InventoryItemResponse**](InventoryItemResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1InventoryStartPost**
> InventoryStartResponse v1InventoryStartPost(startInventoryRequest)

Start inventory session

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getInventoryApi();
final StartInventoryRequest startInventoryRequest = ; // StartInventoryRequest | 

try {
    final response = api.v1InventoryStartPost(startInventoryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling InventoryApi->v1InventoryStartPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **startInventoryRequest** | [**StartInventoryRequest**](StartInventoryRequest.md)|  | 

### Return type

[**InventoryStartResponse**](InventoryStartResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

