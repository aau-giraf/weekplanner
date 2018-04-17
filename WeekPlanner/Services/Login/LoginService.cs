using System;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.Services.Login
{
    public class LoginService : ILoginService
    {
        private readonly IAccountApi _accountApi;
        private readonly IRequestService _requestService;
        private readonly ISettingsService _settingsService;
        
        public LoginService(IAccountApi accountApi, IRequestService requestService, ISettingsService settingsService)
        {
            _accountApi = accountApi;
            _requestService = requestService;
            _settingsService = settingsService;
        }

        /// <summary>
        ///  Login async and sets authentication tokens
        /// </summary>
        /// <param name="onSuccess">An Func<Task> to be performed after succesfully logging in</param>
        /// <param name="userType"></param>
        /// <param name="username"></param>
        /// <param name="password">Provide for Departments, but not Citizens</param>
        /// <exception cref="ArgumentException"></exception>
        public async Task LoginAndThenAsync(Func<Task> onSuccess, UserType userType, string username, string password)
        {
            if (userType == UserType.Guardian && string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("A password should always be provided for Departments.");
            }

            async Task OnRequestSuccess(ResponseString result)
            {
                if (userType == UserType.Citizen)
                {
                    _settingsService.CitizenAuthToken = result.Data;
                }
                else // Guardian
                {
                    _settingsService.GuardianAuthToken = result.Data;
                }

                _settingsService.UseTokenFor(userType);

                await onSuccess.Invoke();
            }

            await _requestService.SendRequestAndThenAsync(this,
                async () => await _accountApi.V1AccountLoginPostAsync(new LoginDTO(username, password)),
                OnRequestSuccess);
        }

        public async Task LoginAsync( UserType userType, string username, string password)
        {
            if (userType == UserType.Department && string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("A password should always be provided for Departments.");
            }

            Task OnRequestSuccess(ResponseString result)
            {
                if (userType == UserType.Citizen)
                {
                    _settingsService.CitizenAuthToken = result.Data;
                }
                else // Department
                {
                    _settingsService.DepartmentAuthToken = result.Data;
                }

                _settingsService.UseTokenFor(userType);
                return Task.FromResult(false);
            }

            await _requestService.SendRequestAndThenAsync(this,
                async () => await _accountApi.V1AccountLoginPostAsync(new LoginDTO(username, password)),
                OnRequestSuccess);
        }
    }
}