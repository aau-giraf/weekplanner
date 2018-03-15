using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Services.Mocks;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    class UserModeSwitchViewModel : ViewModelBase
    {

        private GirafUserDTO _citizen;
        public enum UserMode { Guardian, Citizen };
        private UserMode _userMode;
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

        

        public UserModeSwitchViewModel()
        {
            Mode = UserMode.Guardian;
        }

        public ICommand SwitchUserModeCommand => new Command(() => SwitchUserMode());

        private void SwitchUserMode()
        {
            if (_userMode == UserMode.Guardian)
            {
                Mode = UserMode.Citizen;

            }
            else
            {
                Mode = UserMode.Guardian;
            }
        }
    }
}
