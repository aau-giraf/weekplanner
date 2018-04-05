# IO.Swagger.Api.WeekTemplateApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1WeekTemplateByIdGet**](WeekTemplateApi.md#v1weektemplatebyidget) | **GET** /v1/WeekTemplate/{id} | Gets the week template with the specified id.
[**V1WeekTemplateGet**](WeekTemplateApi.md#v1weektemplateget) | **GET** /v1/WeekTemplate | Gets all week schedule for the currently authenticated user.


<a name="v1weektemplatebyidget"></a>
# **V1WeekTemplateByIdGet**
> ResponseWeekDTO V1WeekTemplateByIdGet (long? id)

Gets the week template with the specified id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1WeekTemplateByIdGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekTemplateApi();
            var id = 789;  // long? | The id of the week template to fetch.

            try
            {
                // Gets the week template with the specified id.
                ResponseWeekDTO result = apiInstance.V1WeekTemplateByIdGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekTemplateApi.V1WeekTemplateByIdGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the week template to fetch. | 

### Return type

[**ResponseWeekDTO**](ResponseWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1weektemplateget"></a>
# **V1WeekTemplateGet**
> ResponseIEnumerableWeekDTO V1WeekTemplateGet ()

Gets all week schedule for the currently authenticated user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1WeekTemplateGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekTemplateApi();

            try
            {
                // Gets all week schedule for the currently authenticated user.
                ResponseIEnumerableWeekDTO result = apiInstance.V1WeekTemplateGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekTemplateApi.V1WeekTemplateGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseIEnumerableWeekDTO**](ResponseIEnumerableWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

