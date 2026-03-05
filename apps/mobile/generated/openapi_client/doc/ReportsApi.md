# nexussklad_openapi_client.api.ReportsApi

## Load the API package
```dart
import 'package:nexussklad_openapi_client/api.dart';
```

All URIs are relative to *http://localhost:4000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1ReportsDailyGet**](ReportsApi.md#v1reportsdailyget) | **GET** /v1/reports/daily | Daily report
[**v1ReportsStockGet**](ReportsApi.md#v1reportsstockget) | **GET** /v1/reports/stock | Stock report


# **v1ReportsDailyGet**
> DailyReportResponse v1ReportsDailyGet(date)

Daily report

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getReportsApi();
final DateTime date = 2013-10-20; // DateTime | 

try {
    final response = api.v1ReportsDailyGet(date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportsApi->v1ReportsDailyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**|  | [optional] 

### Return type

[**DailyReportResponse**](DailyReportResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ReportsStockGet**
> StockReportResponse v1ReportsStockGet(categoryId, search, lowOnly, limit)

Stock report

### Example
```dart
import 'package:nexussklad_openapi_client/api.dart';

final api = NexusskladOpenapiClient().getReportsApi();
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String search = search_example; // String | 
final bool lowOnly = true; // bool | 
final int limit = 56; // int | 

try {
    final response = api.v1ReportsStockGet(categoryId, search, lowOnly, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportsApi->v1ReportsStockGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | [optional] 
 **search** | **String**|  | [optional] 
 **lowOnly** | **bool**|  | [optional] 
 **limit** | **int**|  | [optional] 

### Return type

[**StockReportResponse**](StockReportResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

