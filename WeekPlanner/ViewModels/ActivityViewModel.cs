using System;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using IO.Swagger.Api;

namespace WeekPlanner.ViewModels
{
    public enum State
    {
        Normal, Checked, Cancelled
    }


    public class ActivityViewModel : ViewModelBase
    {
        private string _imageSource;
        private bool _isGuardianMode = true;
        private State _state = State.Checked;
        readonly IPictogramApi _pictogramApi;

        public ActivityViewModel(INavigationService navigationService, IPictogramApi pictogramApi) : base(navigationService)
        {
            _pictogramApi = pictogramApi;
        }

        override public async Task InitializeAsync(object navigationData)
        {
            if (navigationData is string imgUrl)
            {
                ImageSource = imgUrl;
            }
        }

        public string ImageSource
        {
            get => _imageSource;
            set
            {
                _imageSource = value;
                RaisePropertyChanged(() => ImageSource);
            }
        }

        public ICommand ChangePictoCommand => new Command(async () =>
        {
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

        public ICommand DeleteActivityCommand => new Command(async () =>
        {
            // TODO: send message delete with resource.Id
            int activityID = 42;
            MessagingCenter.Send(this, MessageKeys.DeleteActivity, activityID);
            await NavigationService.PopAsync();
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

        private void ChangePicto(PictogramSearchViewModel pictoVM, PictogramDTO pictogramDTO)
        {
            ImageSource = pictogramDTO.ImageUrl;
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

        // TODO: Replace with real model when backend is updated
        private PictogramDTO pictogramDTO;

        public ICommand ToggleGuardianMode => new Command(() => IsGuardianMode = !IsGuardianMode);
        public ICommand SaveCommand => new Command(async () =>
        {
            // TODO: error handling - use RequestService
            await _pictogramApi.V1PictogramByIdPutAsync(pictogramDTO.Id, pictogramDTO);
        });

        public override void Popped(object navigationData) {
            if (navigationData is PictogramDTO newPicto) {
                pictogramDTO = newPicto;
                ImageSource = GlobalSettings.Instance.BaseEndpoint + newPicto.ImageUrl;
            }
        }

    }
}