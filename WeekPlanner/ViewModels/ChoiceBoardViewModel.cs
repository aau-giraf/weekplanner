using IO.Swagger.Api;
using IO.Swagger.Model;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Settings;
using WeekPlanner.Services;
using static IO.Swagger.Model.ActivityDTO;
using System.Linq;

namespace WeekPlanner.ViewModels
{
    public class ChoiceBoardViewModel : ViewModelBase
    {
        private readonly IRequestService _requestService;
        private readonly IDialogService _dialogService;
        private readonly IWeekApi _weekApi;
        private readonly ILoginService _loginService;
        public ISettingsService SettingsService { get; }

        private int? _order;
        private ObservableCollection<ActivityDTO> _activityDTOs = new ObservableCollection<ActivityDTO>();
        public ObservableCollection<ActivityDTO> ActivityDTOs
        {
            get => _activityDTOs;
            set
            {
                _activityDTOs = value;
                RaisePropertyChanged(() => ActivityDTOs);
            }
        }

        public bool IsInCitizenMode
        {
            get => !SettingsService.IsInGuardianMode;
        }

        public ICommand FlowItemDeletedCommand => new Command((tappedItem) =>
        {
            if (tappedItem is ActivityDTO tapped && SettingsService.IsInGuardianMode)
            {
                ActivityDTOs.Remove(tapped);
            }
        });

        public ICommand FlowItemTappedCommand => new Command(async (tappedItem) =>
        {
            if (!SettingsService.IsInGuardianMode && tappedItem is ActivityDTO item)
            {
                await NavigationService.PopAsync(new ObservableCollection<ActivityDTO> { item });
            }
        });

        public ICommand SaveChoiceCommand => new Command(() => SaveChoiceBoard());

        public ICommand DeleteActivityCommand => new Command(() => NavigationService.PopAsync(new ObservableCollection<ActivityDTO>()));


        public ICommand AddActivityCommand => new Command(async () => await NavigationService.NavigateToAsync<PictogramSearchViewModel>());

        public ChoiceBoardViewModel(INavigationService navigationService, IRequestService requestService,
            IDialogService dialogService, IWeekApi weekApi, ILoginService loginService,
            ISettingsService settingsService) : base(navigationService)
        {
            _requestService = requestService;
            _dialogService = dialogService;
            _weekApi = weekApi;
            _loginService = loginService;
            SettingsService = settingsService;
        }


        private void InsertPicto(WeekPictogramDTO weekPictogramDTO)
        {
            ActivityDTOs.Add(new ActivityDTO(weekPictogramDTO, _order, StateEnum.Normal));
        }

        private void SaveChoiceBoard()
        {
            NavigationService.PopAsync(ActivityDTOs);
        }

        public override async Task PoppedAsync(object navigationData)
        {
            // Happens after choosing a pictogram in Pictosearch
            if (navigationData is WeekPictogramDTO weekPictogramDTO)
            {
                InsertPicto(weekPictogramDTO);
            }
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is ActivityDTO activity)
            {
                _order = activity.Order;
                ActivityDTOs.Add(activity);
                await NavigationService.RemoveLastFromBackStackAsync();
            }
            else if (navigationData is List<ActivityDTO> activities)
            {
                _order = activities.First().Order;

                foreach (var acti in activities)
                {
                    ActivityDTOs.Add(acti);
                }
            }
        }
    }
}
