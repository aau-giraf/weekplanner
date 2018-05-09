using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using static IO.Swagger.Model.WeekdayDTO;
using WeekPlanner.Services;
using WeekPlanner.Helpers;
using static IO.Swagger.Model.ActivityDTO;

namespace WeekPlanner.ViewModels
{
	public class WeekPlannerViewModel : ViewModelBase
    {
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;
        private readonly IDialogService _dialogService;
        public ISettingsService SettingsService { get; }
        private bool _isDirty = false;

        private ActivityDTO _selectedActivity;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _toolbarButtonIcon;

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

		private int _weekNameSetterCount = 0;
        private string _weekName;
        public string WeekName
        {
            get => _weekName;
            set
            {
                _weekName = WeekDTO.Name = value;
                RaisePropertyChanged(() => WeekName);
                            
                // Hack needed because initializeAsync and TwoWay-binding sets it
				if (_weekNameSetterCount >= 2)
                {
                    _isDirty = true;
                }
				_weekNameSetterCount++;
            }
        }

        public ImageSource ToolbarButtonIcon
        {
            get => _toolbarButtonIcon;
            set
            {
                _toolbarButtonIcon = value;
                RaisePropertyChanged(() => ToolbarButtonIcon);
            }
        }
        
        public double PictoSize { get; } = Device.Idiom == TargetIdiom.Phone ? 100 : 150;

        public bool ShowToolbarButton { get; set; }

        public ICommand ToolbarButtonCommand => new Command(async () => await SwitchUserModeAsync());

