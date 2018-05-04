using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using Xamarin.Forms;
using WeekPlanner.ViewModels.Base;
using System;
using IO.Swagger.Model;
using System.Threading.Tasks;
using WeekPlanner.Services.Settings;
using WeekPlanner.Services.Login;

namespace WeekPlanner.ViewModels
{
    class MasterViewModel : ViewModelBase
    {
		public ISettingsService SettingsService { get; }
		private readonly ILoginService _loginService;

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

		public MasterViewModel(ISettingsService settingsService, INavigationService navigationService, ILoginService loginService) : base(navigationService)
		{
			SettingsService = settingsService;
			_loginService = loginService;
		}

		public override async Task InitializeAsync(object navigationData)
		{
			if (navigationData is UserNameDTO userNameDTO)
			{
				await _loginService.LoginAndThenAsync(UserType.Citizen,
					userNameDTO.UserName, "", () => InitializeCitizen(userNameDTO));
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
