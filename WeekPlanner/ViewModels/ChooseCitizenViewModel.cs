using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Mocks;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xamarin.Forms.Internals;

namespace WeekPlanner.ViewModels
{
    public class ChooseCitizenViewModel : ViewModelBase
    {
        private readonly IPictogramApi _pictogramApi;
        private ObservableCollection<UserNameDTO> _citizenNames;
        private readonly IDepartmentApi _departmentApi;
	    private readonly ISettingsService _settingsService;
	    
	    
	    public ObservableCollection<UserNameDTO> CitizenNames {
		    get => _citizenNames;
		    set {
			    _citizenNames = value;
			    RaisePropertyChanged(() => CitizenNames);
		    }
	    }

        public ChooseCitizenViewModel(INavigationService navigationService, 
	        IDepartmentApi departmentApi, ISettingsService settingsService) : base(navigationService)
        {
	        _departmentApi = departmentApi;
	        _settingsService = settingsService;
        }

	    public ICommand ChooseCitizenCommand => new Command<UserNameDTO>(async usernameDTO =>
		    await UseDepartmentTokenAndNavigateToWeekPlan(usernameDTO));

	    private async Task UseDepartmentTokenAndNavigateToWeekPlan(UserNameDTO usernameDTO)
	    {
		    _settingsService.UseTokenFor(UserType.Department);
		    await NavigationService.NavigateToAsync<WeekPlannerViewModel>(usernameDTO);
	    }

	    private async Task GetAndSetCitizenNamesAsync()
	    {
		    ResponseListUserNameDTO result;

		    // Always use the departmentToken when coming to this view.
		    // It might have been changed to using the citizenToken
            _settingsService.UseTokenFor(UserType.Department);

		    try
		    {
			    result = await _departmentApi.V1DepartmentByIdCitizensGetAsync(_settingsService.Department.Id);
		    }
		    catch (ApiException)
		    {
			    var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseString.ErrorKeyEnum.Error);
			    MessagingCenter.Send(this, MessageKeys.CitizenListRetrievalFailed, friendlyErrorMessage);
			    return;
		    }

		    if (result.Success == true)
		    {
			    CitizenNames = new ObservableCollection<UserNameDTO>(result.Data);
		    }
		    else
		    {
			    MessagingCenter.Send(this, MessageKeys.CitizenListRetrievalFailed, result.ErrorKey.ToFriendlyString());
		    }
	    }


	    public override async Task InitializeAsync(object navigationData)
	    {
		    await GetAndSetCitizenNamesAsync();
	    }
    }

}
