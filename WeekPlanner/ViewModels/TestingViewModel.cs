using System.Collections.ObjectModel;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class TestingViewModel : ViewModelBase
    {

        private readonly IAccountApi _accountApi;
        private readonly IDepartmentApi _departmentApi;
        
        public TestingViewModel(INavigationService navigationService, IAccountApi accountApi, 
            IDepartmentApi departmentApi) : base(navigationService)
        {
            _accountApi = accountApi;
            _departmentApi = departmentApi;
        }

        public ICommand NavigateToLoginCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<LoginViewModel>());

        public ICommand NavigateToChooseCitizenCommand =>
            new Command(async () =>
            {
                var result = await _departmentApi.V1DepartmentByIdCitizensGetAsync(1);
                await NavigationService.NavigateToAsync<ChooseCitizenViewModel>(result);
            });

        public ICommand NavigateToWeekPlannerCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<WeekPlannerViewModel>());
        
        public ICommand NavigateToChooseTemplateCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<ChooseTemplateViewModel>());


    }
}
