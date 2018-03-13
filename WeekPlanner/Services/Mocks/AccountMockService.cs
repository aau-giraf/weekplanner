using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class AccountMockService : IAccountApi
    {
        public Configuration Configuration { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public ExceptionFactory ExceptionFactory { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public string GetBasePath()
        {
            throw new NotImplementedException();
        }

        public void V1AccountAccessDeniedGet()
        {
            throw new NotImplementedException();
        }

        public Task V1AccountAccessDeniedGetAsync()
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<object>> V1AccountAccessDeniedGetAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountAccessDeniedGetWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public Response V1AccountChangePasswordPost(string oldPassword, string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public Task<Response> V1AccountChangePasswordPostAsync(string oldPassword, string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<Response>> V1AccountChangePasswordPostAsyncWithHttpInfo(string oldPassword, string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountChangePasswordPostWithHttpInfo(string oldPassword, string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountForgotPasswordPost(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public Task<Response> V1AccountForgotPasswordPostAsync(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<Response>> V1AccountForgotPasswordPostAsyncWithHttpInfo(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountForgotPasswordPostWithHttpInfo(ForgotPasswordDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ResponseGirafUserDTO V1AccountLoginPost(LoginDTO model = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseGirafUserDTO> V1AccountLoginPostAsync(LoginDTO model = null)
        {
            ResponseGirafUserDTO result;

            if (model.Username == "Graatand" && model.Password == "password")
            {
                result = new ResponseGirafUserDTO
                {
                    Success = true,
                    ErrorKey = ResponseGirafUserDTO.ErrorKeyEnum.NoError,
                    Data = new GirafUserDTO
                    {
                        Username = "Graatand",
                        GuardianOf = new List<GirafUserDTO>
                        {
                            new GirafUserDTO { Username = "Kurt"},
                            new GirafUserDTO { Username = "Søren"},
                            new GirafUserDTO { Username = "Elisabeth"},
                            new GirafUserDTO { Username = "Ulrik"},
                            new GirafUserDTO { Username = "Thomas"},
                            new GirafUserDTO { Username = "Elise"},
                            new GirafUserDTO { Username = "Maria"},
                        },
                    },
                };
            }
            else
            {
                result = new ResponseGirafUserDTO
                {
                    Success = false,
                    ErrorKey = ResponseGirafUserDTO.ErrorKeyEnum.InvalidCredentials,
                };
            }
            return Task.FromResult(result);
        }

        public Task<ApiResponse<ResponseGirafUserDTO>> V1AccountLoginPostAsyncWithHttpInfo(LoginDTO model = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1AccountLoginPostWithHttpInfo(LoginDTO model = null)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountLogoutPost()
        {
            throw new NotImplementedException();
        }

        public Task<Response> V1AccountLogoutPostAsync()
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<Response>> V1AccountLogoutPostAsyncWithHttpInfo()
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

        public Task<ResponseGirafUserDTO> V1AccountRegisterPostAsync(RegisterDTO model = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseGirafUserDTO>> V1AccountRegisterPostAsyncWithHttpInfo(RegisterDTO model = null)
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

        public Task V1AccountResetPasswordConfirmationGetAsync()
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<object>> V1AccountResetPasswordConfirmationGetAsyncWithHttpInfo()
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

        public Task V1AccountResetPasswordGetAsync(string code = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<object>> V1AccountResetPasswordGetAsyncWithHttpInfo(string code = null)
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

        public Task V1AccountResetPasswordPostAsync(string username, string password, string confirmPassword, string code = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<object>> V1AccountResetPasswordPostAsyncWithHttpInfo(string username, string password, string confirmPassword, string code = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1AccountResetPasswordPostWithHttpInfo(string username, string password, string confirmPassword, string code = null)
        {
            throw new NotImplementedException();
        }

        public Response V1AccountSetPasswordPost(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public Task<Response> V1AccountSetPasswordPostAsync(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<Response>> V1AccountSetPasswordPostAsyncWithHttpInfo(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1AccountSetPasswordPostWithHttpInfo(string newPassword, string confirmPassword = null)
        {
            throw new NotImplementedException();
        }
    }
}
