using System;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.ViewModels
{
    public class SettingsViewModel : ViewModelBase
    {
        private readonly ISettingsService _settingsService;
        private readonly ILoginService _loginService;

        public SettingsViewModel(ISettingsService settingsService, INavigationService navigationService, ILoginService loginService) : base(navigationService)
        {
            _settingsService = settingsService;
            _loginService = loginService;
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserNameDTO userNameDTO)
            {
                if(_settingsService.CitizenAuthToken == null && _settingsService.GuardianAuthToken == null)
                {
                    await _loginService.LoginAsync(UserType.Citizen,
                    userNameDTO.UserName);
                }
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }
    }
}
