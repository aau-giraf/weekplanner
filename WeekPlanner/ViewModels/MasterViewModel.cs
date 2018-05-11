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
        bool _isPresented;

        public bool IsPresented
        {
            get => _isPresented;
            set
            {
                _isPresented = value;
                RaisePropertyChanged(() => IsPresented);
            }
        }

        public ICommand NavigateToSettingsCommand => new Command(NavigateToSettingsAndHideMaster);

	    private async void NavigateToSettingsAndHideMaster()
	    {
		    if (IsBusy) return;

		    IsBusy = true;
            IsPresented = false;		    
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
