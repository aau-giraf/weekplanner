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
using WeekPlanner.Services.Settings;
using WeekPlanner.Services.Request;

namespace WeekPlanner.ViewModels
{
    public class ActivityViewModel : ViewModelBase
    {
        private ActivityDTO _activity;
        private readonly IRequestService _requestService;
        private readonly IPictogramApi _pictogramApi;

        public ISettingsService SettingsService { get; }

        public ActivityViewModel(INavigationService navigationService, 
                                 IPictogramApi pictogramApi,
                                 IRequestService requestService,
                                 ISettingsService settingsService) : base(navigationService)
        {
            SettingsService = settingsService;
            _requestService = requestService;
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

        public ICommand ChoiceBoardCommand => new Command(async () => await NavigationService.NavigateToAsync<ChoiceBoardViewModel>(Activity));

        public ICommand DeleteActivityCommand => new Command(async () =>
        {
            Activity = null;
            await NavigationService.PopAsync(this);
        });

        public ICommand ToggleStateCommand => new Command(() =>
        {
            switch (State)
            {
                case StateEnum.Normal:
                    State = StateEnum.Completed;
                    break;
                case StateEnum.Completed:
                    State = (SettingsService.IsInGuardianMode) ? StateEnum.Canceled : StateEnum.Active;
                    break;
                case StateEnum.Canceled:
                    State = StateEnum.Active;
                    break;
                case StateEnum.Active:
                    State = StateEnum.Normal;
                    break;
            }
        });

        private void ChangePicto(WeekPictogramDTO weekPictogram)
        {
            Activity.Pictogram = weekPictogram;
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
                    case StateEnum.Normal:
                        return "Normal";
                    case StateEnum.Active:
                        return "Aktiv";
                    case StateEnum.Completed:
                        return "Udført";
                    case StateEnum.Canceled:
                        return "Aflyst";
                    default:
                        return State.ToString();
                }
            }
        }

        public ICommand SaveCommand => new Command(async () =>
        {
            await NavigationService.PopAsync(this);
        });

        public override async Task OnReturnedToAsync(object navigationData) {
            if (navigationData is WeekPictogramDTO newWeekPicto) {
                Activity.Pictogram = newWeekPicto;

                RaisePropertyChanged(() => Activity);
            }
        }
    }
}