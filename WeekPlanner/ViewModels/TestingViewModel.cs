using System.Windows.Input;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class TestingViewModel : ViewModelBase
    {
        
        public ICommand NavigateToLoginCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<LoginViewModel>());

        public ICommand NavigateToChooseCitizenCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<ChooseCitizenViewModel>());

        public ICommand NavigateToWeekPlannerCommand =>
            new Command(async () => await NavigationService.NavigateToAsync<WeekPlannerViewModel>());

		public ICommand NavigateToUserModeSwitchCommand =>
			new Command(async () => await NavigationService.NavigateToAsync<UserModeSwitchViewModel>());


	}
}
