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
        private readonly IUserApi _userApi;
        
        public LoginService(IAccountApi accountApi, IRequestService requestService, ISettingsService settingsService,
            IUserApi userApi)
        {
            _accountApi = accountApi;
            _requestService = requestService;
            _settingsService = settingsService;
            _userApi = userApi;
        }

        /// <summary>
        ///  Login async and sets authentication tokens
        /// </summary>
        /// <param name="userType"></param>
        /// <param name="username"></param>
        /// <param name="password">Provide for Departments, but not Citizens</param>
        /// <param name="onSuccess">An Func<Task> to be performed after succesfully logging in</param>
        /// <exception cref="ArgumentException"></exception>
        public async Task LoginAndThenAsync(UserType userType, string username, string password, Func<Task> onSuccess = null)
        {
            if (userType == UserType.Guardian && string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("A password should always be provided for Departments.");
            }

            async Task OnRequestSuccess(ResponseString result)
            {
                _settingsService.AuthToken = result.Data;

                await GetCitizenAndSetInSettings();
                
                if (onSuccess != null)
                {
                    await onSuccess.Invoke();
                }
            }

            await _requestService.SendRequestAndThenAsync(
                () => _accountApi.V1AccountLoginPostAsync(new LoginDTO(username, password)),
                OnRequestSuccess);
            
        }

        public async Task LoginAsync(UserType userType, string username, string password = "")
            => await LoginAndThenAsync(userType, username, password);

        private Task GetCitizenAndSetInSettings()
        {
            return _requestService.SendRequestAndThenAsync(() => _userApi.V1UserGetAsync(),
                dto =>
                {
                    _settingsService.DepartmentId = (long)dto.Data.Department;

                    if(dto.Data.Role == GirafUserDTO.RoleEnum.Guardian) {
                        _settingsService.IsInGuardianMode = true;
                        // Don't set current citizen if Guardian since we don't want their settings
                        return;
                    }
                    
                    _settingsService.CurrentCitizen = new UserNameDTO { 
                        UserId = dto.Data.Id, 
                        UserName = dto.Data.Username, 
                        UserRole = (UserNameDTO.UserRoleEnum?)dto.Data.Role 
                    };
                });
        }
    }
}