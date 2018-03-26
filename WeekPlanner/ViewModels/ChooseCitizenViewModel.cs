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
        private ObservableCollection<UserNameDTO> _citizenNames;
	    private readonly IAccountApi _accountApi;
	    private readonly ISettingsService _settingsService;
	    private readonly IWeekApi _weekApi;

	    public ObservableCollection<UserNameDTO> CitizenNames {
		    get => _citizenNames;
		    set {
			    _citizenNames = value;
			    RaisePropertyChanged(() => CitizenNames);
		    }
	    }

        public ChooseCitizenViewModel(INavigationService navigationService, IAccountApi accountApi,
	        ISettingsService settingsService, IWeekApi weekApi) : base(navigationService)
        {
	        _accountApi = accountApi;
	        _settingsService = settingsService;
	        _weekApi = weekApi;
        }

	    public ICommand ChooseCitizenCommand => new Command<UserNameDTO>(async usernameDTO =>
		    await GetWeekPlanForCitizen(usernameDTO));

	    // TODO: Cleanup method and rename
	    private async Task GetWeekPlanForCitizen(UserNameDTO usernameDTO)
	    {
		    ResponseString result;
		    try
		    {
			    // TODO: Ask Backend for an endpoint that does not require password
			    result = await _accountApi.V1AccountLoginPostAsync(new LoginDTO(usernameDTO.UserName, "password"));
		    }
		    catch (ApiException e)
		    {
			    var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseString.ErrorKeyEnum.Error);
			    MessagingCenter.Send(this, MessageKeys.LoginFailed, friendlyErrorMessage);
			    return;
		    }

		    if (result.Success == true)
		    {
			    _settingsService.CitizenAuthToken = result.Data;
			    _settingsService.UseTokenFor(TokenType.Citizen);

			    ResponseWeekDTO weekDTO;
			    try
			    {
				    weekDTO = await _weekApi.V1WeekByIdGetAsync(1);
			    }
			    catch (ApiException )
			    {
				    Console.WriteLine("Failed to get weekplan");
				    return;
			    }

			    if (weekDTO.Success == true)
			    {
				    await NavigationService.NavigateToAsync<WeekPlannerViewModel>(weekDTO.Data);
			    }
		    }
		    
		    
	    }
	    
		public override async Task InitializeAsync(object navigationData)
		{
			if (navigationData is List<UserNameDTO> usernames)
			{
				CitizenNames = new ObservableCollection<UserNameDTO>(usernames);
			}
			else
			{
				throw new ArgumentException("Must be of type List<UserNameDTO>", nameof(navigationData));
			}
		}
	}
}
