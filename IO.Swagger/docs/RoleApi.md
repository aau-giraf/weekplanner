# IO.Swagger.Api.RoleApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1RoleAdminByUsernameDelete**](RoleApi.md#v1roleadminbyusernamedelete) | **DELETE** /v1/Role/admin/{username} | 
[**V1RoleAdminByUsernamePost**](RoleApi.md#v1roleadminbyusernamepost) | **POST** /v1/Role/admin/{username} | Adds the user to the Admin role
[**V1RoleGet**](RoleApi.md#v1roleget) | **GET** /v1/Role | Gets the role of a given user
[**V1RoleGuardianByUsernameDelete**](RoleApi.md#v1roleguardianbyusernamedelete) | **DELETE** /v1/Role/guardian/{username} | Removes the user from the Guardian role
[**V1RoleGuardianByUsernamePost**](RoleApi.md#v1roleguardianbyusernamepost) | **POST** /v1/Role/guardian/{username} | Adds a specified user to the Guardian role


<a name="v1roleadminbyusernamedelete"></a>
# **V1RoleAdminByUsernameDelete**
> Response V1RoleAdminByUsernameDelete (string username)



### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1RoleAdminByUsernameDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new RoleApi();
            var username = username_example;  // string | 

            try
            {
                Response result = apiInstance.V1RoleAdminByUsernameDelete(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling RoleApi.V1RoleAdminByUsernameDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**|  | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1roleadminbyusernamepost"></a>
# **V1RoleAdminByUsernamePost**
> Response V1RoleAdminByUsernamePost (string username)

Adds the user to the Admin role

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1RoleAdminByUsernamePostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new RoleApi();
            var username = username_example;  // string | The username of the user in question

            try
            {
                // Adds the user to the Admin role
                Response result = apiInstance.V1RoleAdminByUsernamePost(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling RoleApi.V1RoleAdminByUsernamePost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| The username of the user in question | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1roleget"></a>
# **V1RoleGet**
> ResponseString V1RoleGet ()

Gets the role of a given user

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1RoleGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new RoleApi();

            try
            {
                // Gets the role of a given user
                ResponseString result = apiInstance.V1RoleGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling RoleApi.V1RoleGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseString**](ResponseString.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1roleguardianbyusernamedelete"></a>
# **V1RoleGuardianByUsernameDelete**
> Response V1RoleGuardianByUsernameDelete (string username)

Removes the user from the Guardian role

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1RoleGuardianByUsernameDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new RoleApi();
            var username = username_example;  // string | The username of the user in question

            try
            {
                // Removes the user from the Guardian role
                Response result = apiInstance.V1RoleGuardianByUsernameDelete(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling RoleApi.V1RoleGuardianByUsernameDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| The username of the user in question | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1roleguardianbyusernamepost"></a>
# **V1RoleGuardianByUsernamePost**
> Response V1RoleGuardianByUsernamePost (string username)

Adds a specified user to the Guardian role

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1RoleGuardianByUsernamePostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new RoleApi();
            var username = username_example;  // string | Username of the user who needs be to made guardian

            try
            {
                // Adds a specified user to the Guardian role
                Response result = apiInstance.V1RoleGuardianByUsernamePost(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling RoleApi.V1RoleGuardianByUsernamePost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| Username of the user who needs be to made guardian | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

