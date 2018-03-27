using System.Collections.ObjectModel;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
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
        
        public TestingViewModel(INavigationService navigationService, IDepartmentApi departmentApi,
        ILoginService loginService) : base(navigationService)
        {
            _departmentApi = departmentApi;
            _loginService = loginService;
        }

        public ICommand NavigateToLoginCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<LoginViewModel>());

        public ICommand NavigateToChooseCitizenCommand =>
            new Command(async () =>
            {
                await _loginService.LoginAndThenAsync(async () => 
                        await NavigationService.NavigateToAsync<ChooseCitizenViewModel>(
                            (await _departmentApi.V1DepartmentByIdCitizensGetAsync(1)).Data),
                    UserType.Department, "Graatand", "password");
            });

        public ICommand NavigateToWeekPlannerCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<WeekPlannerViewModel>(new UserNameDTO("Kurt", "KurtId")));
        
        public ICommand NavigateToChooseTemplateCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<ChooseTemplateViewModel>());


    }
}
