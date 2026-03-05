# nexussklad_openapi_client.api.CategoriesApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1CategoriesCategoryIdGet**](CategoriesApi.md#v1categoriescategoryidget) | **GET** /v1/categories/{categoryId} | Get category
[**v1CategoriesCategoryIdPatch**](CategoriesApi.md#v1categoriescategoryidpatch) | **PATCH** /v1/categories/{categoryId} | Update category
[**v1CategoriesGet**](CategoriesApi.md#v1categoriesget) | **GET** /v1/categories | List categories
[**v1CategoriesPost**](CategoriesApi.md#v1categoriespost) | **POST** /v1/categories | Create category


# **v1CategoriesCategoryIdGet**
> CategoryResponse v1CategoriesCategoryIdGet(categoryId)

Get category

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getCategoriesApi();
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1CategoriesCategoryIdGet(categoryId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CategoriesApi->v1CategoriesCategoryIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 

### Return type

[**CategoryResponse**](CategoryResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1CategoriesCategoryIdPatch**
> CategoryUpdateResponse v1CategoriesCategoryIdPatch(categoryId, updateCategoryRequest)

Update category

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getCategoriesApi();
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UpdateCategoryRequest updateCategoryRequest = ; // UpdateCategoryRequest | 

try {
    final response = api.v1CategoriesCategoryIdPatch(categoryId, updateCategoryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CategoriesApi->v1CategoriesCategoryIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 
 **updateCategoryRequest** | [**UpdateCategoryRequest**](UpdateCategoryRequest.md)|  | 

### Return type

[**CategoryUpdateResponse**](CategoryUpdateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1CategoriesGet**
> CategoryListResponse v1CategoriesGet()

List categories

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getCategoriesApi();

try {
    final response = api.v1CategoriesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CategoriesApi->v1CategoriesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CategoryListResponse**](CategoryListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1CategoriesPost**
> CategoryResponse v1CategoriesPost(createCategoryRequest)

Create category

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getCategoriesApi();
final CreateCategoryRequest createCategoryRequest = ; // CreateCategoryRequest | 

try {
    final response = api.v1CategoriesPost(createCategoryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CategoriesApi->v1CategoriesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createCategoryRequest** | [**CreateCategoryRequest**](CreateCategoryRequest.md)|  | 

### Return type

[**CategoryResponse**](CategoryResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

