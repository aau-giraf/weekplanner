using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using Xamarin.Forms;
using WeekPlanner.ViewModels.Base;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.ViewModels
{
    public class MasterViewModel : ViewModelBase
    {
		public ISettingsService SettingsService { get; }

		public MasterViewModel(ISettingsService settingsService, INavigationService navigationService) : base(navigationService)
		{
			SettingsService = settingsService;
		}

		public ICommand NavigateToSettingsCommand => new Command(NavigateToSettingsAndHideMaster);

	    private async void NavigateToSettingsAndHideMaster()
	    {
		    if (IsBusy) return;

		    IsBusy = true;
		    
		    MessagingCenter.Send(this, MessageKeys.HideMasterPage);
		    
		    if (NavigationService.CurrentPageViewModel is SettingsViewModel)
		    {
			    IsBusy = false;
			    return;
		    }
		    
		    await NavigationService.NavigateToAsync<SettingsViewModel>();
		    
		    IsBusy = false;
	    }
    }
}
