using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Services.Mocks;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class UserModeSwitchViewModel : ViewModelBase
    {
        public enum UserMode { Guardian, Citizen };

        private GirafUserDTO _citizen;
        private UserMode _userMode;
        public ICommand SwitchUserModeCommand => new Command(() => SwitchUserMode());
        public GirafUserDTO Citizen
        {
            get => _citizen;
            set
            {
                _citizen = value;
                RaisePropertyChanged(() => Citizen);
            }
        }

        public UserMode Mode
        {
            get => _userMode;
            set
            {
                _userMode = value;
                RaisePropertyChanged(() => Mode);
            }
        }

        public UserModeSwitchViewModel(INavigationService navigationService) : base(navigationService)
        {
            Mode = UserMode.Guardian;
        }

        

        private async Task SwitchUserMode()
        {
            //Mode = (Mode == UserMode.Guardian) ? UserMode.Citizen : UserMode.Guardian;

            if (Mode == UserMode.Guardian)
            {
                Mode = UserMode.Citizen;

            } else if(Mode == UserMode.Citizen)
            {
                await NavigationService.NavigateToAsync<LoginViewModel>(this);
                Mode = UserMode.Guardian;
            }

           
        }
    }
}
