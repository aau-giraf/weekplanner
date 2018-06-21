using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ChooseCitizenViewModel : ViewModelBase
    {
        private ObservableCollection<UserNameDTO> _citizenNames;
        private readonly IDepartmentApi _departmentApi;
	    private readonly IRequestService _requestService;
	    private readonly ISettingsService _settingsService;
	    
	    
	    public ObservableCollection<UserNameDTO> CitizenNames {
		    get => _citizenNames;
		    set {
			    _citizenNames = value;
			    RaisePropertyChanged(() => CitizenNames);
		    }
	    }

        public ChooseCitizenViewModel(INavigationService navigationService, IDepartmentApi departmentApi, 
	        IRequestService requestService, ISettingsService settingsService) : base(navigationService)
        {
	        _departmentApi = departmentApi;
	        _requestService = requestService;
	        _settingsService = settingsService;
        }

	    public ICommand ChooseCitizenCommand => new Command<UserNameDTO>(async usernameDTO =>
		    await NavigateToCitizenSchedules(usernameDTO));
	    
	    private async Task NavigateToCitizenSchedules(UserNameDTO usernameDTO)
	    {
		    if (IsBusy) return;
		    IsBusy = true;
            await NavigationService.NavigateToAsync<CitizenSchedulesViewModel>(usernameDTO);
		    IsBusy = false;
	    }
	    
	    private async Task GetAndSetCitizenNamesAsync()
	    {
		    await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _departmentApi.V1DepartmentByIdCitizensGetAsync(_settingsService.DepartmentId),
			    onSuccess: r);
	    }

	    private void r(ResponseListUserNameDTO resp)
	    {
		    CitizenNames = new ObservableCollection<UserNameDTO>(resp.Data.OrderBy(x => x.UserName));
	    }

	    public override async Task OnReturnedToAsync(object navigationData)
	    {
		    _settingsService.CurrentCitizen = null;
		    _settingsService.CurrentCitizenSettingDTO = null;
		    _settingsService.SetTheme(true);
	    }

	    public override async Task InitializeAsync(object navigationData)
	    {
		    await GetAndSetCitizenNamesAsync();
	    }
    }

}
