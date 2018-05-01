using System;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using IO.Swagger.Api;
using WeekPlanner.Helpers;

namespace WeekPlanner.ViewModels
{
    public enum State
    {
        Normal, Checked, Cancelled
    }


    public class ActivityViewModel : ViewModelBase
    {
        private ActivityDTO _activity;
        private bool _isGuardianMode = true;
        private State _state = State.Checked;
        readonly IPictogramApi _pictogramApi;

        public ActivityViewModel(INavigationService navigationService, IPictogramApi pictogramApi) : base(navigationService)
        {
            _pictogramApi = pictogramApi;
        }

        override public async Task InitializeAsync(object navigationData)
        {
            if (navigationData is ActivityDTO activity)
            {
                Activity = activity;
            }
        }

        public ActivityDTO Activity
        {
            get => _activity;
            set
            {
                _activity = value;
                RaisePropertyChanged(() => Activity);
            }
        }

        public ICommand ChangePictoCommand => new Command(async () =>
        {
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public ICommand DeleteActivityCommand => new Command(async () =>
        {
            Activity = null;
            await NavigationService.PopAsync(this);
        });

        public ICommand ToggleStateCommand => new Command(() =>
        {
            switch (State)
            {
                case State.Normal:
                    State = State.Checked;
                    break;
                case State.Checked:
                    State = State.Cancelled;
                    break;
                case State.Cancelled:
                    State = State.Normal;
                    break;
            }
        });

        private void ChangePicto(PictogramDTO pictogramDTO)
        {
            Activity.Pictogram = pictogramDTO;
        }

        public bool IsGuardianMode
        {
            get => _isGuardianMode;
            set
            {
                _isGuardianMode = value;
                RaisePropertyChanged(() => IsGuardianMode);
            }
        }

        public State State
        {
            get => _state;
            set
            {
                _state = value;
                RaisePropertyChanged(() => State);
                RaisePropertyChanged(() => FriendlyStateString);
            }
        }

        public string FriendlyStateString
        {
            get
            {
                switch (State)
                {
                    case State.Normal:
                        return "Normal";
                    case State.Checked:
                        return "Udført";
                    case State.Cancelled:
                        return "Aflyst";
                    default:
                        return State.ToString();
                }
            }
        }

        public ICommand ToggleGuardianMode => new Command(() => IsGuardianMode = !IsGuardianMode);
        public ICommand SaveCommand => new Command(async () =>
        {
            // TODO: error handling - use RequestService
            //await _pictogramApi.V1PictogramByIdPutAsync(pictogramDTO.Id, pictogramDTO);
        });

        public override async Task PoppedAsync(object navigationData) {
            if (navigationData is PictogramDTO newPicto) {
                Activity.Pictogram = newPicto;
                RaisePropertyChanged(() => Activity);
                await NavigationService.PopAsync(this);
            }
        }

    }
}