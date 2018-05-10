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
		    await UseGuardianTokenAndNavigateToWeekPlan(usernameDTO));

	    private async Task UseGuardianTokenAndNavigateToWeekPlan(UserNameDTO usernameDTO)
	    {
		    if (IsBusy) return;
		    IsBusy = true;
		    _settingsService.UseTokenFor(UserType.Guardian);
		    await NavigationService.NavigateToAsync<CitizenSchedulesViewModel>(usernameDTO);
		    IsBusy = false;
	    }

	    private async Task GetAndSetCitizenNamesAsync()
	    {
		    // Always use the departmentToken when coming to this view.
		    // It might have been changed to using the citizenToken
            _settingsService.UseTokenFor(UserType.Guardian);

            //TODO Legacy from we had ChooseDepartment
            // We need to refactor so we don't need the ID
            var departmentId = 1;

		    await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _departmentApi.V1DepartmentByIdCitizensGetAsync(departmentId),
			    onSuccess: result => {
					result.Data.OrderBy(x => x.UserName);
					CitizenNames = new ObservableCollection<UserNameDTO>(result.Data);
				});
	    }

	    public override async Task InitializeAsync(object navigationData)
	    {
		    await GetAndSetCitizenNamesAsync();
	    }
    }

}
