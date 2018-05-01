using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class MockAccountApi : IAccountApi
    {
        public Configuration Configuration { get; set; } = new Configuration();
        public string GetBasePath()
        {
            throw new NotImplementedException();
        }

        public ExceptionFactory ExceptionFactory { get; set; }
        public void V1AccountAccessDeniedGet()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountAccessDeniedGetWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public Response V1AccountChangePasswordPost(string oldPassword, string newPassword)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountChangePasswordPostWithHttpInfo(string oldPassword, string newPassword)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountForgotPasswordPost(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountForgotPasswordPostWithHttpInfo(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ResponseString V1AccountLoginPost(LoginDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseString> V1AccountLoginPostWithHttpInfo(LoginDTO model = null)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountLogoutPost()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountLogoutPostWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ResponseGirafUserDTO V1AccountRegisterPost(RegisterDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1AccountRegisterPostWithHttpInfo(RegisterDTO model = null)
        {
            throw new NotImplementedException();
        }

        public void V1AccountResetPasswordConfirmationGet()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountResetPasswordConfirmationGetWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public void V1AccountResetPasswordGet(string code = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountResetPasswordGetWithHttpInfo(string code = null)
        {
            throw new NotImplementedException();
        }

        public void V1AccountResetPasswordPost(string username, string password, string confirmPassword, string code = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountResetPasswordPostWithHttpInfo(string username, string password, string confirmPassword,
            string code = null)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountSetPasswordPost(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountSetPasswordPostWithHttpInfo(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public async Task V1AccountAccessDeniedGetAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<object>> V1AccountAccessDeniedGetAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public async Task<Response> V1AccountChangePasswordPostAsync(string oldPassword, string newPassword)
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<Response>> V1AccountChangePasswordPostAsyncWithHttpInfo(string oldPassword, string newPassword)
        {
            throw new NotImplementedException();
        }

        public async Task<Response> V1AccountForgotPasswordPostAsync(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<Response>> V1AccountForgotPasswordPostAsyncWithHttpInfo(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseString> V1AccountLoginPostAsync(LoginDTO model = null)
        {
            ResponseString result;
            
            // TODO: Handle citizen login
            if (model?.Username == "Graatand" && model.Password == "password")
            {
                result = new ResponseString("MySecretMockGuardianAuthToken", true)
                {
                    ErrorKey = ResponseString.ErrorKeyEnum.NoError
                };
            }
            else
            {
                result = new ResponseString(null, false, new List<string> {"username", "password"})
                {
                    ErrorKey = ResponseString.ErrorKeyEnum.InvalidCredentials
                };
            }
            return await Task.FromResult(result);
        }

        public async Task<ApiResponse<ResponseString>> V1AccountLoginPostAsyncWithHttpInfo(LoginDTO model = null)
        {
            throw new NotImplementedException();
        }

        public async Task<Response> V1AccountLogoutPostAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<Response>> V1AccountLogoutPostAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1AccountRegisterPostAsync(RegisterDTO model = null)
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1AccountRegisterPostAsyncWithHttpInfo(RegisterDTO model = null)
        {
            throw new NotImplementedException();
        }

        public async Task V1AccountResetPasswordConfirmationGetAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<object>> V1AccountResetPasswordConfirmationGetAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public async Task V1AccountResetPasswordGetAsync(string code = null)
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<object>> V1AccountResetPasswordGetAsyncWithHttpInfo(string code = null)
        {
            throw new NotImplementedException();
        }

        public async Task V1AccountResetPasswordPostAsync(string username, string password, string confirmPassword, string code = null)
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<object>> V1AccountResetPasswordPostAsyncWithHttpInfo(string username, string password, string confirmPassword,
            string code = null)
        {
            throw new NotImplementedException();
        }

        public async Task<Response> V1AccountSetPasswordPostAsync(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public async Task<ApiResponse<Response>> V1AccountSetPasswordPostAsyncWithHttpInfo(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public void V1AccountResetPasswordPost(string username, string password, string code = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountResetPasswordPostWithHttpInfo(string username, string password, string code = null)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountSetPasswordPost(string newPassword)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountSetPasswordPostWithHttpInfo(string newPassword)
        {
            throw new NotImplementedException();
        }

        public Task V1AccountResetPasswordPostAsync(string username, string password, string code = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<object>> V1AccountResetPasswordPostAsyncWithHttpInfo(string username, string password, string code = null)
        {
            throw new NotImplementedException();
        }

        public Task<Response> V1AccountSetPasswordPostAsync(string newPassword)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<Response>> V1AccountSetPasswordPostAsyncWithHttpInfo(string newPassword)
        {
            throw new NotImplementedException();
        }
    }
}
