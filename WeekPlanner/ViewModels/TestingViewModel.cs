using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class TestingViewModel : ViewModelBase
    {
        public TestingViewModel(INavigationService navigationService) : base(navigationService)
        {
        }

        public ICommand NavigateToLoginCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<LoginViewModel>());

        public ICommand NavigateToChooseCitizenCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<ChooseCitizenViewModel>());

        public ICommand NavigateToWeekPlannerCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<WeekPlannerViewModel>());


    }
}
