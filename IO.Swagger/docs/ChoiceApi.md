# IO.Swagger.Api.ChoiceApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1ChoiceByIdDelete**](ChoiceApi.md#v1choicebyiddelete) | **DELETE** /v1/Choice/{id} | Delete the GirafRest.Models.Choice choice with the specified id.
[**V1ChoiceByIdGet**](ChoiceApi.md#v1choicebyidget) | **GET** /v1/Choice/{id} | Read the GirafRest.Models.Choice choice with the specified id ID and  check if the user is authorized to see it.
[**V1ChoiceByIdPut**](ChoiceApi.md#v1choicebyidput) | **PUT** /v1/Choice/{id} | Update info of a GirafRest.Models.Choice choice.
[**V1ChoicePost**](ChoiceApi.md#v1choicepost) | **POST** /v1/Choice | Create a new GirafRest.Models.Choice choice.


<a name="v1choicebyiddelete"></a>
# **V1ChoiceByIdDelete**
> Response V1ChoiceByIdDelete (long? id)

Delete the GirafRest.Models.Choice choice with the specified id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1ChoiceByIdDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new ChoiceApi();
            var id = 789;  // long? | The id of the choice to delete.

            try
            {
                // Delete the GirafRest.Models.Choice choice with the specified id.
                Response result = apiInstance.V1ChoiceByIdDelete(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling ChoiceApi.V1ChoiceByIdDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the choice to delete. | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1choicebyidget"></a>
# **V1ChoiceByIdGet**
> ResponseChoiceDTO V1ChoiceByIdGet (long? id)

Read the GirafRest.Models.Choice choice with the specified id ID and  check if the user is authorized to see it.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1ChoiceByIdGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new ChoiceApi();
            var id = 789;  // long? | 

            try
            {
                // Read the GirafRest.Models.Choice choice with the specified id ID and  check if the user is authorized to see it.
                ResponseChoiceDTO result = apiInstance.V1ChoiceByIdGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling ChoiceApi.V1ChoiceByIdGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**|  | 

### Return type

[**ResponseChoiceDTO**](ResponseChoiceDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1choicebyidput"></a>
# **V1ChoiceByIdPut**
> ResponseChoiceDTO V1ChoiceByIdPut (long? id, ChoiceDTO newValues = null)

Update info of a GirafRest.Models.Choice choice.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1ChoiceByIdPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new ChoiceApi();
            var id = 789;  // long? | 
            var newValues = new ChoiceDTO(); // ChoiceDTO | A GirafRest.Models.DTOs.ChoiceDTO with all new information to update with.             The Id found in this DTO is the target choice. (optional) 

            try
            {
                // Update info of a GirafRest.Models.Choice choice.
                ResponseChoiceDTO result = apiInstance.V1ChoiceByIdPut(id, newValues);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling ChoiceApi.V1ChoiceByIdPut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**|  | 
 **newValues** | [**ChoiceDTO**](ChoiceDTO.md)| A GirafRest.Models.DTOs.ChoiceDTO with all new information to update with.             The Id found in this DTO is the target choice. | [optional] 

### Return type

[**ResponseChoiceDTO**](ResponseChoiceDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1choicepost"></a>
# **V1ChoicePost**
> ResponseChoiceDTO V1ChoicePost (ChoiceDTO choice = null)

Create a new GirafRest.Models.Choice choice.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1ChoicePostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new ChoiceApi();
            var choice = new ChoiceDTO(); // ChoiceDTO | A GirafRest.Models.DTOs.ChoiceDTO with all relevant information about the new choice. (optional) 

            try
            {
                // Create a new GirafRest.Models.Choice choice.
                ResponseChoiceDTO result = apiInstance.V1ChoicePost(choice);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling ChoiceApi.V1ChoicePost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **choice** | [**ChoiceDTO**](ChoiceDTO.md)| A GirafRest.Models.DTOs.ChoiceDTO with all relevant information about the new choice. | [optional] 

### Return type

[**ResponseChoiceDTO**](ResponseChoiceDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

