# IO.Swagger.Api.WeekApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1WeekByIdDelete**](WeekApi.md#v1weekbyiddelete) | **DELETE** /v1/Week/{id} | Deletes the entire week with the given id.
[**V1WeekByIdGet**](WeekApi.md#v1weekbyidget) | **GET** /v1/Week/{id} | Gets the schedule with the specified id.
[**V1WeekByIdPut**](WeekApi.md#v1weekbyidput) | **PUT** /v1/Week/{id} | Updates the entire information of the week with the given id.
[**V1WeekGet**](WeekApi.md#v1weekget) | **GET** /v1/Week | Gets all week schedule for the currently authenticated user.
[**V1WeekPost**](WeekApi.md#v1weekpost) | **POST** /v1/Week | Creates an entirely new week for the current user.


<a name="v1weekbyiddelete"></a>
# **V1WeekByIdDelete**
> ResponseIEnumerableWeekDTO V1WeekByIdDelete (long? id)

Deletes the entire week with the given id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1WeekByIdDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekApi();
            var id = 789;  // long? | Id of the week to delete.

            try
            {
                // Deletes the entire week with the given id.
                ResponseIEnumerableWeekDTO result = apiInstance.V1WeekByIdDelete(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekApi.V1WeekByIdDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| Id of the week to delete. | 

### Return type

[**ResponseIEnumerableWeekDTO**](ResponseIEnumerableWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1weekbyidget"></a>
# **V1WeekByIdGet**
> ResponseWeekDTO V1WeekByIdGet (long? id)

Gets the schedule with the specified id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1WeekByIdGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekApi();
            var id = 789;  // long? | The id of the week schedule to fetch.

            try
            {
                // Gets the schedule with the specified id.
                ResponseWeekDTO result = apiInstance.V1WeekByIdGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekApi.V1WeekByIdGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the week schedule to fetch. | 

### Return type

[**ResponseWeekDTO**](ResponseWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1weekbyidput"></a>
# **V1WeekByIdPut**
> ResponseWeekDTO V1WeekByIdPut (long? id, WeekDTO newWeek = null)

Updates the entire information of the week with the given id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1WeekByIdPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekApi();
            var id = 789;  // long? | If of the week to update information for.
            var newWeek = new WeekDTO(); // WeekDTO | A serialized Week with new information. (optional) 

            try
            {
                // Updates the entire information of the week with the given id.
                ResponseWeekDTO result = apiInstance.V1WeekByIdPut(id, newWeek);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekApi.V1WeekByIdPut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| If of the week to update information for. | 
 **newWeek** | [**WeekDTO**](WeekDTO.md)| A serialized Week with new information. | [optional] 

### Return type

[**ResponseWeekDTO**](ResponseWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1weekget"></a>
# **V1WeekGet**
> ResponseIEnumerableWeekDTO V1WeekGet ()

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
    public class V1WeekGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekApi();

            try
            {
                // Gets all week schedule for the currently authenticated user.
                ResponseIEnumerableWeekDTO result = apiInstance.V1WeekGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekApi.V1WeekGet: " + e.Message );
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

<a name="v1weekpost"></a>
# **V1WeekPost**
> ResponseWeekDTO V1WeekPost (WeekDTO newWeek = null)

Creates an entirely new week for the current user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1WeekPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new WeekApi();
            var newWeek = new WeekDTO(); // WeekDTO | A serialized version of the new week. (optional) 

            try
            {
                // Creates an entirely new week for the current user.
                ResponseWeekDTO result = apiInstance.V1WeekPost(newWeek);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling WeekApi.V1WeekPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **newWeek** | [**WeekDTO**](WeekDTO.md)| A serialized version of the new week. | [optional] 

### Return type

[**ResponseWeekDTO**](ResponseWeekDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

