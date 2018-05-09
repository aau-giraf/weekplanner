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
        /// <summary>
        /// Small wrapper for handling which days have been toggled.
        /// Inheritance from Switch means we don't have to manually handle PropertyChanged etc.
        /// </summary>
        public class DayToggledWrapper : Switch
        {
            public readonly DayEnum Day;

            //SwitchToggled is used for visual purposes (see binding of schedule days in .XAML)
            private bool _switchToggled;
            public bool SwitchToggled
            {
                get => _switchToggled;
                set
                {
                    _switchToggled = value;
                    OnPropertyChanged(nameof(SwitchToggled));
                }
            }

            public DayToggledWrapper(DayEnum day, EventHandler<ToggledEventArgs> toggledEventCallback)
            {
                IsToggled = SwitchToggled = true;
                Day = day;
                Toggled += toggledEventCallback;
            }
        }

        private readonly ILoginService _loginService;
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;
        private readonly IDialogService _dialogService;
        private readonly ISettingsService _settingsService;
        private readonly List<WeekdayDTO> _removedWeekdayDTOs;
        private ActivityDTO _selectedActivity;
        private bool _editModeEnabled;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _userModeImage;
        private int _scheduleYear;
        private int _scheduleWeek;
        private ObservableCollection<DayToggledWrapper> _toggledDaysWrapper;

        public ObservableCollection<DayToggledWrapper> ToggledDaysWrapper
        {
            get => _toggledDaysWrapper;
            set
            {
                _toggledDaysWrapper = value;
                RaisePropertyChanged(() => ToggledDaysWrapper);
            }
        }

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

        public int ScheduleYear
        {
            get => _scheduleYear;
            set
            {
                _scheduleYear = value;
                RaisePropertyChanged(() => ScheduleYear);
            }
        }

        public int ScheduleWeek
        {
            get => _scheduleWeek;
            set
            {
                _scheduleWeek = value;
                RaisePropertyChanged(() => ScheduleWeek);
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
            _removedWeekdayDTOs = new List<WeekdayDTO>();

            ToggledDaysWrapper = new ObservableCollection<DayToggledWrapper>();
            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                ToggledDaysWrapper.Add(new DayToggledWrapper(day, OnToggledDayEventHandler));
            }

            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
            MessagingCenter.Subscribe<LoginViewModel>(this, MessageKeys.LoginSucceeded, (sender) => SetToGuardianMode());
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is Tuple<int, int> weekDetails)
            {
                ScheduleYear = weekDetails.Item1;
                ScheduleWeek = weekDetails.Item2;
                await GetWeekPlanForCitizenAsync(ScheduleYear, ScheduleWeek);
            }
            else if (navigationData is Tuple<int, int, WeekDTO> weekDetailsWithDTO) //When initialized from NewScheduleViewModel
            {
                ScheduleYear = weekDetailsWithDTO.Item1;
                ScheduleWeek = weekDetailsWithDTO.Item2;
                WeekDTO = weekDetailsWithDTO.Item3;

                SetToGuardianMode(); //When initialized from NewScheduleViewModel, we set the mode to GuardianMode, so we can edit the schedule straight away
            }
            else
            {
                throw new ArgumentException($"No instance of WeekPlannerViewModel takes {navigationData.GetType().ToString()} as parameter.", nameof(navigationData));
            }

            FlipToggledDays();

            OrderActivities();
        }

        public override async Task PoppedAsync(object navigationData)
        {
            // Happens after choosing a pictogram in Pictosearch
            if (navigationData is WeekPictogramDTO pictogramDTO)
            {
                InsertPicto(pictogramDTO);
            }

            // Happens when popping from ActivityViewModel
            if (navigationData is ActivityViewModel activityVM)
            {

                if (activityVM.Activity == null)
                {
                    // TODO this is dumb and it may remove duplicate elements since all elements are not unique
                    // we can refactor when ActivityDTO gets a unique ID
                    RemoveItemFromDay(DayEnum.Monday);
                    RemoveItemFromDay(DayEnum.Tuesday);
                    RemoveItemFromDay(DayEnum.Wednesday);
                    RemoveItemFromDay(DayEnum.Thursday);
                    RemoveItemFromDay(DayEnum.Friday);
                    RemoveItemFromDay(DayEnum.Saturday);
                    RemoveItemFromDay(DayEnum.Sunday);
                }
                else
                {
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

        // TODO: Handle situation where no days exist
        private async Task GetWeekPlanForCitizenAsync(int weekYear, int weekNumber)
        {

            _settingsService.UseTokenFor(UserType.Citizen);

            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1WeekByWeekYearByWeekNumberGetAsync(weekYear, weekNumber),
                onSuccess: result =>
                {
                    WeekDTO = result.Data;
                }
            );
        }

        private void OrderActivities()
        {
            foreach (var days in WeekDTO.Days)
            {
                days.Activities = days.Activities.OrderBy(x => x.Order).ToList();
            }
        }

        private async void OnToggledDayEventHandler<ToggledEventArgs>(object sender, ToggledEventArgs e)
        {
            if (!(sender is DayToggledWrapper dayToggleWrapper)) return;

            //Alright, here's the scenarios and quick truth table:
            //There are 2 scenarios here; either IsToggled went from T => F or F => T (obviously)
            //In either case, the property SwitchToggled has the value of IsToggled BEFORE it got toggled.
            //For scenario 1 (IsToggled F => T), our action also depends on the 'confirmed' bool
            //Here's the truth table from the scenarios:
            // Scenario      IsToggled          SwitchToggled        confirmed   =>     IsToggled   SwitchToggled
            // 1             T => F             T                    T           =>     F           F
            // 1             T => F             T                    F           =>     T           T
            // 2             F => T             F                    N/A         =>     T           T          

            //Scenario 1
            if (!dayToggleWrapper.IsToggled) //Check if we should remove the day from the schedule
            {
                var dayFromWeekDTO = WeekDTO.Days.FirstOrDefault(dayObj => dayObj.Day == dayToggleWrapper.Day);

                if (dayFromWeekDTO == null) return;

                bool confirmed = dayFromWeekDTO.Activities.Count > 0 ?
                    await _dialogService.ConfirmAsync(
                        title: "Bekræft sletning af ugedag",
                        message: "Hvis du sletter en ugedag med aktiviteter, sletter du samtidigt disse aktiviter. Er du sikker på, at du vil fortsætte?",
                        okText: "Slet ugedag",
                        cancelText: "Annuller") :
                    true;

                if (confirmed)
                {
                    var removedDay = WeekDTO.Days.FirstOrDefault(dayObj => dayObj.Day == dayToggleWrapper.Day);
                    if (removedDay == null) return;
                    _removedWeekdayDTOs.Add(removedDay);
                    WeekDTO.Days.Remove(removedDay);
                }


                dayToggleWrapper.IsToggled = dayToggleWrapper.SwitchToggled = !confirmed;

            }
            //Scenario 2
            else //Re-add the day to the schedule
            {
                var removedDay = _removedWeekdayDTOs.FirstOrDefault(dayObj => dayObj.Day == dayToggleWrapper.Day);
                if (removedDay == null)
                {
                    removedDay = new WeekdayDTO(Day: dayToggleWrapper.Day, Activities: new List<ActivityDTO>());
                }
                else
                {
                    _removedWeekdayDTOs.Remove(removedDay);
                }

                WeekDTO.Days.Add(removedDay);
                WeekDTO.Days.OrderBy(dayObj => (int)dayObj.Day);

                dayToggleWrapper.IsToggled = dayToggleWrapper.SwitchToggled = true;
            }

            RaisePropertyForDays(); //Not sure if this is nedded; but we may remove very large schedules, which may motivate an adjustment in Height etc.
        }

        private void FlipToggledDays()
        {
            if (ToggledDaysWrapper.Count == 0 || WeekDTO == null) return;

            bool isNewSchedule = (WeekDTO.WeekYear == null || WeekDTO.WeekNumber == null) ? true : false;

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                var toggleDayWrapper = ToggledDaysWrapper.FirstOrDefault(toggledDay => toggledDay.Day == day);

                if (toggleDayWrapper == null)
                    continue;

                toggleDayWrapper.IsToggled = toggleDayWrapper.SwitchToggled = WeekDTO.Days.Any(dayObj => dayObj.Day == day);
            }

            RaisePropertyChangedForDayLabels();
        }

        private void InsertPicto(WeekPictogramDTO pictogramDTO)
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
                IsBusy = false;
                return;
            }

            _settingsService.UseTokenFor(UserType.Citizen);

            await SaveOrUpdateSchedule();

            IsBusy = false;
        }

        private async Task SaveOrUpdateSchedule()
        {
            string onSuccesMessage = (WeekDTO.WeekYear == null || WeekDTO.WeekNumber == null) ?
                "Ugeplanen '{0}' blev oprettet og gemt." : // Save new week schedule
                "Ugeplanen '{0}' blev gemt."; // Update existing week schedule

            await _requestService.SendRequestAndThenAsync(
                () => _weekApi.V1WeekByWeekYearByWeekNumberPutAsync(ScheduleYear, ScheduleWeek, newWeek: WeekDTO),
                result =>
                {
                    _dialogService.ShowAlertAsync(message: string.Format(onSuccesMessage, result.Data.Name));
                    WeekDTO = result.Data;
                });
        }

        private bool RemoveItemFromDay(DayEnum day)
        {
            var a = WeekDTO.Days.FirstOrDefault(x => x.Day == day).Activities;
            if (a == null || a == default(List<ActivityDTO>) || a.Count == 0)
            {
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
                        break;

                    case "Gem ændringer":
                        EditModeEnabled = false;
                        await SaveSchedule();
                        UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
                        break;

                    case "Gem ikke":
                        EditModeEnabled = false;
                        UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
                        if (WeekDTO.WeekYear != null && WeekDTO.WeekNumber != null) await GetWeekPlanForCitizenAsync((int)WeekDTO.WeekYear, (int)WeekDTO.WeekNumber);
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

                if (WeekDTO == null || WeekDTO.Days.Count == 0)
                {
                    return minimumHeight;
                }

                int dynamicHeight = WeekDTO.Days.Max(d => d.Activities.Count) * elementHeight;

                return dynamicHeight > minimumHeight ? dynamicHeight : minimumHeight;
            }
        }

        public bool ShowMondayLabel => ShowDayLabel(DayEnum.Monday);
        public bool ShowTuesdayLabel => ShowDayLabel(DayEnum.Tuesday);
        public bool ShowWednesdayLabel => ShowDayLabel(DayEnum.Wednesday);
        public bool ShowThursdayLabel => ShowDayLabel(DayEnum.Thursday);
        public bool ShowFridayLabel => ShowDayLabel(DayEnum.Friday);
        public bool ShowSundayLabel => ShowDayLabel(DayEnum.Saturday);
        public bool ShowSaturdayLabel => ShowDayLabel(DayEnum.Sunday);
        private bool ShowDayLabel(DayEnum day)
        {
            return EditModeEnabled ||
                (WeekDTO == null && ToggledDaysWrapper.First(dayObj => dayObj.Day == day).SwitchToggled) ||
                (WeekDTO != null && WeekDTO.Days.Any(dayObj => dayObj.Day == day));
        }

        private void SetToGuardianMode()
        {
            EditModeEnabled = true;
            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
            RaisePropertyChangedForDayLabels();
        }

        private void RaisePropertyChangedForDayLabels()
        {
            RaisePropertyChanged(() => ShowMondayLabel);
            RaisePropertyChanged(() => ShowTuesdayLabel);
            RaisePropertyChanged(() => ShowWednesdayLabel);
            RaisePropertyChanged(() => ShowThursdayLabel);
            RaisePropertyChanged(() => ShowFridayLabel);
            RaisePropertyChanged(() => ShowSaturdayLabel);
            RaisePropertyChanged(() => ShowSundayLabel);
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
                        break;

                    case "Gem ændringer":
                        await SaveSchedule();
                        await NavigationService.PopAsync();
                        break;

                    case "Gem ikke":
                        await NavigationService.PopAsync();
                        break;
                }
            }
            IsBusy = false;
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


        private void RaisePropertyForDays()
        {
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
