using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Networking;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ChooseCitizenViewModel : ViewModelBase
    {
        private ObservableCollection<GirafUserDTO> _citizens;
        public ObservableCollection<GirafUserDTO> Citizens {
            get => _citizens;
            set {
                _citizens = value;
                RaisePropertyChanged(() => Citizens);
            }
        }

	    public ICommand ChooseCitizenCommand => new Command<GirafUserDTO>(async citizen =>
		    await NavigationService.NavigateToAsync<WeekPlannerViewModel>(citizen));

		public override async Task InitializeAsync(object navigationData)
		{
			if (navigationData is IEnumerable<GirafUserDTO> dtos)
			{
				Citizens = new ObservableCollection<GirafUserDTO>(dtos);
			} else if (GlobalSettings.Instance.UseMocks) {
                var service = new MockNetworkingService();
                var result = await service.SendLoginRequest("Graatand", "password");
			    Citizens = new ObservableCollection<GirafUserDTO>(result.Data.GuardianOf);
			}
		}
	}
}
