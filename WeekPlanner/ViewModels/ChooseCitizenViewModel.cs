using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ChooseCitizenViewModel : ViewModelBase
    {
        private ObservableCollection<GirafUserDTO> _citizens;
        public ObservableCollection<GirafUserDTO> Citizens { 
            get => _citizens;
            set { RaisePropertyChanged(() => Citizens); 
                _citizens = value; }
        }
        public string Username { get; set; }

	    public ICommand ChooseCitizenCommand => new Command<GirafUserDTO>(async citizen =>
		    await NavigationService.NavigateToAsync<WeekPlannerViewModel>(citizen));
	    
        public ChooseCitizenViewModel()
        {
	        Citizens = new ObservableCollection<GirafUserDTO>();
        }

		public override Task InitializeAsync(object navigationData)
		{
			if (navigationData is IEnumerable<GirafUserDTO> dtos)
			{
				Citizens = new ObservableCollection<GirafUserDTO>(dtos);
			}
            return Task.Delay(1);
		}
	}
}
