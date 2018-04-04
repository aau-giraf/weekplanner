# IO.Swagger.Api.UserApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1UserApplicationsByUsernameDelete**](UserApi.md#v1userapplicationsbyusernamedelete) | **DELETE** /v1/User/applications/{username} | Delete an application from the given user&#39;s list of applications.
[**V1UserApplicationsByUsernamePost**](UserApi.md#v1userapplicationsbyusernamepost) | **POST** /v1/User/applications/{username} | Adds an application to the specified user&#39;s list of applications.
[**V1UserByIdIconGet**](UserApi.md#v1userbyidiconget) | **GET** /v1/User/{id}/icon | Allows the user to retrieve his profile icon.
[**V1UserByIdIconRawGet**](UserApi.md#v1userbyidiconrawget) | **GET** /v1/User/{id}/icon/raw | Allows the user to retrieve his profile icon.
[**V1UserByUsernameGet**](UserApi.md#v1userbyusernameget) | **GET** /v1/User/{username} | Find information on the user with the username supplied as a url query parameter or the current user.
[**V1UserDisplayNamePut**](UserApi.md#v1userdisplaynameput) | **PUT** /v1/User/display-name | Updates the display name of the current user.
[**V1UserGet**](UserApi.md#v1userget) | **GET** /v1/User | Get information about the logged in user.
[**V1UserGetCitizensByUsernameGet**](UserApi.md#v1usergetcitizensbyusernameget) | **GET** /v1/User/getCitizens/{username} | Gets the citizens for the specific user corresponding to the provided username.
[**V1UserGetGuardiansByUsernameGet**](UserApi.md#v1usergetguardiansbyusernameget) | **GET** /v1/User/getGuardians/{username} | Gets the guardians for the specific user corresponding to the provided username.
[**V1UserGrayscaleByEnabledPost**](UserApi.md#v1usergrayscalebyenabledpost) | **POST** /v1/User/grayscale/{enabled} | Enables or disables grayscale mode for the currently authenticated user.
[**V1UserIconDelete**](UserApi.md#v1usericondelete) | **DELETE** /v1/User/icon | Allows the user to delete his profile icon.
[**V1UserIconPut**](UserApi.md#v1usericonput) | **PUT** /v1/User/icon | Allows the user to update his profile icon.
[**V1UserLauncherAnimationsByEnabledPost**](UserApi.md#v1userlauncheranimationsbyenabledpost) | **POST** /v1/User/launcher_animations/{enabled} | Enables or disables launcher animations for the currently authenticated user.
[**V1UserPut**](UserApi.md#v1userput) | **PUT** /v1/User | Updates all the information of the currently authenticated user with the information from the given DTO.
[**V1UserResourceByUsernamePost**](UserApi.md#v1userresourcebyusernamepost) | **POST** /v1/User/resource/{username} | Adds a resource to the given user&#39;s list of resources.
[**V1UserResourceDelete**](UserApi.md#v1userresourcedelete) | **DELETE** /v1/User/resource | Deletes a resource with the specified id from the given user&#39;s list of resources.
[**V1UserSettingsGet**](UserApi.md#v1usersettingsget) | **GET** /v1/User/settings | Read the currently authorized user&#39;s settings object.
[**V1UserSettingsPut**](UserApi.md#v1usersettingsput) | **PUT** /v1/User/settings | 
[**V1UserUsernameGet**](UserApi.md#v1userusernameget) | **GET** /v1/User/username | Returns currently logged in users username


<a name="v1userapplicationsbyusernamedelete"></a>
# **V1UserApplicationsByUsernameDelete**
> ResponseGirafUserDTO V1UserApplicationsByUsernameDelete (string username, ApplicationOption application = null)

Delete an application from the given user's list of applications.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserApplicationsByUsernameDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var username = username_example;  // string | The username of the user to delete the application from.
            var application = new ApplicationOption(); // ApplicationOption | The application to delete (its ID is sufficient). (optional) 

            try
            {
                // Delete an application from the given user's list of applications.
                ResponseGirafUserDTO result = apiInstance.V1UserApplicationsByUsernameDelete(username, application);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserApplicationsByUsernameDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| The username of the user to delete the application from. | 
 **application** | [**ApplicationOption**](ApplicationOption.md)| The application to delete (its ID is sufficient). | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userapplicationsbyusernamepost"></a>
# **V1UserApplicationsByUsernamePost**
> ResponseGirafUserDTO V1UserApplicationsByUsernamePost (string username, ApplicationOption application = null)

Adds an application to the specified user's list of applications.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserApplicationsByUsernamePostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var username = username_example;  // string | 
            var application = new ApplicationOption(); // ApplicationOption | Information on the new application to add, must be serialized              and in the request body. Please specify ApplicationName and ApplicationPackage. (optional) 

            try
            {
                // Adds an application to the specified user's list of applications.
                ResponseGirafUserDTO result = apiInstance.V1UserApplicationsByUsernamePost(username, application);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserApplicationsByUsernamePost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**|  | 
 **application** | [**ApplicationOption**](ApplicationOption.md)| Information on the new application to add, must be serialized              and in the request body. Please specify ApplicationName and ApplicationPackage. | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userbyidiconget"></a>
# **V1UserByIdIconGet**
> ResponseImageDTO V1UserByIdIconGet (string id)

Allows the user to retrieve his profile icon.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserByIdIconGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var id = id_example;  // string | 

            try
            {
                // Allows the user to retrieve his profile icon.
                ResponseImageDTO result = apiInstance.V1UserByIdIconGet(id);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserByIdIconGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **string**|  | 

### Return type

[**ResponseImageDTO**](ResponseImageDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userbyidiconrawget"></a>
# **V1UserByIdIconRawGet**
> void V1UserByIdIconRawGet (string id)

Allows the user to retrieve his profile icon.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserByIdIconRawGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var id = id_example;  // string | 

            try
            {
                // Allows the user to retrieve his profile icon.
                apiInstance.V1UserByIdIconRawGet(id);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserByIdIconRawGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **string**|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userbyusernameget"></a>
# **V1UserByUsernameGet**
> ResponseGirafUserDTO V1UserByUsernameGet (string username)

Find information on the user with the username supplied as a url query parameter or the current user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserByUsernameGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var username = username_example;  // string | 

            try
            {
                // Find information on the user with the username supplied as a url query parameter or the current user.
                ResponseGirafUserDTO result = apiInstance.V1UserByUsernameGet(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserByUsernameGet: " + e.Message );
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

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userdisplaynameput"></a>
# **V1UserDisplayNamePut**
> ResponseGirafUserDTO V1UserDisplayNamePut (string displayName = null)

Updates the display name of the current user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserDisplayNamePutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var displayName = displayName_example;  // string | The new display name of the user. (optional) 

            try
            {
                // Updates the display name of the current user.
                ResponseGirafUserDTO result = apiInstance.V1UserDisplayNamePut(displayName);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserDisplayNamePut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **displayName** | **string**| The new display name of the user. | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userget"></a>
# **V1UserGet**
> ResponseGirafUserDTO V1UserGet ()

Get information about the logged in user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();

            try
            {
                // Get information about the logged in user.
                ResponseGirafUserDTO result = apiInstance.V1UserGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usergetcitizensbyusernameget"></a>
# **V1UserGetCitizensByUsernameGet**
> ResponseListGirafUserDTO V1UserGetCitizensByUsernameGet (string username)

Gets the citizens for the specific user corresponding to the provided username.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserGetCitizensByUsernameGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var username = username_example;  // string | Username.

            try
            {
                // Gets the citizens for the specific user corresponding to the provided username.
                ResponseListGirafUserDTO result = apiInstance.V1UserGetCitizensByUsernameGet(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserGetCitizensByUsernameGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| Username. | 

### Return type

[**ResponseListGirafUserDTO**](ResponseListGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usergetguardiansbyusernameget"></a>
# **V1UserGetGuardiansByUsernameGet**
> ResponseListGirafUserDTO V1UserGetGuardiansByUsernameGet (string username)

Gets the guardians for the specific user corresponding to the provided username.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserGetGuardiansByUsernameGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var username = username_example;  // string | Username.

            try
            {
                // Gets the guardians for the specific user corresponding to the provided username.
                ResponseListGirafUserDTO result = apiInstance.V1UserGetGuardiansByUsernameGet(username);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserGetGuardiansByUsernameGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| Username. | 

### Return type

[**ResponseListGirafUserDTO**](ResponseListGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usergrayscalebyenabledpost"></a>
# **V1UserGrayscaleByEnabledPost**
> ResponseGirafUserDTO V1UserGrayscaleByEnabledPost (bool? enabled)

Enables or disables grayscale mode for the currently authenticated user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserGrayscaleByEnabledPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var enabled = true;  // bool? | A bool indicating whether grayscale should be enabled or not.

            try
            {
                // Enables or disables grayscale mode for the currently authenticated user.
                ResponseGirafUserDTO result = apiInstance.V1UserGrayscaleByEnabledPost(enabled);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserGrayscaleByEnabledPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enabled** | **bool?**| A bool indicating whether grayscale should be enabled or not. | 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usericondelete"></a>
# **V1UserIconDelete**
> ResponseGirafUserDTO V1UserIconDelete ()

Allows the user to delete his profile icon.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserIconDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();

            try
            {
                // Allows the user to delete his profile icon.
                ResponseGirafUserDTO result = apiInstance.V1UserIconDelete();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserIconDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usericonput"></a>
# **V1UserIconPut**
> ResponseGirafUserDTO V1UserIconPut ()

Allows the user to update his profile icon.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserIconPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();

            try
            {
                // Allows the user to update his profile icon.
                ResponseGirafUserDTO result = apiInstance.V1UserIconPut();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserIconPut: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userlauncheranimationsbyenabledpost"></a>
# **V1UserLauncherAnimationsByEnabledPost**
> ResponseGirafUserDTO V1UserLauncherAnimationsByEnabledPost (bool? enabled)

Enables or disables launcher animations for the currently authenticated user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserLauncherAnimationsByEnabledPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var enabled = true;  // bool? | A bool indicating whether launcher animations should be enabled or not.

            try
            {
                // Enables or disables launcher animations for the currently authenticated user.
                ResponseGirafUserDTO result = apiInstance.V1UserLauncherAnimationsByEnabledPost(enabled);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserLauncherAnimationsByEnabledPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enabled** | **bool?**| A bool indicating whether launcher animations should be enabled or not. | 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userput"></a>
# **V1UserPut**
> ResponseGirafUserDTO V1UserPut (GirafUserDTO userDTO = null)

Updates all the information of the currently authenticated user with the information from the given DTO.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var userDTO = new GirafUserDTO(); // GirafUserDTO | A DTO containing ALL the new information for the given user. (optional) 

            try
            {
                // Updates all the information of the currently authenticated user with the information from the given DTO.
                ResponseGirafUserDTO result = apiInstance.V1UserPut(userDTO);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserPut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userDTO** | [**GirafUserDTO**](GirafUserDTO.md)| A DTO containing ALL the new information for the given user. | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userresourcebyusernamepost"></a>
# **V1UserResourceByUsernamePost**
> ResponseGirafUserDTO V1UserResourceByUsernamePost (string username, ResourceIdDTO resourceIdDTO = null)

Adds a resource to the given user's list of resources.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserResourceByUsernamePostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var username = username_example;  // string | 
            var resourceIdDTO = new ResourceIdDTO(); // ResourceIdDTO |  (optional) 

            try
            {
                // Adds a resource to the given user's list of resources.
                ResponseGirafUserDTO result = apiInstance.V1UserResourceByUsernamePost(username, resourceIdDTO);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserResourceByUsernamePost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**|  | 
 **resourceIdDTO** | [**ResourceIdDTO**](ResourceIdDTO.md)|  | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userresourcedelete"></a>
# **V1UserResourceDelete**
> ResponseGirafUserDTO V1UserResourceDelete (ResourceIdDTO resourceIdDTO = null)

Deletes a resource with the specified id from the given user's list of resources.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserResourceDeleteExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var resourceIdDTO = new ResourceIdDTO(); // ResourceIdDTO |  (optional) 

            try
            {
                // Deletes a resource with the specified id from the given user's list of resources.
                ResponseGirafUserDTO result = apiInstance.V1UserResourceDelete(resourceIdDTO);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserResourceDelete: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resourceIdDTO** | [**ResourceIdDTO**](ResourceIdDTO.md)|  | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usersettingsget"></a>
# **V1UserSettingsGet**
> ResponseLauncherOptionsDTO V1UserSettingsGet ()

Read the currently authorized user's settings object.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserSettingsGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();

            try
            {
                // Read the currently authorized user's settings object.
                ResponseLauncherOptionsDTO result = apiInstance.V1UserSettingsGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserSettingsGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ResponseLauncherOptionsDTO**](ResponseLauncherOptionsDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1usersettingsput"></a>
# **V1UserSettingsPut**
> ResponseLauncherOptions V1UserSettingsPut (LauncherOptionsDTO options = null)



### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserSettingsPutExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();
            var options = new LauncherOptionsDTO(); // LauncherOptionsDTO |  (optional) 

            try
            {
                ResponseLauncherOptions result = apiInstance.V1UserSettingsPut(options);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserSettingsPut: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **options** | [**LauncherOptionsDTO**](LauncherOptionsDTO.md)|  | [optional] 

### Return type

[**ResponseLauncherOptions**](ResponseLauncherOptions.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1userusernameget"></a>
# **V1UserUsernameGet**
> ResponseString V1UserUsernameGet ()

Returns currently logged in users username

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1UserUsernameGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new UserApi();

            try
            {
                // Returns currently logged in users username
                ResponseString result = apiInstance.V1UserUsernameGet();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling UserApi.V1UserUsernameGet: " + e.Message );
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

