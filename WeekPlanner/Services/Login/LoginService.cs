using System;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Services.Login
{
    public class LoginService : ILoginService
    {
        private readonly IAccountApi _accountApi;
        private readonly ISettingsService _settingsService;
        
        public LoginService(IAccountApi accountApi, ISettingsService settingsService)
        {
            _accountApi = accountApi;
            _settingsService = settingsService;
        }

        /// <summary>
        ///  Login async and sets authentication tokens
        /// </summary>
        /// <param name="onSuccess">An Func<Task> to be performed after succesfully logging in</param>
        /// <param name="userType"></param>
        /// <param name="username"></param>
        /// <param name="password">Provide for Departments, but not Citizens</param>
        /// <returns>Sends a LoginFailed or LoginSucceed message through MessagingCenter</returns>
        /// <exception cref="ArgumentException"></exception>
        public async Task LoginAndThenAsync(Func<Task> onSuccess, UserType userType, string username, string password)
        {
            if (userType == UserType.Department && string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("A password should always be provided for Departments.");
            }
            
            ResponseString result;
            try
            {
                var loginDTO = new LoginDTO(username, password);
                result = await _accountApi.V1AccountLoginPostAsync(loginDTO);
            }
            catch (ApiException)
            {
                var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseString.ErrorKeyEnum.Error);
                MessagingCenter.Send(this, MessageKeys.LoginFailed, friendlyErrorMessage);
                return;
            }

            if (result?.Success == true)
            {
                if(userType == UserType.Citizen)
                {
                    _settingsService.CitizenAuthToken = result.Data;
                }
                else // Department
                {
                    _settingsService.DepartmentAuthToken = result.Data;
                }

                _settingsService.UseTokenFor(userType);
                
                await onSuccess.Invoke();
            }
            else
            {
                var friendlyErrorMessage = result?.ErrorKey.ToFriendlyString();
                MessagingCenter.Send(this, MessageKeys.LoginFailed, friendlyErrorMessage);
            }
        }
    }
}