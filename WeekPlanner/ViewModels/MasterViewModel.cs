using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using Xamarin.Forms;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.ViewModels
{
    class MasterViewModel : ViewModelBase
    {

        public MasterViewModel(INavigationService navigationService) : base(navigationService)
        {
        }

        public ICommand NavigateToSettingsCommand =>
        new Command(async () => await NavigationService.NavigateToAsync<SettingsViewModel>());
    }
}
