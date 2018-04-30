using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using Xamarin.Forms;
using WeekPlanner.ViewModels.Base;
using System;
using IO.Swagger.Model;
using System.Threading.Tasks;
using WeekPlanner.Services.Settings;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Request;

namespace WeekPlanner.ViewModels
{
    class MasterViewModel : ViewModelBase
    {
		private readonly ISettingsService _settingsService;
		private readonly ILoginService _loginService;
		private readonly IRequestService _requestService;

		private UserNameDTO _girafCitizen;
		public UserNameDTO GirafCitizen
		{
			get => _girafCitizen;
			set
			{
				_girafCitizen = value;
				RaisePropertyChanged(() => GirafCitizen);
			}
		}

		public MasterViewModel(ISettingsService settingsService, INavigationService navigationService, ILoginService loginService, IRequestService requestService) : base(navigationService)
		{
			_settingsService = settingsService;
			_loginService = loginService;
			_requestService = requestService;

		}

		public override async Task InitializeAsync(object navigationData)
		{
			if (navigationData is UserNameDTO userNameDTO)
			{
				await _loginService.LoginAndThenAsync(() => InitializeCitizen(userNameDTO), UserType.Citizen,
					userNameDTO.UserName);
			}
			else
			{
				throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
			}
		}

		private async Task InitializeCitizen(UserNameDTO userNameDTO)
		{
			GirafCitizen = userNameDTO;
		}

		public ICommand NavigateToSettingsCommand =>
        new Command(async () => await NavigationService.NavigateToAsync<SettingsViewModel>(GirafCitizen));
    }
}
