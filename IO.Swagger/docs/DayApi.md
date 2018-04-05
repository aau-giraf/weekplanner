# IO.Swagger.Api.DayApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1DayByIdPut**](DayApi.md#v1daybyidput) | **PUT** /v1/Day/{id} | Updates a specified day of the week with the given id.


<a name="v1daybyidput"></a>
# **V1DayByIdPut**
> ResponseWeekDTO V1DayByIdPut (long? id, WeekdayDTO newDay = null)

Updates a specified day of the week with the given id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DayByIdPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DayApi();
            var id = 789;  // long? | The id of the week to update a day for.
            var newDay = new WeekdayDTO(); // WeekdayDTO | A serialized version of the day to update. (optional) 

            try
            {
                // Updates a specified day of the week with the given id.
                ResponseWeekDTO result = apiInstance.V1DayByIdPut(id, newDay);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DayApi.V1DayByIdPut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the week to update a day for. | 
 **newDay** | [**WeekdayDTO**](WeekdayDTO.md)| A serialized version of the day to update. | [optional] 

### Return type

[**ResponseWeekDTO**](ResponseWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

