# nexussklad_openapi_client.api.CompanyApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1CompanyGet**](CompanyApi.md#v1companyget) | **GET** /v1/company | Get company
[**v1CompanyPatch**](CompanyApi.md#v1companypatch) | **PATCH** /v1/company | Update company


# **v1CompanyGet**
> CompanyResponse v1CompanyGet()

Get company

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getCompanyApi();

try {
    final response = api.v1CompanyGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CompanyApi->v1CompanyGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CompanyResponse**](CompanyResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1CompanyPatch**
> CompanyUpdateResponse v1CompanyPatch(updateCompanyRequest)

Update company

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getCompanyApi();
final UpdateCompanyRequest updateCompanyRequest = ; // UpdateCompanyRequest | 

try {
    final response = api.v1CompanyPatch(updateCompanyRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CompanyApi->v1CompanyPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateCompanyRequest** | [**UpdateCompanyRequest**](UpdateCompanyRequest.md)|  | 

### Return type

[**CompanyUpdateResponse**](CompanyUpdateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

