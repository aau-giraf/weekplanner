using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.ApplicationObjects;
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
	    
	    public ObservableCollection<UserNameDTO> CitizenNames {
		    get => _citizenNames;
		    set {
			    _citizenNames = value;
			    RaisePropertyChanged(() => CitizenNames);
		    }
	    }

        public ChooseCitizenViewModel(INavigationService navigationService) : base(navigationService)
        {
        }

	    public ICommand ChooseCitizenCommand => new Command<GirafUserDTO>(async citizen =>
		    await NavigationService.NavigateToAsync<WeekPlannerViewModel>(citizen));

		public override async Task InitializeAsync(object navigationData)
		{
			if (navigationData is ResponseListUserNameDTO dto)
			{
				CitizenNames = new ObservableCollection<UserNameDTO>(dto.Data);
			}
			else
			{
				throw new ArgumentException("Must be of type ResponseListUserNameDTO", nameof(navigationData));
			}
		}
	}
}
