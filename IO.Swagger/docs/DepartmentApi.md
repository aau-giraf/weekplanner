# IO.Swagger.Api.DepartmentApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1DepartmentByIdCitizensGet**](DepartmentApi.md#v1departmentbyidcitizensget) | **GET** /v1/Department/{id}/citizens | Gets the citizen names.
[**V1DepartmentByIdGet**](DepartmentApi.md#v1departmentbyidget) | **GET** /v1/Department/{id} | Get the department with the specified id.
[**V1DepartmentGet**](DepartmentApi.md#v1departmentget) | **GET** /v1/Department | Get all departments registered in the database or search for a department name as a query string.
[**V1DepartmentPost**](DepartmentApi.md#v1departmentpost) | **POST** /v1/Department | Create a new department. it&#39;s only necesary to supply the departments name
[**V1DepartmentResourceByDepartmentIDPost**](DepartmentApi.md#v1departmentresourcebydepartmentidpost) | **POST** /v1/Department/resource/{departmentID} | Add a resource to the given department. After this call, the department owns the resource and it is available to all its members.
[**V1DepartmentResourceDelete**](DepartmentApi.md#v1departmentresourcedelete) | **DELETE** /v1/Department/resource | Removes a resource from the users department.
[**V1DepartmentUserByDepartmentIDDelete**](DepartmentApi.md#v1departmentuserbydepartmentiddelete) | **DELETE** /v1/Department/user/{departmentID} | Removes a user from a given department.
[**V1DepartmentUserByDepartmentIDPost**](DepartmentApi.md#v1departmentuserbydepartmentidpost) | **POST** /v1/Department/user/{departmentID} | Add a user to the given department.


<a name="v1departmentbyidcitizensget"></a>
# **V1DepartmentByIdCitizensGet**
> ResponseListUserNameDTO V1DepartmentByIdCitizensGet (long? id)

Gets the citizen names.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentByIdCitizensGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var id = 789;  // long? | Identifier.

            try
            {
                // Gets the citizen names.
                ResponseListUserNameDTO result = apiInstance.V1DepartmentByIdCitizensGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentByIdCitizensGet: " + e.Message );
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

[**ResponseListUserNameDTO**](ResponseListUserNameDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentbyidget"></a>
# **V1DepartmentByIdGet**
> ResponseDepartmentDTO V1DepartmentByIdGet (long? id)

Get the department with the specified id.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentByIdGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var id = 789;  // long? | The id of the department to search for.

            try
            {
                // Get the department with the specified id.
                ResponseDepartmentDTO result = apiInstance.V1DepartmentByIdGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentByIdGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **long?**| The id of the department to search for. | 

### Return type

[**ResponseDepartmentDTO**](ResponseDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentget"></a>
# **V1DepartmentGet**
> ResponseListDepartmentDTO V1DepartmentGet ()

Get all departments registered in the database or search for a department name as a query string.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();

            try
            {
                // Get all departments registered in the database or search for a department name as a query string.
                ResponseListDepartmentDTO result = apiInstance.V1DepartmentGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseListDepartmentDTO**](ResponseListDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentpost"></a>
# **V1DepartmentPost**
> ResponseDepartmentDTO V1DepartmentPost (DepartmentDTO depDTO = null)

Create a new department. it's only necesary to supply the departments name

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var depDTO = new DepartmentDTO(); // DepartmentDTO | The department to add to the database. (optional) 

            try
            {
                // Create a new department. it's only necesary to supply the departments name
                ResponseDepartmentDTO result = apiInstance.V1DepartmentPost(depDTO);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **depDTO** | [**DepartmentDTO**](DepartmentDTO.md)| The department to add to the database. | [optional] 

### Return type

[**ResponseDepartmentDTO**](ResponseDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentresourcebydepartmentidpost"></a>
# **V1DepartmentResourceByDepartmentIDPost**
> ResponseDepartmentDTO V1DepartmentResourceByDepartmentIDPost (long? departmentID, ResourceIdDTO resourceDTO = null)

Add a resource to the given department. After this call, the department owns the resource and it is available to all its members.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentResourceByDepartmentIDPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var departmentID = 789;  // long? | Id of the department to add the resource to.
            var resourceDTO = new ResourceIdDTO(); // ResourceIdDTO |  (optional) 

            try
            {
                // Add a resource to the given department. After this call, the department owns the resource and it is available to all its members.
                ResponseDepartmentDTO result = apiInstance.V1DepartmentResourceByDepartmentIDPost(departmentID, resourceDTO);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentResourceByDepartmentIDPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **departmentID** | **long?**| Id of the department to add the resource to. | 
 **resourceDTO** | [**ResourceIdDTO**](ResourceIdDTO.md)|  | [optional] 

### Return type

[**ResponseDepartmentDTO**](ResponseDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentresourcedelete"></a>
# **V1DepartmentResourceDelete**
> ResponseDepartmentDTO V1DepartmentResourceDelete (ResourceIdDTO resourceDTO = null)

Removes a resource from the users department.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentResourceDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var resourceDTO = new ResourceIdDTO(); // ResourceIdDTO |  (optional) 

            try
            {
                // Removes a resource from the users department.
                ResponseDepartmentDTO result = apiInstance.V1DepartmentResourceDelete(resourceDTO);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentResourceDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resourceDTO** | [**ResourceIdDTO**](ResourceIdDTO.md)|  | [optional] 

### Return type

[**ResponseDepartmentDTO**](ResponseDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentuserbydepartmentiddelete"></a>
# **V1DepartmentUserByDepartmentIDDelete**
> ResponseDepartmentDTO V1DepartmentUserByDepartmentIDDelete (long? departmentID, GirafUserDTO usr = null)

Removes a user from a given department.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentUserByDepartmentIDDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var departmentID = 789;  // long? | Id of the department from which the user should be removed
            var usr = new GirafUserDTO(); // GirafUserDTO | A serialized instance of a GirafRest.Models.GirafUser user. (optional) 

            try
            {
                // Removes a user from a given department.
                ResponseDepartmentDTO result = apiInstance.V1DepartmentUserByDepartmentIDDelete(departmentID, usr);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentUserByDepartmentIDDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **departmentID** | **long?**| Id of the department from which the user should be removed | 
 **usr** | [**GirafUserDTO**](GirafUserDTO.md)| A serialized instance of a GirafRest.Models.GirafUser user. | [optional] 

### Return type

[**ResponseDepartmentDTO**](ResponseDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1departmentuserbydepartmentidpost"></a>
# **V1DepartmentUserByDepartmentIDPost**
> ResponseDepartmentDTO V1DepartmentUserByDepartmentIDPost (long? departmentID, GirafUserDTO usr = null)

Add a user to the given department.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1DepartmentUserByDepartmentIDPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new DepartmentApi();
            var departmentID = 789;  // long? | 
            var usr = new GirafUserDTO(); // GirafUserDTO | An existing GirafUser instance to be added to the department. (optional) 

            try
            {
                // Add a user to the given department.
                ResponseDepartmentDTO result = apiInstance.V1DepartmentUserByDepartmentIDPost(departmentID, usr);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling DepartmentApi.V1DepartmentUserByDepartmentIDPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **departmentID** | **long?**|  | 
 **usr** | [**GirafUserDTO**](GirafUserDTO.md)| An existing GirafUser instance to be added to the department. | [optional] 

### Return type

[**ResponseDepartmentDTO**](ResponseDepartmentDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

