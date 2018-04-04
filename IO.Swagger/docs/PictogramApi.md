# IO.Swagger.Api.PictogramApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1PictogramByIdDelete**](PictogramApi.md#v1pictogrambyiddelete) | **DELETE** /v1/Pictogram/{id} | Delete the GirafRest.Models.Pictogram pictogram with the specified id.
[**V1PictogramByIdGet**](PictogramApi.md#v1pictogrambyidget) | **GET** /v1/Pictogram/{id} | Read the GirafRest.Models.Pictogram pictogram with the specified id id and  check if the user is authorized to see it.
[**V1PictogramByIdImageGet**](PictogramApi.md#v1pictogrambyidimageget) | **GET** /v1/Pictogram/{id}/image | Read the image of a given pictogram as raw.
[**V1PictogramByIdImagePut**](PictogramApi.md#v1pictogrambyidimageput) | **PUT** /v1/Pictogram/{id}/image | Update the image of a GirafRest.Models.Pictogram pictogram with the given Id.
[**V1PictogramByIdImageRawGet**](PictogramApi.md#v1pictogrambyidimagerawget) | **GET** /v1/Pictogram/{id}/image/raw | Reads the raw pictogram image.  You are allowed to read all public pictograms aswell as your own pictograms   or any pictograms shared within the department
[**V1PictogramByIdPut**](PictogramApi.md#v1pictogrambyidput) | **PUT** /v1/Pictogram/{id} | Update info of a GirafRest.Models.Pictogram pictogram.
[**V1PictogramGet**](PictogramApi.md#v1pictogramget) | **GET** /v1/Pictogram | Get all public GirafRest.Models.Pictogram pictograms available to the user  (i.e the public pictograms and those owned by the user (PRIVATE) and his department (PROTECTED)).
[**V1PictogramPost**](PictogramApi.md#v1pictogrampost) | **POST** /v1/Pictogram | Create a new GirafRest.Models.Pictogram pictogram.


<a name="v1pictogrambyiddelete"></a>
# **V1PictogramByIdDelete**
> Response V1PictogramByIdDelete (int? id)

Delete the GirafRest.Models.Pictogram pictogram with the specified id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramByIdDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var id = 56;  // int? | The id of the pictogram to delete.

            try
            {
                // Delete the GirafRest.Models.Pictogram pictogram with the specified id.
                Response result = apiInstance.V1PictogramByIdDelete(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramByIdDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int?**| The id of the pictogram to delete. | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogrambyidget"></a>
# **V1PictogramByIdGet**
> ResponsePictogramDTO V1PictogramByIdGet (long? id)

Read the GirafRest.Models.Pictogram pictogram with the specified id id and  check if the user is authorized to see it.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramByIdGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var id = 789;  // long? | The id of the pictogram to fetch.

            try
            {
                // Read the GirafRest.Models.Pictogram pictogram with the specified id id and  check if the user is authorized to see it.
                ResponsePictogramDTO result = apiInstance.V1PictogramByIdGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramByIdGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the pictogram to fetch. | 

### Return type

[**ResponsePictogramDTO**](ResponsePictogramDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogrambyidimageget"></a>
# **V1PictogramByIdImageGet**
> ResponseByte V1PictogramByIdImageGet (long? id)

Read the image of a given pictogram as raw.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramByIdImageGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var id = 789;  // long? | The id of the pictogram to read the image of.

            try
            {
                // Read the image of a given pictogram as raw.
                ResponseByte result = apiInstance.V1PictogramByIdImageGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramByIdImageGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the pictogram to read the image of. | 

### Return type

[**ResponseByte**](ResponseByte.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogrambyidimageput"></a>
# **V1PictogramByIdImagePut**
> ResponsePictogramDTO V1PictogramByIdImagePut (long? id)

Update the image of a GirafRest.Models.Pictogram pictogram with the given Id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramByIdImagePutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var id = 789;  // long? | Id of the pictogram to update the image for.

            try
            {
                // Update the image of a GirafRest.Models.Pictogram pictogram with the given Id.
                ResponsePictogramDTO result = apiInstance.V1PictogramByIdImagePut(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramByIdImagePut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| Id of the pictogram to update the image for. | 

### Return type

[**ResponsePictogramDTO**](ResponsePictogramDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogrambyidimagerawget"></a>
# **V1PictogramByIdImageRawGet**
> void V1PictogramByIdImageRawGet (long? id)

Reads the raw pictogram image.  You are allowed to read all public pictograms aswell as your own pictograms   or any pictograms shared within the department

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramByIdImageRawGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var id = 789;  // long? | Identifier.

            try
            {
                // Reads the raw pictogram image.  You are allowed to read all public pictograms aswell as your own pictograms   or any pictograms shared within the department
                apiInstance.V1PictogramByIdImageRawGet(id);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramByIdImageRawGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| Identifier. | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogrambyidput"></a>
# **V1PictogramByIdPut**
> ResponsePictogramDTO V1PictogramByIdPut (long? id, PictogramDTO pictogram = null)

Update info of a GirafRest.Models.Pictogram pictogram.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramByIdPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var id = 789;  // long? | 
            var pictogram = new PictogramDTO(); // PictogramDTO | A GirafRest.Models.DTOs.PictogramDTO with all new information to update with.              The Id found in this DTO is the target pictogram. (optional) 

            try
            {
                // Update info of a GirafRest.Models.Pictogram pictogram.
                ResponsePictogramDTO result = apiInstance.V1PictogramByIdPut(id, pictogram);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramByIdPut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**|  | 
 **pictogram** | [**PictogramDTO**](PictogramDTO.md)| A GirafRest.Models.DTOs.PictogramDTO with all new information to update with.              The Id found in this DTO is the target pictogram. | [optional] 

### Return type

[**ResponsePictogramDTO**](ResponsePictogramDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogramget"></a>
# **V1PictogramGet**
> ResponseListPictogramDTO V1PictogramGet (int? p, int? n, string q = null)

Get all public GirafRest.Models.Pictogram pictograms available to the user  (i.e the public pictograms and those owned by the user (PRIVATE) and his department (PROTECTED)).

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var p = 56;  // int? | Page number
            var n = 56;  // int? | Number of pictograms per page, defaults to 10
            var q = q_example;  // string | The query string. pictograms are filtered based on this string if passed (optional) 

            try
            {
                // Get all public GirafRest.Models.Pictogram pictograms available to the user  (i.e the public pictograms and those owned by the user (PRIVATE) and his department (PROTECTED)).
                ResponseListPictogramDTO result = apiInstance.V1PictogramGet(p, n, q);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **p** | **int?**| Page number | 
 **n** | **int?**| Number of pictograms per page, defaults to 10 | 
 **q** | **string**| The query string. pictograms are filtered based on this string if passed | [optional] 

### Return type

[**ResponseListPictogramDTO**](ResponseListPictogramDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1pictogrampost"></a>
# **V1PictogramPost**
> ResponsePictogramDTO V1PictogramPost (PictogramDTO pictogram = null)

Create a new GirafRest.Models.Pictogram pictogram.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1PictogramPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new PictogramApi();
            var pictogram = new PictogramDTO(); // PictogramDTO | A GirafRest.Models.DTOs.PictogramDTO with all relevant information about the new pictogram. (optional) 

            try
            {
                // Create a new GirafRest.Models.Pictogram pictogram.
                ResponsePictogramDTO result = apiInstance.V1PictogramPost(pictogram);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling PictogramApi.V1PictogramPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pictogram** | [**PictogramDTO**](PictogramDTO.md)| A GirafRest.Models.DTOs.PictogramDTO with all relevant information about the new pictogram. | [optional] 

### Return type

[**ResponsePictogramDTO**](ResponsePictogramDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

