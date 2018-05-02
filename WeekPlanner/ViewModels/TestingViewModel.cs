using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Acr.UserDialogs;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.Services;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class TestingViewModel : ViewModelBase
    {

        private readonly IDepartmentApi _departmentApi;
        private readonly ILoginService _loginService;
        private readonly ISettingsService _settingsService;
        private readonly IDialogService _dialogService;

        public TestingViewModel(INavigationService navigationService, IDepartmentApi departmentApi,
                                ILoginService loginService, ISettingsService settingsService, IDialogService dialogService) : base(navigationService)
        {
            _dialogService = dialogService;
            _departmentApi = departmentApi;
            _loginService = loginService;
            _settingsService = settingsService;
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserNameDTO userNameDTO)
            {
                await _loginService.LoginAsync(UserType.Citizen,
                    userNameDTO.UserName);
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }

        public ICommand NavigateToLoginCommand =>
            new Command(async () =>
            {
                await NavigationService.NavigateToAsync<LoginViewModel>();
            });

        public ICommand NavigateToChooseCitizenCommand =>
            new Command(() =>
            {
                _loginService.LoginAndThenAsync(
                    () => NavigationService.NavigateToAsync<ChooseCitizenViewModel>(),
                    UserType.Guardian, "Graatand", "password"
                );
            });

        public ICommand NavigateToWeekPlannerCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<WeekPlannerViewModel>(new UserNameDTO("Kurt", "KurtId")));

        public ICommand NavigateToChooseTemplateCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<ChooseTemplateViewModel>());

        public ICommand NavigateToPictogramSearchCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<PictogramSearchViewModel>());
        
        public ICommand NavigateToSettingsCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<SettingsViewModel>(new UserNameDTO("Kurt", "KurtId")));

        public ICommand NavigateToSavePromptCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<SavePromptViewModel>());
    }
}
