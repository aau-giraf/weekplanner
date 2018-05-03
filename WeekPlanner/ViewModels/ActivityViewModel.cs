using System;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using IO.Swagger.Api;
using WeekPlanner.Helpers;
using static IO.Swagger.Model.ActivityDTO;

namespace WeekPlanner.ViewModels
{
    public class ActivityViewModel : ViewModelBase
    {
        private ActivityDTO _activity;
        private bool _isGuardianMode = true;
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
                RaisePropertyChanged(() => State);
                RaisePropertyChanged(() => FriendlyStateString);
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
                case StateEnum.Active:
                    State = StateEnum.Completed;
                    break;
                case StateEnum.Completed:
                    State = StateEnum.Canceled;
                    break;
                case StateEnum.Canceled:
                    State = StateEnum.Active;
                    break;
            }
        });

        private void ChangePicto(WeekPictogramDTO weekPictogram)
        {
            Activity.Pictogram = weekPictogram;
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

        public StateEnum State
        {
            get 
            {
                if(Activity == null) {
                    return StateEnum.Active;
                }
                return (StateEnum)Activity.State;
            }
            set
            {
                Activity.State = value;
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
                    case StateEnum.Active:
                        return "Normal";
                    case StateEnum.Completed:
                        return "Udført";
                    case StateEnum.Canceled:
                        return "Aflyst";
                    default:
                        return State.ToString();
                }
            }
        }

        public ICommand ToggleGuardianMode => new Command(() => IsGuardianMode = !IsGuardianMode);
        public ICommand SaveCommand => new Command(async () =>
        {
            await NavigationService.PopAsync(this);
        });

        public override async Task PoppedAsync(object navigationData) {
            if (navigationData is PictogramDTO newPicto) {
                WeekPictogramDTO newWeekPicto = Convert(newPicto);
                Activity.Pictogram = newWeekPicto;
                RaisePropertyChanged(() => Activity);
            }
        }

        WeekPictogramDTO Convert(PictogramDTO picto) {
            return new WeekPictogramDTO
            {
                Id = picto.Id,
                AccessLevel = (WeekPictogramDTO.AccessLevelEnum)picto.AccessLevel,
                ImageHash = picto.ImageHash,
                ImageUrl = picto.ImageUrl,
                LastEdit = picto.LastEdit,
                Title = picto.Title,
            };
        }

    }
}