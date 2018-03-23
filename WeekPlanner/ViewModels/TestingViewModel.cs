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
        
        public TestingViewModel(INavigationService navigationService, IAccountApi accountApi) : base(navigationService)
        {
            _accountApi = accountApi;
        }

        public ICommand NavigateToLoginCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<LoginViewModel>());

        public ICommand NavigateToChooseCitizenCommand =>
            new Command(async () =>
            {
                // TODO: Fix TestingPage -> ChooseCitizenPage
                //var result = await _accountApi.V1AccountLoginPostAsync(new LoginDTO("Graatand", "password"));
                //await NavigationService.NavigateToAsync<ChooseCitizenViewModel>(result.Data.GuardianOf);
            });

        public ICommand NavigateToWeekPlannerCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<WeekPlannerViewModel>());
        
        public ICommand NavigateToChooseTemplateCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<ChooseTemplateViewModel>());


    }
}
