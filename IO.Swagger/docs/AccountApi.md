# IO.Swagger.Api.AccountApi

All URIs are relative to *https://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**V1AccountAccessDeniedGet**](AccountApi.md#v1accountaccessdeniedget) | **GET** /v1/Account/access-denied | An end-point that simply returns Unauthorized. It is redirected to by the runtime when an unauthorized request  to an end-point with the [Authorize] attribute is encountered.
[**V1AccountChangePasswordPost**](AccountApi.md#v1accountchangepasswordpost) | **POST** /v1/Account/change-password | Allows the user to change his password.
[**V1AccountForgotPasswordPost**](AccountApi.md#v1accountforgotpasswordpost) | **POST** /v1/Account/forgot-password | Use this endpoint to request a password reset link, which is send to the user&#39;s email address.
[**V1AccountLoginPost**](AccountApi.md#v1accountloginpost) | **POST** /v1/Account/login | This endpoint allows the user to sign in to his account by providing valid username and password.
[**V1AccountLogoutPost**](AccountApi.md#v1accountlogoutpost) | **POST** /v1/Account/logout | Logs the currently authenticated user out of the system.
[**V1AccountRegisterPost**](AccountApi.md#v1accountregisterpost) | **POST** /v1/Account/register | Register a new user in the REST-API
[**V1AccountResetPasswordConfirmationGet**](AccountApi.md#v1accountresetpasswordconfirmationget) | **GET** /v1/Account/reset-password-confirmation | Get the view associated with the ResetPasswordConfirmation page.
[**V1AccountResetPasswordGet**](AccountApi.md#v1accountresetpasswordget) | **GET** /v1/Account/reset-password | Gets the view associated with the ResetPassword page.
[**V1AccountResetPasswordPost**](AccountApi.md#v1accountresetpasswordpost) | **POST** /v1/Account/reset-password | Attempts to change the given user&#39;s password. If the DTO did not contain valid information simply returns the view with  the current information that the user has specified.
[**V1AccountSetPasswordPost**](AccountApi.md#v1accountsetpasswordpost) | **POST** /v1/Account/set-password | Creates a new password for the currently authenticated user.


<a name="v1accountaccessdeniedget"></a>
# **V1AccountAccessDeniedGet**
> void V1AccountAccessDeniedGet ()

An end-point that simply returns Unauthorized. It is redirected to by the runtime when an unauthorized request  to an end-point with the [Authorize] attribute is encountered.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountAccessDeniedGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();

            try
            {
                // An end-point that simply returns Unauthorized. It is redirected to by the runtime when an unauthorized request  to an end-point with the [Authorize] attribute is encountered.
                apiInstance.V1AccountAccessDeniedGet();
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountAccessDeniedGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountchangepasswordpost"></a>
# **V1AccountChangePasswordPost**
> Response V1AccountChangePasswordPost (string oldPassword, string newPassword)

Allows the user to change his password.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountChangePasswordPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var oldPassword = oldPassword_example;  // string | The users current password.
            var newPassword = newPassword_example;  // string | The desired password.

            try
            {
                // Allows the user to change his password.
                Response result = apiInstance.V1AccountChangePasswordPost(oldPassword, newPassword);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountChangePasswordPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **oldPassword** | **string**| The users current password. | 
 **newPassword** | **string**| The desired password. | 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountforgotpasswordpost"></a>
# **V1AccountForgotPasswordPost**
> Response V1AccountForgotPasswordPost (ForgotPasswordDTO model = null)

Use this endpoint to request a password reset link, which is send to the user's email address.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountForgotPasswordPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var model = new ForgotPasswordDTO(); // ForgotPasswordDTO | A ForgotPasswordDTO, which contains a username and an email address. (optional) 

            try
            {
                // Use this endpoint to request a password reset link, which is send to the user's email address.
                Response result = apiInstance.V1AccountForgotPasswordPost(model);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountForgotPasswordPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **model** | [**ForgotPasswordDTO**](ForgotPasswordDTO.md)| A ForgotPasswordDTO, which contains a username and an email address. | [optional] 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountloginpost"></a>
# **V1AccountLoginPost**
> ResponseString V1AccountLoginPost (LoginDTO model = null)

This endpoint allows the user to sign in to his account by providing valid username and password.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountLoginPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var model = new LoginDTO(); // LoginDTO | A LoginDTO(LoginViewModelDTO), i.e. a json-string with a username and a password field. (optional) 

            try
            {
                // This endpoint allows the user to sign in to his account by providing valid username and password.
                ResponseString result = apiInstance.V1AccountLoginPost(model);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountLoginPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **model** | [**LoginDTO**](LoginDTO.md)| A LoginDTO(LoginViewModelDTO), i.e. a json-string with a username and a password field. | [optional] 

### Return type

[**ResponseString**](ResponseString.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountlogoutpost"></a>
# **V1AccountLogoutPost**
> Response V1AccountLogoutPost ()

Logs the currently authenticated user out of the system.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountLogoutPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();

            try
            {
                // Logs the currently authenticated user out of the system.
                Response result = apiInstance.V1AccountLogoutPost();
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountLogoutPost: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountregisterpost"></a>
# **V1AccountRegisterPost**
> ResponseGirafUserDTO V1AccountRegisterPost (RegisterDTO model = null)

Register a new user in the REST-API

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountRegisterPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var model = new RegisterDTO(); // RegisterDTO | A reference to a RegisterDTO(RegisterViewModelDTO), i.e. a json string containing three strings;              Username and Password. (optional) 

            try
            {
                // Register a new user in the REST-API
                ResponseGirafUserDTO result = apiInstance.V1AccountRegisterPost(model);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountRegisterPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **model** | [**RegisterDTO**](RegisterDTO.md)| A reference to a RegisterDTO(RegisterViewModelDTO), i.e. a json string containing three strings;              Username and Password. | [optional] 

### Return type

[**ResponseGirafUserDTO**](ResponseGirafUserDTO.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountresetpasswordconfirmationget"></a>
# **V1AccountResetPasswordConfirmationGet**
> void V1AccountResetPasswordConfirmationGet ()

Get the view associated with the ResetPasswordConfirmation page.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountResetPasswordConfirmationGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();

            try
            {
                // Get the view associated with the ResetPasswordConfirmation page.
                apiInstance.V1AccountResetPasswordConfirmationGet();
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountResetPasswordConfirmationGet: " + e.Message );
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountresetpasswordget"></a>
# **V1AccountResetPasswordGet**
> void V1AccountResetPasswordGet (string code = null)

Gets the view associated with the ResetPassword page.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountResetPasswordGetExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var code = code_example;  // string | The reset password token that has been sent to the user via his email. (optional) 

            try
            {
                // Gets the view associated with the ResetPassword page.
                apiInstance.V1AccountResetPasswordGet(code);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountResetPasswordGet: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **string**| The reset password token that has been sent to the user via his email. | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountresetpasswordpost"></a>
# **V1AccountResetPasswordPost**
> void V1AccountResetPasswordPost (string username, string password, string confirmPassword, string code = null)

Attempts to change the given user's password. If the DTO did not contain valid information simply returns the view with  the current information that the user has specified.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountResetPasswordPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var username = username_example;  // string | The users username.
            var password = password_example;  // string | The users password.
            var confirmPassword = confirmPassword_example;  // string | The users password again to avoid typos/mistakes.
            var code = code_example;  // string | Reset password confirmation code. Used when a user request a password reset, this code needs to be added to the url in order to reset. (optional) 

            try
            {
                // Attempts to change the given user's password. If the DTO did not contain valid information simply returns the view with  the current information that the user has specified.
                apiInstance.V1AccountResetPasswordPost(username, password, confirmPassword, code);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountResetPasswordPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **string**| The users username. | 
 **password** | **string**| The users password. | 
 **confirmPassword** | **string**| The users password again to avoid typos/mistakes. | 
 **code** | **string**| Reset password confirmation code. Used when a user request a password reset, this code needs to be added to the url in order to reset. | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="v1accountsetpasswordpost"></a>
# **V1AccountSetPasswordPost**
> Response V1AccountSetPasswordPost (string newPassword, string confirmPassword = null)

Creates a new password for the currently authenticated user.

### Example
```csharp
using System;
using System.Diagnostics;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace Example
{
    public class V1AccountSetPasswordPostExample
    {
        public void main()
        {
            // Configure API key authorization: Bearer
            Configuration.Default.AddApiKey("Authorization", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // Configuration.Default.AddApiKeyPrefix("Authorization", "Bearer");

            var apiInstance = new AccountApi();
            var newPassword = newPassword_example;  // string | The desired password.
            var confirmPassword = confirmPassword_example;  // string | The desired password again to avoid typos/mistakes. (optional) 

            try
            {
                // Creates a new password for the currently authenticated user.
                Response result = apiInstance.V1AccountSetPasswordPost(newPassword, confirmPassword);
                Debug.WriteLine(result);
            }
            catch (Exception e)
            {
                Debug.Print("Exception when calling AccountApi.V1AccountSetPasswordPost: " + e.Message );
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **newPassword** | **string**| The desired password. | 
 **confirmPassword** | **string**| The desired password again to avoid typos/mistakes. | [optional] 

### Return type

[**Response**](Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

