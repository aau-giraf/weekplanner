using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using WeekPlanner.Views;
using Xamarin.Forms;
using static IO.Swagger.Model.WeekdayDTO;
using WeekPlanner.Services;
using WeekPlanner.Helpers;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private readonly ILoginService _loginService;
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;
        private readonly IDialogService _dialogService;
        private readonly ISettingsService _settingsService;
        
        private ActivityDTO _selectedActivity;
        private bool _editModeEnabled;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _userModeImage;

        public bool EditModeEnabled
        {
            get => _editModeEnabled;
            set
            {
                _editModeEnabled = value;
                RaisePropertyChanged(() => EditModeEnabled);
            }
        }

        public WeekDTO WeekDTO
        {
            get => _weekDto;
            set
            {
                _weekDto = value;
                RaisePropertyChanged(() => WeekDTO);
                RaisePropertyForDays();
            }
        }

        public ImageSource UserModeImage
        {
            get => _userModeImage;
            set
            {
                _userModeImage = value;
                RaisePropertyChanged(() => UserModeImage);
            }
        }

        public ICommand ToggleEditModeCommand => new Command(async () => await SwitchUserModeAsync());

        public ICommand SaveCommand => new Command(async () => await SaveSchedule());
        public ICommand OnBackButtonPressedCommand => new Command(async () => await BackButtonPressed());

        public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
        {
            if (IsBusy) return;
            IsBusy = true;
            _weekdayToAddPictogramTo = weekday;
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
            IsBusy = false;
        });

        public ICommand PictoClickedCommand => new Command<ActivityDTO>(async activity =>
        {
            if (IsBusy) return;
            IsBusy = true;
            if (_editModeEnabled)
            {
                _selectedActivity = activity;
                await NavigationService.NavigateToAsync<ActivityViewModel>(activity);
            }

            IsBusy = false;
        });
                                                                    
        public WeekPlannerViewModel(
            INavigationService navigationService, 
            ILoginService loginService, 
            IRequestService requestService, 
            IWeekApi weekApi, 
            IDialogService dialogService, 
            ISettingsService settingsService) 
            : base(navigationService)
        {
            _requestService = requestService;
            _weekApi = weekApi;
            _dialogService = dialogService;
            _loginService = loginService;
            _requestService = requestService;
            _settingsService = settingsService;

            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
            MessagingCenter.Subscribe<LoginViewModel>(this, MessageKeys.LoginSucceeded, (sender) => SetToGuardianMode());
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is long weekId)
            {
                await GetWeekPlanForCitizenAsync(weekId);
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }

        // TODO: Handle situation where no days exist
        private async Task GetWeekPlanForCitizenAsync(long weekId)
        {

            _settingsService.UseTokenFor(UserType.Citizen);

            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1WeekByIdGetAsync(weekId),
                onSuccess: result =>
                {
                    WeekDTO = result.Data;
                }
            );

            foreach (var days in WeekDTO.Days)
            {
                days.Activities = days.Activities.OrderBy(x => x.Order).ToList();
            }
        }

        private void InsertPicto(PictogramDTO pictogramDTO)
        {
            var dayToAddTo = WeekDTO.Days.FirstOrDefault(d => d.Day == _weekdayToAddPictogramTo);
            if (dayToAddTo != null)
            {
                // Insert pictogram in the very bottom of the day
                var newOrderInBottom = dayToAddTo.Activities.Max(d => d.Order) + 1;
                dayToAddTo.Activities.Add(new ActivityDTO(pictogramDTO, newOrderInBottom));
            }
            // TODO: Fix
            RaisePropertyForDays();
        }


        private async Task SaveSchedule()
        {
            if (IsBusy) return;

            IsBusy = true;
            bool confirmed = await _dialogService.ConfirmAsync(
                title: "Gem ugeplan",
                message: "Vil du gemme ugeplanen?",
                okText: "Gem",
                cancelText: "Annuller");

            if (!confirmed)
            {
                return;
            }
            
            _settingsService.UseTokenFor(UserType.Citizen);
            
            if (WeekDTO.Id is null)
            {
                await SaveNewSchedule();
            }
            else
            {
                await UpdateExistingSchedule();
            }

            IsBusy = false;
        }

        private async Task SaveNewSchedule()
        {
            await _requestService.SendRequestAndThenAsync(
                () => _weekApi.V1WeekPostAsync(WeekDTO), result =>
                {
                    _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
                });
        }

        private async Task UpdateExistingSchedule()
        {
            if (WeekDTO.Id == null)
            {
                throw new InvalidDataException("WeekDTO should always have an Id when updating.");
            }

            await _requestService.SendRequestAndThenAsync(
                () => _weekApi.V1WeekByIdPutAsync(WeekDTO.Id, WeekDTO),
                result =>
                {
                    _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev gemt.");
                });
        }

        public override async Task PoppedAsync(object navigationData)
        {
            // Happens after choosing a pictogram in Pictosearch
            if (navigationData is PictogramDTO pictogramDTO)
            {
                InsertPicto(pictogramDTO);
            }

            // Happens when popping from ActivityViewModel
            if(navigationData is ActivityViewModel activityVM) {
                
                if(activityVM.Activity == null) {
                    // TODO this is dumb and it may remove duplicate elements since all elements are not unique
                    // we can refactor when ActivityDTO gets a unique ID
                    RemoveItemFromDay(DayEnum.Monday);
                    RemoveItemFromDay(DayEnum.Tuesday);
                    RemoveItemFromDay(DayEnum.Wednesday);
                    RemoveItemFromDay(DayEnum.Thursday);
                    RemoveItemFromDay(DayEnum.Friday);
                    RemoveItemFromDay(DayEnum.Saturday);
                    RemoveItemFromDay(DayEnum.Sunday);
                } else {
                    _selectedActivity = activityVM.Activity;
                }

                RaisePropertyForDays();
            }

            // Happens after logging in as guardian when switching to guardian mode
            if (navigationData is bool enterGuardianMode)
            {
                SetToGuardianMode();
            }
        }

        private bool RemoveItemFromDay(DayEnum day) {
            var a = WeekDTO.Days.First(x => x.Day == day).Activities;
            if (a.Count == 0) {
                return false;
            }
            return a.Remove(_selectedActivity);
        }

        private async Task SwitchUserModeAsync()
        {
            if (IsBusy) return;

            IsBusy = true;
            if (EditModeEnabled)
            {
                var result = await _dialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?", "Annuller", null, "Gem ændringer", "Gem ikke");

                switch (result)
                {
                    case "Annuller":
                        IsBusy = false;
                        break;

                    case "Gem ændringer":
                        EditModeEnabled = false;
                        await SaveSchedule();
                        UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
                        IsBusy = false;
                        break;

                    case "Gem ikke":
                        EditModeEnabled = false;
                        UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
                        if (WeekDTO.Id != null) await GetWeekPlanForCitizenAsync((long) WeekDTO.Id);
                        IsBusy = false;
                        break;
                }
                
            }
            else
            {
                await NavigationService.NavigateToAsync<LoginViewModel>(this);
            }
            IsBusy = false;
        }

        public int Height
        {
            get 
            {
                int minimumHeight = 1500;
                int elementHeight = 250;

                if(WeekDTO == null){
                    return minimumHeight;
                }

                int dynamicHeight = WeekDTO.Days.Max(d => d.Activities.Count) * elementHeight;

                return dynamicHeight > minimumHeight ? dynamicHeight : minimumHeight; 
            }
        }

        private void SetToGuardianMode()
        {
            EditModeEnabled = true;
            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
        }

        private async Task BackButtonPressed()
        {
            if (IsBusy) return;

            IsBusy = true;
            if (EditModeEnabled)
            {
                var result = await _dialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?", "Annuller", null, "Gem ændringer", "Gem ikke");

                switch (result)
                {
                    case "Annuller":
                        IsBusy = false;
                        break;

                    case "Gem ændringer":
                        await SaveSchedule();
                        await NavigationService.PopAsync();
                        IsBusy = false;
                        break;

                    case "Gem ikke":
                        await NavigationService.PopAsync();
                        IsBusy = false;
                        break;
                }
            }
        }

        // TODO: Override the navigation bar backbutton when this is available.
        // Will most likely only be available if/when the custom navigation bar gets implemented.
        

        public ObservableCollection<ActivityDTO> MondayPictos => GetPictosOrEmptyList(DayEnum.Monday);
        public ObservableCollection<ActivityDTO> TuesdayPictos => GetPictosOrEmptyList(DayEnum.Tuesday);
        public ObservableCollection<ActivityDTO> WednesdayPictos => GetPictosOrEmptyList(DayEnum.Wednesday);
        public ObservableCollection<ActivityDTO> ThursdayPictos => GetPictosOrEmptyList(DayEnum.Thursday);
        public ObservableCollection<ActivityDTO> FridayPictos => GetPictosOrEmptyList(DayEnum.Friday);
        public ObservableCollection<ActivityDTO> SaturdayPictos => GetPictosOrEmptyList(DayEnum.Saturday);
        public ObservableCollection<ActivityDTO> SundayPictos => GetPictosOrEmptyList(DayEnum.Sunday);

        private ObservableCollection<ActivityDTO> GetPictosOrEmptyList(DayEnum dayEnum)
        {
            var day = WeekDTO?.Days.FirstOrDefault(x => x.Day == dayEnum);
            if (day == null)
            {
                return new ObservableCollection<ActivityDTO>();
            }

            return new ObservableCollection<ActivityDTO>(day.Activities);
        }


        private void RaisePropertyForDays() {
            RaisePropertyChanged(() => MondayPictos);
            RaisePropertyChanged(() => TuesdayPictos);
            RaisePropertyChanged(() => WednesdayPictos);
            RaisePropertyChanged(() => ThursdayPictos);
            RaisePropertyChanged(() => FridayPictos);
            RaisePropertyChanged(() => SaturdayPictos);
            RaisePropertyChanged(() => SundayPictos);
            RaisePropertyChanged(() => Height);
        }

    }
}