        public ICommand SaveCommand => new Command(async () => await SaveSchedule());
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
            _selectedActivity = activity;
            await NavigationService.NavigateToAsync<ActivityViewModel>(activity);
            IsBusy = false;
        });

        public WeekPlannerViewModel(
            INavigationService navigationService,
            IRequestService requestService,
            IWeekApi weekApi,
            IDialogService dialogService,
            ISettingsService settingsService)
            : base(navigationService)
        {
            _requestService = requestService;
            _weekApi = weekApi;
            _dialogService = dialogService;
            _requestService = requestService;
            SettingsService = settingsService;

            OnBackButtonPressedCommand = new Command(async () => await BackButtonPressed());
            ShowToolbarButton = true;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is Tuple<int?, int?> weekYearAndNumber)
            {
                await GetWeekPlanForCitizenAsync(weekYearAndNumber);
            }
            else
            {
                throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
            }
        }

        // TODO: Handle situation where no days exist
        private async Task GetWeekPlanForCitizenAsync(Tuple<int?, int?> weekYearAndNumber)
        {
            SettingsService.UseTokenFor(UserType.Citizen);

            await _requestService.SendRequestAndThenAsync(
                requestAsync: () =>
                    _weekApi.V1WeekByWeekYearByWeekNumberGetAsync(weekYearAndNumber.Item1, weekYearAndNumber.Item2),
                onSuccess: result => { 
                    WeekDTO = result.Data;
                    WeekName = WeekDTO.Name;
                }
            );

            foreach (var days in WeekDTO.Days)
            {
                days.Activities = days.Activities.OrderBy(a => a.Order).ToList();
            }
        }

        private void InsertPicto(WeekPictogramDTO pictogramDTO)
        {
            var dayToAddTo = WeekDTO.Days.FirstOrDefault(d => d.Day == _weekdayToAddPictogramTo);
            if (dayToAddTo != null)
            {
                // Insert pictogram in the very bottom of the day
                var newOrderInBottom = dayToAddTo.Activities.Max(d => d.Order) + 1;
                dayToAddTo.Activities.Add(new ActivityDTO(pictogramDTO, newOrderInBottom, StateEnum.Normal));
                _isDirty = true;
                RaisePropertyForDays();
            }
        }


        private async Task SaveSchedule()
        {
            if (IsBusy) return;
            
            IsBusy = true;
            
            if (WeekNameIsEmpty)
            {
                await ShowWeekNameEmptyPrompt();
                IsBusy = false;
                return;
            }

            bool confirmed = await _dialogService.ConfirmAsync(
                title: "Gem ugeplan",
                message: "Vil du gemme ugeplanen?",
                okText: "Gem",
                cancelText: "Annuller");

            if (!confirmed)
            {
                IsBusy = false;
                return;
            }
            
            SettingsService.UseTokenFor(UserType.Citizen);

            await SaveOrUpdateSchedule();

            IsBusy = false;
        }

        private async Task SaveNewSchedule()
        {            
            await _requestService.SendRequestAndThenAsync(
                () => _weekApi.V1WeekByWeekYearByWeekNumberPutAsync(weekYear: WeekDTO.WeekYear,
                    weekNumber: WeekDTO.WeekNumber, newWeek: WeekDTO),
                result =>
                {
                    _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
                    _isDirty = false;
                });
        }

        private async Task UpdateExistingSchedule(bool showDialog = true)
        {
            if (WeekDTO.WeekNumber == null)
            {
                throw new InvalidDataException("WeekDTO should always have an Id when updating.");
            }

            await _requestService.SendRequestAndThenAsync(
                () => _weekApi.V1WeekByWeekYearByWeekNumberPutAsync(WeekDTO.WeekYear, WeekDTO.WeekNumber, WeekDTO),
                result => {
                    if (showDialog)
                    {
                        _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev gemt.");
                    }
                    _isDirty = false;
                 });
        }

        public override async Task PoppedAsync(object navigationData)
        {
            // Happens after choosing a pictogram in Pictosearch
            if (navigationData is PictogramDTO pictogramDTO)
            {
                WeekPictogramDTO weekPictogramDTO = PictoToWeekPictoDtoHelper.Convert(pictogramDTO);
                InsertPicto(weekPictogramDTO);
            }

            // Happens when popping from ActivityViewModel
            if (navigationData == null)
            {
                WeekDTO.Days.First(d => d.Activities.Contains(_selectedActivity))
                    .Activities
                    .Remove(_selectedActivity);
                _isDirty = true;
                RaisePropertyForDays();
                if (!SettingsService.IsInGuardianMode)
                {
                    await UpdateExistingSchedule();
                }
            }
            else if (navigationData is ActivityDTO activity)
            {
                _selectedActivity = activity;
                _isDirty = true;
                RaisePropertyForDays();
                if (!SettingsService.IsInGuardianMode)
                {
                    await UpdateExistingSchedule(showDialog:false);
                }
            }
            // Happens after logging in as guardian when switching to guardian mode
            if (navigationData is bool enterGuardianMode)
            {
                SetToGuardianMode();
            }
        }

        private async Task SwitchUserModeAsync()
        {
            if (IsBusy) return;
            IsBusy = true;
            if (SettingsService.IsInGuardianMode)
            {
                if(!_isDirty) {
                    SetToCitizenMode();
                    IsBusy = false;
                    return;
                }
                var result = await _dialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?",
                    "Annuller", null, "Gem ændringer", "Gem ikke");

                switch (result)
                {
                    case "Annuller":
                        break;

                    case "Gem ændringer":
                        if (WeekNameIsEmpty)
                        {
                            await ShowWeekNameEmptyPrompt();
                            break;
                        }
                        await SaveOrUpdateSchedule();
                        SetToCitizenMode();
                        break;

                    case "Gem ikke":
                        if (WeekDTO.WeekNumber != null)
                            await GetWeekPlanForCitizenAsync(new Tuple<int?, int?>(WeekDTO.WeekYear, WeekDTO.WeekNumber));
                        SetToCitizenMode();
                        break;
                }
            }
            else
            {
                await NavigationService.NavigateToAsync<LoginViewModel>(this);
            }

            IsBusy = false;
        }

        private bool WeekNameIsEmpty => string.IsNullOrEmpty(WeekName);

        private Task ShowWeekNameEmptyPrompt() =>
            _dialogService.ShowAlertAsync("Giv venligst ugeplanen et navn, og gem igen.", "Ok",
                "Ugeplanen blev ikke gemt");
            
        public int Height
        {
            get
            {
                int minimumHeight = 1500;
                int elementHeight = 250;

                if (WeekDTO == null)
                {
                    return minimumHeight;
                }

                int dynamicHeight = WeekDTO.Days.Max(d => d.Activities.Count) * elementHeight;

                return dynamicHeight > minimumHeight ? dynamicHeight : minimumHeight;
            }
        }

        private void SetToCitizenMode()
        {
            ShowBackButton = false;
            SettingsService.IsInGuardianMode = false;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
        }

        private void SetToGuardianMode()
        {
            ShowBackButton = true;
            SettingsService.IsInGuardianMode = true;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
        }

        private async Task BackButtonPressed()
        {
            if (IsBusy) return;
            if(!_isDirty) {
                await NavigationService.PopAsync();
                return;
            }
            if (!SettingsService.IsInGuardianMode){
                return;
            }
            IsBusy = true;
            var result = await _dialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?",
                "Annuller", null, "Gem ændringer", "Gem ikke");

            switch (result)
            {
                case "Annuller":
                    break;
                case "Gem ændringer":
                    if (WeekNameIsEmpty)
                    {
                        await ShowWeekNameEmptyPrompt();
                        break;
                    }
                    await SaveOrUpdateSchedule();
                    await NavigationService.PopAsync();
                    break;
                case "Gem ikke":
                    await NavigationService.PopAsync();
                    break;
            }

            IsBusy = false;
        }

        private DayEnum GetCurrentDay()
        {
            var today = DateTime.Today.DayOfWeek;
            switch (today)
            {
                case DayOfWeek.Monday:
                    return DayEnum.Monday;
                case DayOfWeek.Tuesday:
                    return DayEnum.Tuesday;
                case DayOfWeek.Wednesday:
                    return DayEnum.Wednesday;
                case DayOfWeek.Thursday:
                    return DayEnum.Thursday;
                case DayOfWeek.Friday:
                    return DayEnum.Friday;
                case DayOfWeek.Saturday:
                    return DayEnum.Saturday;
                case DayOfWeek.Sunday:
                    return DayEnum.Sunday;
                default:
                    throw new NotSupportedException("DayEnum out of bounds");
            }

        }

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


        private void RaisePropertyForDays()
        {
            SetActiveActivity();
            RaisePropertyChanged(() => MondayPictos);
            RaisePropertyChanged(() => TuesdayPictos);
            RaisePropertyChanged(() => WednesdayPictos);
            RaisePropertyChanged(() => ThursdayPictos);
            RaisePropertyChanged(() => FridayPictos);
            RaisePropertyChanged(() => SaturdayPictos);
            RaisePropertyChanged(() => SundayPictos);
            RaisePropertyChanged(() => Height);
        }

        private void SetActiveActivity()
        {
            var today = GetCurrentDay();
            var todaysActivities = WeekDTO.Days.First(d => d.Day == today).Activities;

            foreach (var activity in todaysActivities)
            {
                if (activity.State == StateEnum.Normal)
                {
                    activity.State = StateEnum.Active;
                    return;
                }
            }
        }

        private async Task SaveOrUpdateSchedule()
        {
            if (WeekDTO.WeekNumber is null)
            {
                await SaveNewSchedule();
            }
            else
            {
                await UpdateExistingSchedule();
            }
        }
    }
}