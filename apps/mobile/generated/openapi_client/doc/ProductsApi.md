# nexussklad_openapi_client.api.ProductsApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1ProductsGet**](ProductsApi.md#v1productsget) | **GET** /v1/products | List products
[**v1ProductsPost**](ProductsApi.md#v1productspost) | **POST** /v1/products | Create product
[**v1ProductsProductIdGet**](ProductsApi.md#v1productsproductidget) | **GET** /v1/products/{productId} | Get product
[**v1ProductsProductIdPatch**](ProductsApi.md#v1productsproductidpatch) | **PATCH** /v1/products/{productId} | Update product


# **v1ProductsGet**
> ProductListResponse v1ProductsGet(search, categoryId)

List products

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getProductsApi();
final String search = search_example; // String | 
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1ProductsGet(search, categoryId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->v1ProductsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional] 
 **categoryId** | **String**|  | [optional] 

### Return type

[**ProductListResponse**](ProductListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProductsPost**
> ProductResponse v1ProductsPost(createProductRequest)

Create product

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getProductsApi();
final CreateProductRequest createProductRequest = ; // CreateProductRequest | 

try {
    final response = api.v1ProductsPost(createProductRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->v1ProductsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createProductRequest** | [**CreateProductRequest**](CreateProductRequest.md)|  | 

### Return type

[**ProductResponse**](ProductResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProductsProductIdGet**
> ProductResponse v1ProductsProductIdGet(productId)

Get product

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getProductsApi();
final String productId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1ProductsProductIdGet(productId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->v1ProductsProductIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 

### Return type

[**ProductResponse**](ProductResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProductsProductIdPatch**
> ProductUpdateResponse v1ProductsProductIdPatch(productId, updateProductRequest)

Update product

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getProductsApi();
final String productId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateProductRequest updateProductRequest = ; // UpdateProductRequest | 

try {
    final response = api.v1ProductsProductIdPatch(productId, updateProductRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->v1ProductsProductIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 
 **updateProductRequest** | [**UpdateProductRequest**](UpdateProductRequest.md)|  | 

### Return type

[**ProductUpdateResponse**](ProductUpdateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

