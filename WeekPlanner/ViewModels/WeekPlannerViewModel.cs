using IO.Swagger.Api;
using IO.Swagger.Model;
using Syncfusion.ListView.XForms;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Helpers;
using WeekPlanner.Models;
using WeekPlanner.Services;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using static IO.Swagger.Model.ActivityDTO;
using static IO.Swagger.Model.WeekdayDTO;

namespace WeekPlanner.ViewModels
{
	public class WeekPlannerViewModel : ViewModelBase
    {

        protected readonly IRequestService RequestService;
        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        
        protected readonly IDialogService DialogService;
        public ISettingsService SettingsService { get; }
        private bool _isDirty = false;
        private long? _choiceID = 0;

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

			public bool InternalChange;

            public DayToggledWrapper(DayEnum day, EventHandler<ToggledEventArgs> toggledEventCallback)
            {
                IsToggled = SwitchToggled = true;
                Day = day;
                Toggled += toggledEventCallback;
				InternalChange = false;
            }
        }

        private readonly List<WeekdayDTO> _removedWeekdayDTOs;
        private ActivityWithNotifyDTO _selectedActivity;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _toolbarButtonIcon;
        private int _scheduleYear;
        private int _scheduleWeek;
        private Dictionary<long?, List<ActivityWithNotifyDTO>> _choiceBoardActivities = new Dictionary<long?, List<ActivityWithNotifyDTO>>();
        protected WeekPictogramDTO _standardChoiceBoardPictoDTO;
        private ObservableCollection<DayToggledWrapper> _toggledDaysWrapper;
        private string _saveText;

        public ObservableCollection<DayToggledWrapper> ToggledDaysWrapper
        {
            get => _toggledDaysWrapper;
            set
            {
                _toggledDaysWrapper = value;
                RaisePropertyChanged(() => ToggledDaysWrapper);
            }
        }


        public WeekDTO WeekDTO
        {
            get => _weekDto;
            set
            {
                _weekDto = value;
                RaisePropertyChanged(() => WeekDTO);
                RaisePropertyChanged(() => WeekName);
                RaisePropertyForDays();
            }
        }

        public string SaveText
        {
            get => _saveText;
            set
            {
                _saveText = value;
                RaisePropertyChanged(() => SaveText);
            }
        }

        public string WeekName
        {
            get => WeekDTO?.Name;
            set
            {
                // Hack needed because initializeAsync and TwoWay-binding sets it
                if (value != WeekDTO?.Name)
                {
                    _isDirty = true;
                }

                if (WeekDTO == null) return;

                WeekDTO.Name = value;
                RaisePropertyChanged(() => WeekName);
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

		public string CurrentDayLabel  => TranslateCurrentDay(); 

		public Color CurrentDayColor => Color.FromHex(SettingsService.CurrentCitizenSettingDTO.WeekDayColors.Single(x => x.Day == GetCurrentColorDay()).HexColor);

        public ObservableCollection<ActivityWithNotifyDTO> CurrentDayPictos => dayActivityCollections[GetCurrentDay()];

		public ICommand ToggleEditModeCommand => new Command(async () => await SwitchUserModeAsync());
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
        public ICommand PictoClickedCommand => new Command<Syncfusion.ListView.XForms.ItemTappedEventArgs>(async activity =>
        {
            if (IsBusy) return;
            IsBusy = true;
            if (activity.ItemData is ActivityWithNotifyDTO activityWithNotifyDTO)
            {
                _selectedActivity = activityWithNotifyDTO;

                if (_selectedActivity.IsChoiceBoard.HasValue && _selectedActivity.IsChoiceBoard.Value)
                {
                    //await NavigationService.NavigateToAsync<ChoiceBoardViewModel>(GetActivitiesForChoiceBoard());
                }
                else if (activityWithNotifyDTO.State != null && (SettingsService.IsInGuardianMode || !activityWithNotifyDTO.State.Value.Equals(StateEnum.Canceled)))
                {
                    await NavigationService.NavigateToAsync<ActivityViewModel>(_selectedActivity.ToActivityDTO());
                }
            }

            IsBusy = false;
        });

        public ICommand PictoDraggedCommand => new Command<ItemDraggingEventArgs>(args =>
        {
            // Disable dragging if in citizen mode
            if (!SettingsService.IsInGuardianMode)
            {
                args.Cancel = true;
                return;
            }

            if (IsBusy) return;
            IsBusy = true;

            if (args.Action == DragAction.Drop
                && args.ItemData is ActivityDTO activity)
            {
                UpdateOrderingOfActivities(activity, args.OldIndex, args.NewIndex);
            }
            IsBusy = false;
        });

        private void UpdateOrderingOfActivities(ActivityDTO activityDTO, int oldIndex, int newIndex)
        {
            if (oldIndex == newIndex || oldIndex < 0 || newIndex < 0 || activityDTO == null) return;
            WeekdayDTO dayToReorder = WeekDTO.Days.FirstOrDefault(d => d.Activities.Contains(activityDTO));
            if (dayToReorder is null) return;

            // The activities have not updated yet, so we get the order value based on old indexes
            var newOrder = dayToReorder.Activities[newIndex].Order;

            // Update the orders of all activities in the day          
            if (newIndex < oldIndex) // Dragged upwards
            {
                for (int i = newIndex; i < oldIndex; i++)
                {
                    dayToReorder.Activities[i].Order += 1;
                }
            }
            else // Dragged downwards
            {
                for (int i = oldIndex + 1; i <= newIndex; i++)
                {
                    dayToReorder.Activities[i].Order -= 1;
                }
            }
            activityDTO.Order = newOrder;

            // Update order so indexes are correct on next use
            dayToReorder.Activities = dayToReorder.Activities.OrderBy(a => a.Order).ToList();
            _isDirty = true;
        }


        public WeekPlannerViewModel(
            INavigationService navigationService,
            IRequestService requestService,
            IWeekApi weekApi,
            IDialogService dialogService,
            ISettingsService settingsService,
            IPictogramApi pictogramApi)
            : base(navigationService)
        {
            RequestService = requestService;
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            DialogService = dialogService;
            RequestService = requestService;
            SettingsService = settingsService;

            _removedWeekdayDTOs = new List<WeekdayDTO>();

            ToggledDaysWrapper = new ObservableCollection<DayToggledWrapper>();
            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                ToggledDaysWrapper.Add(new DayToggledWrapper(day, OnToggledDayEventHandler));
            }

            ShowToolbarButton = true;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");

            OnBackButtonPressedCommand = new Command(async () => await BackButtonPressed());

            dayActivityCollections = new Dictionary<DayEnum?, ObservableCollection<ActivityWithNotifyDTO>>
            {
                {DayEnum.Monday, MondayPictos},
                {DayEnum.Tuesday, TuesdayPictos},
                {DayEnum.Wednesday, WednesdayPictos},
                {DayEnum.Thursday, ThursdayPictos},
                {DayEnum.Friday, FridayPictos},
                {DayEnum.Saturday, SaturdayPictos},
                {DayEnum.Sunday, SundayPictos}
            };
        }

        // TODO: Handle situation where no days exist
        private async Task GetWeekPlanForCitizenAsync(int weekYear, int weekNumber)
        {
            await RequestService.SendRequestAndThenAsync(
                requestAsync: () => _weekApi.V1UserByUserIdWeekByWeekYearByWeekNumberGetAsync(SettingsService.CurrentCitizen.UserId, weekYear, weekNumber),
                onSuccess: result =>
                {
                    WeekDTO = result.Data;
                    WeekName = WeekDTO.Name;
                    InsertActivityNotifyDTOsInWeekDays(WeekDTO);
                }
            );

            //FoldDaysToChoiceBoards();
        }

        private void OrderActivities()
        {
            WeekDTO.Days.ForEach(d => d.Activities = d.Activities.OrderBy(a => a.Order).ToList());

            RaisePropertyForDays();
        }

        private async void OnToggledDayEventHandler<ToggledEventArgs>(object sender, ToggledEventArgs e)
        {
            if (!(sender is DayToggledWrapper dayToggleWrapper)) return;
			if (dayToggleWrapper.InternalChange) { dayToggleWrapper.InternalChange = false; return; } 
			// InternalChange is used here to ensure that this method does not perform changes when the toggle has been changed internally(ie. not by the user) 

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
                    await DialogService.ConfirmAsync(
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
				else
				{
					dayToggleWrapper.InternalChange = true;
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

            try
            {
                RaisePropertyForDays(); //Not sure if this is nedded; but we may remove very large schedules, which may motivate an adjustment in Height etc.
            }
            catch
            {
                Console.WriteLine("Something8");
            }

        }

        private void FlipToggledDays()
        {
            if (ToggledDaysWrapper.Count == 0 || WeekDTO == null) return;

            bool isNewSchedule = WeekDTO.WeekYear == null || WeekDTO.WeekNumber == null;

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                var toggleDayWrapper = ToggledDaysWrapper.FirstOrDefault(toggledDay => toggledDay.Day == day);

                if (toggleDayWrapper == null)
                    continue;

                toggleDayWrapper.IsToggled = toggleDayWrapper.SwitchToggled = WeekDTO.Days.Any(dayObj => dayObj.Day == day);
            }

            RaisePropertyChangedForDayLabels();
        }

        private void InsertNewActivity(WeekPictogramDTO pictogramDTO)
        {
            var dayToAddTo = WeekDTO.Days.FirstOrDefault(d => d.Day == _weekdayToAddPictogramTo);
            var pictoCollectoToAddTo = dayActivityCollections[_weekdayToAddPictogramTo];
            if (dayToAddTo != null && pictoCollectoToAddTo != null)
            {
                // Insert pictogram in the very bottom of the day
                var newOrderInBottom = dayToAddTo.Activities.Max(d => d.Order) + 1 ?? 0;
                ActivityDTO newActivityDTO = new ActivityDTO(pictogramDTO, newOrderInBottom, StateEnum.Normal);
                dayToAddTo.Activities.Add(newActivityDTO);
                
                // Add to collection
                pictoCollectoToAddTo.Add(newActivityDTO.ToActivityWithNotifyDTO());
                
                _isDirty = true;
                
                RaisePropertyForDays();
            }
        }

        /*#region ChoiceBoardMethods

        private List<ActivityWithNotifyDTO> GetActivitiesForChoiceBoard()
        {
            if (_choiceBoardActivities.TryGetValue(_selectedActivity.ChoiceBoardID, out List<ActivityWithNotifyDTO> activities))
            {
                return activities;
            }
            return null;
        }

        private void DeleteChoiceBoard()
        {
            _choiceBoardActivities.Remove(_selectedActivity.ChoiceBoardID);
        }

        protected void FoldDaysToChoiceBoards()
        {
            foreach (var days in WeekDTO.Days)
            {
                List<int?> orderOfChoiceBoards = new List<int?>();
                List<ActivityWithNotifyDTO> choiceBoardItems = new List<ActivityWithNotifyDTO>();
                ActivityWithNotifyDTO choiceBoard;

                foreach (var activityGroup in days.Activities.GroupBy(d => d.Order, d => d))
                {
                    if (activityGroup.Count() > 1)
                    {
                        foreach (var activity in activityGroup)
                        {
                            activity.State = StateEnum.Normal;
                            choiceBoardItems.Add(activity.ToActivityWithNotifyDTO());
                        }
                        orderOfChoiceBoards.Add(activityGroup.Key);
                    }
                }

                foreach (var order in orderOfChoiceBoards)
                {
                    days.Activities.RemoveAll(a => a.Order == order);
                    choiceBoard = new ActivityWithNotifyDTO(_standardChoiceBoardPictoDTO, order, StateEnum.Normal) { IsChoiceBoard = true, ChoiceBoardID = _choiceID.Value };
                    days.Activities.Add(choiceBoard.ToActivityDTO());
                    _choiceBoardActivities.Add(choiceBoard.ChoiceBoardID, choiceBoardItems);
                    _choiceID++;
                }
            }
            OrderActivities();
        }

        protected void PutChoiceActivitiesBackIntoSchedule()
        {
            foreach (var day in WeekDTO.Days)
            {
                List<ActivityWithNotifyDTO> choiceBoardActivities = new List<ActivityWithNotifyDTO>();

                foreach (var activity in day.Activities)
                {
                    if (activity.IsChoiceBoard.HasValue && activity.IsChoiceBoard.Value)
                    {
                        choiceBoardActivities.Add(activity.ToActivityWithNotifyDTO());
                    }
                }

                foreach (var item in choiceBoardActivities)
                {
                    if (_choiceBoardActivities.TryGetValue(item.ChoiceBoardID, out List<ActivityWithNotifyDTO> unfoldedActivities))
                    {
                        foreach (var activity in unfoldedActivities)
                        {
                            activity.Order = item.Order;
                        }
                        day.Activities.AddRange(unfoldedActivities.ToActivityDTOs());
                    }
                }
                day.Activities.RemoveAll(a => a.IsChoiceBoard.HasValue && a.IsChoiceBoard.Value);
            }

            _choiceBoardActivities.Clear();
        }

        private async Task HandleChoiceBoardAsync(ObservableCollection<ActivityWithNotifyDTO> activities)
        {
            switch (activities.Count)
            {
                case 0:
                    DeleteChoiceBoard();
                    WeekDTO.Days.First(d => d.Activities.Contains(_selectedActivity.ToActivityDTO())).Activities.Remove(_selectedActivity);
                    _isDirty = true;
                    OrderActivities();
                    break;
                case 1:
                    DeleteChoiceBoard();

                    WeekDTO.Days.First(d => d.Activities.Contains(_selectedActivity)).Activities.Add(activities.First());
                    WeekDTO.Days.First(d => d.Activities.Contains(_selectedActivity)).Activities.Remove(_selectedActivity);

                    WeekDTO.Days.ForEach(a => a.Activities = a.Activities.OrderBy(x => x.Order).ToList());
                    if (!SettingsService.IsInGuardianMode)
                    {
                        await SaveOrUpdateSchedule();
                    }

                    RaisePropertyForDays();

                    break;
                default:
                    DayEnum? dayEnum = WeekDTO.Days.First(d => d.Activities.Contains(_selectedActivity)).Day;
                    ActivityDTO activityDTO = new ActivityDTO(_standardChoiceBoardPictoDTO, activities.First().Order, StateEnum.Normal);
                    if (_selectedActivity.IsChoiceBoard.HasValue && _selectedActivity.IsChoiceBoard.Value)
                    {
                        activityDTO.ChoiceBoardID = _selectedActivity.ChoiceBoardID;
                        _choiceBoardActivities.Remove(_selectedActivity.ChoiceBoardID);
                    }
                    else
                    {
                        activityDTO.ChoiceBoardID = _choiceID;
                        _choiceID++;
                    }
                    activityDTO.IsChoiceBoard = true;

                    WeekDTO.Days.First(d => d.Activities.Contains(_selectedActivity)).Activities.Remove(_selectedActivity);

                    WeekDTO.Days.Single(d => d.Day == dayEnum).Activities.Add(activityDTO);

                    _choiceBoardActivities.Add(activityDTO.ChoiceBoardID, activities.ToList());

                    OrderActivities();

                    _isDirty = true;
                    break;
            }
        }
        #endregion*/

        private async Task SaveSchedule(bool showDialog = true)
        {
            if (IsBusy) return;

            IsBusy = true;

            if (WeekNameIsEmpty)
            {
                await ShowWeekNameEmptyPrompt();
                IsBusy = false;
                return;
            }

            var confirmed = await SaveDialog(showDialog);

            if (!confirmed)
            {
                IsBusy = false;
                return;
            }

            await SaveOrUpdateSchedule();

            IsBusy = false;
        }

        protected virtual async Task<bool> SaveDialog(bool showDialog)
        {
            return !showDialog || await DialogService.ConfirmAsync(
                                 title: "Gem ugeplan",
                                 message: "Vil du gemme ugeplanen?",
                                 okText: "Gem",
                                 cancelText: "Annuller");
            
        }

        protected virtual async Task SaveOrUpdateSchedule()
        {
            //PutChoiceActivitiesBackIntoSchedule();

            string onSuccesMessage = (WeekDTO.WeekYear == null || WeekDTO.WeekNumber == null) ?
                "Ugeplanen '{0}' blev oprettet og gemt." : // Save new week schedule
                "Ugeplanen '{0}' blev gemt."; // Update existing week schedule

			if (SettingsService.IsInGuardianMode)
			{
				await RequestService.SendRequestAndThenAsync(
				() => _weekApi.V1UserByUserIdWeekByWeekYearByWeekNumberPutAsync(SettingsService.CurrentCitizen.UserId, ScheduleYear, ScheduleWeek, newWeek: WeekDTO),
				result =>
				{
					DialogService.ShowAlertAsync(message: string.Format(onSuccesMessage, result.Data.Name));
					WeekDTO = result.Data;
                    _isDirty = false;
				});
			}
			else
			{
				await RequestService.SendRequestAndThenAsync(
				() => _weekApi.V1UserByUserIdWeekByWeekYearByWeekNumberPutAsync(SettingsService.CurrentCitizen.UserId, ScheduleYear, ScheduleWeek, newWeek: WeekDTO),
				result =>
				{
					WeekDTO = result.Data;
                    _isDirty = false;
				});
			}

			_removedWeekdayDTOs.Clear();
            //FoldDaysToChoiceBoards();
        }
        
        private async Task SwitchUserModeAsync()
        {
            if (IsBusy) return;
            IsBusy = true;
            if (SettingsService.IsInGuardianMode)
            {
                if (!_isDirty)
                {
					SetToCitizenMode();
                    IsBusy = false;
                    return;
                }
                var result = await DialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?",
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
						SetToCitizenMode();
						await SaveOrUpdateSchedule();
                        break;

                    case "Gem ikke":
                        if (WeekDTO.WeekNumber != null)
                            await GetWeekPlanForCitizenAsync(ScheduleYear, ScheduleWeek);
                        SetToCitizenMode();
                        break;
                }
			}
            else
            {
                LandscapeOrientation();
                await NavigationService.NavigateToAsync<LoginViewModel>(this);
            }

            RaisePropertyChangedForDayLabels();

            IsBusy = false;
        }

		public void SetOrientation()
		{
			if (SettingsService.IsInGuardianMode)
			{
				LandscapeOrientation();
			}
			else if (SettingsService.CurrentCitizenSettingDTO.Orientation == SettingDTO.OrientationEnum.Portrait)
			{
				PortraitOrientation();
			}
			else
			{
				LandscapeOrientation();
			}
		}

		private void PortraitOrientation()
		{
			MessagingCenter.Send(this, "SetOrientation", "Portrait");
			MessagingCenter.Send(this, "ChangeView", "Portrait");
		}

		private void LandscapeOrientation()
		{
			MessagingCenter.Send(this, "SetOrientation", "Landscape");
			MessagingCenter.Send(this, "ChangeView", "Landscape");
		}

		private bool WeekNameIsEmpty => string.IsNullOrEmpty(WeekName);

        protected virtual async Task ShowWeekNameEmptyPrompt()
        {
            await DialogService.ShowAlertAsync("Giv venligst ugeplanen et navn, og gem igen.", "Ok",
                "Ugeplanen blev ikke gemt");
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

        private void SetToCitizenMode()
        {
			ShowBackButton = false;
            SettingsService.IsInGuardianMode = false;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");

            RaisePropertyChangedForDayLabels();

            SetOrientation();
        }
        public bool ShowMondayLabel => ShowDayLabel(DayEnum.Monday);
        public bool ShowTuesdayLabel => ShowDayLabel(DayEnum.Tuesday);
        public bool ShowWednesdayLabel => ShowDayLabel(DayEnum.Wednesday);
        public bool ShowThursdayLabel => ShowDayLabel(DayEnum.Thursday);
        public bool ShowFridayLabel => ShowDayLabel(DayEnum.Friday);
		public bool ShowSaturdayLabel => ShowDayLabel(DayEnum.Saturday);
		public bool ShowSundayLabel => ShowDayLabel(DayEnum.Sunday);
        private bool ShowDayLabel(DayEnum day)
        {
            return SettingsService.IsInGuardianMode ||   //When IsInGuardianMode we want to see the day labels
                (WeekDTO == null && ToggledDaysWrapper.First(dayObj => dayObj.Day == day).SwitchToggled) || //Happens upon initialization of the view. WeekDTO is still null at this point, so we rely on SwitchToggled for the day
                (WeekDTO != null && WeekDTO.Days.Any(dayObj => dayObj.Day == day)); //Happens when refreshing the view
        }

        private void SetToGuardianMode()
        {
            ShowBackButton = true;
            SettingsService.IsInGuardianMode = true;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");

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

			if (!SettingsService.IsInGuardianMode)
            {
                return;
            }
            if (!_isDirty)
            {
                IsBusy = true;
                await NavigationService.PopAsync();
                IsBusy = false;
                return;
            }

            IsBusy = true;
            var result = await DialogService.ActionSheetAsync("Der er ændringer der ikke er gemt. Vil du gemme?",
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
                    SaveOrUpdateSchedule();
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

		private string TranslateCurrentDay()
		{
			switch (GetCurrentDay())
			{
				case DayEnum.Monday:
					return "Mandag";
				case DayEnum.Tuesday:
					return "Tirsdag";
				case DayEnum.Wednesday:
					return "Onsdag";
				case DayEnum.Thursday:
					return "Torsdag";
				case DayEnum.Friday:
					return "Fredag";
				case DayEnum.Saturday:
					return "Lørdag";
				case DayEnum.Sunday:
					return "Søndag";
				default:
					throw new NotSupportedException("DayEnum out of bounds");
			}
		}

		private WeekDayColorDTO.DayEnum GetCurrentColorDay()
		{
			switch (GetCurrentDay())
			{
				case DayEnum.Monday:
					return WeekDayColorDTO.DayEnum.Monday;
				case DayEnum.Tuesday:
					return WeekDayColorDTO.DayEnum.Tuesday;
				case DayEnum.Wednesday:
					return WeekDayColorDTO.DayEnum.Wednesday;
				case DayEnum.Thursday:
					return WeekDayColorDTO.DayEnum.Thursday;
				case DayEnum.Friday:
					return WeekDayColorDTO.DayEnum.Friday;
				case DayEnum.Saturday:
					return WeekDayColorDTO.DayEnum.Saturday;
				case DayEnum.Sunday:
					return WeekDayColorDTO.DayEnum.Sunday;
				default:
					throw new NotSupportedException("ColorDayEnum out of bounds");
			}
		}

        public ObservableCollection<ActivityWithNotifyDTO> MondayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> TuesdayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> WednesdayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> ThursdayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> FridayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> SaturdayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> SundayPictos { get; private set; } = new ObservableCollection<ActivityWithNotifyDTO>();

        private Dictionary<DayEnum?, ObservableCollection<ActivityWithNotifyDTO>> dayActivityCollections;
        
        private ObservableCollection<ActivityWithNotifyDTO> GetPictosOrEmptyList(DayEnum dayEnum)
        {
            var day = WeekDTO?.Days.FirstOrDefault(x => x.Day == dayEnum);
            if (day == null)
            {
                return new ObservableCollection<ActivityWithNotifyDTO>();
            }

            return new ObservableCollection<ActivityWithNotifyDTO>(day.Activities.ToActivityWithNotifyDTOs());
        }

        private void InsertActivityNotifyDTOsInWeekDays(WeekDTO weekDTO)
        {
            weekDTO.Days.ForEach(d =>
            {
                dayActivityCollections[d.Day].AddRange(d.Activities.ToActivityWithNotifyDTOs());
            });
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
			RaisePropertyChanged(() => CurrentDayPictos);
            RaisePropertyChanged(() => Height);
        }

        private void SetActiveActivity()
        {
            var today = GetCurrentDay();
            var todaysDTO = WeekDTO.Days.SingleOrDefault(d => d.Day == today);

            if (todaysDTO == null) return;

            var todaysActivities = todaysDTO.Activities;

            foreach (var activity in todaysActivities)
            {
                if (activity.State == StateEnum.Normal)
                {
                    activity.State = StateEnum.Active;
                    return;
                }
            }
        }

        protected void ToggleDaysAndOrderActivities()
        {
            FlipToggledDays();
            OrderActivities();
        }



        public override async Task OnReturnedToAsync(object navigationData)
        {
            switch (navigationData)
            {
                case WeekPictogramDTO weekPictogramDTO:
                    // Happens after choosing a pictogram in Pictosearch
                    InsertNewActivity(weekPictogramDTO);
                    break;
                case ActivityViewModel activityViewModel when activityViewModel.Activity == null:
                    // Happens when popping from ActivityViewModel and activity was deleted
                    RemoveActivity(_selectedActivity);
                    break;
                case ActivityViewModel activityVM:
                    // Happens when popping from ActivityViewModel and activity was altered
                    await UpdateActivity(activityVM.Activity);
                    break;
                // Happens after logging in as guardian when switching to guardian mode
                case bool enterGuardianMode:
                    SetToGuardianMode();
                    break;
                case ObservableCollection<ActivityDTO> activities:
                    //await HandleChoiceBoardAsync(activities);
                    break;
            }
            SetOrientation();
        }

        private async Task UpdateActivity(ActivityDTO alteredActivityDTO)
        {
            // Find activity in WeekDTO and update it
            var (dayChangedIn, activityToBeUpdated) = FindWeekDayAndActivityDTOInWeekDTOById(alteredActivityDTO.Id);
            activityToBeUpdated.Pictogram = alteredActivityDTO.Pictogram;
            activityToBeUpdated.State = alteredActivityDTO.State;

            // Update it in observable collection
            var activityWithNotifyToBeUpdated = dayActivityCollections[dayChangedIn.Day]
                .FirstOrDefault(a => a.Id == alteredActivityDTO.Id);
            if (activityWithNotifyToBeUpdated == null) return;
            activityWithNotifyToBeUpdated.Pictogram = alteredActivityDTO.Pictogram;
            activityWithNotifyToBeUpdated.State = alteredActivityDTO.State;
            
            // Set diry flag
            _isDirty = true;
            
            // Save if in citizen mode
            if (!SettingsService.IsInGuardianMode)
            {
                await SaveSchedule(showDialog: false);
            }
        }

        private (WeekdayDTO, ActivityDTO) FindWeekDayAndActivityDTOInWeekDTOById(long? id)
        {
            var dayContaining = WeekDTO.Days.First(d => d.Activities.FirstOrDefault(a => a.Id == id) != null);
            return (dayContaining, dayContaining?.Activities.FirstOrDefault(a => a.Id == id));
        }
       
        private void RemoveActivity(ActivityWithNotifyDTO activityWithNotifyToBeRemoved)
        {
            var (dayChangedIn, activityToBeRemoved) = FindWeekDayAndActivityDTOInWeekDTOById(activityWithNotifyToBeRemoved.Id);
           
            if (dayChangedIn != null && activityToBeRemoved != null)
            {
                // Remove from WeekDTO
                dayChangedIn.Activities.Remove(activityToBeRemoved);
            }
            
            // Remove from ObservableCollection
            dayActivityCollections[dayChangedIn.Day].Remove(activityWithNotifyToBeRemoved);

            _isDirty = true;
        }

        public override async Task InitializeAsync(object navigationData)
        {
            _standardChoiceBoardPictoDTO = _pictogramApi.V1PictogramByIdGet(2).Data;
            switch (navigationData)
            {
                //When initialized from CitizenSchedulesViewModel
                case Tuple<int, int> weekDetails:
                    ScheduleYear = weekDetails.Item1;
                    ScheduleWeek = weekDetails.Item2;
                    await GetWeekPlanForCitizenAsync(ScheduleYear, ScheduleWeek);
                    break;
                //When initialized from NewScheduleViewModel
                case Tuple<int, int, WeekDTO> weekDetailsWithDTO:
                    ScheduleYear = weekDetailsWithDTO.Item1;
                    ScheduleWeek = weekDetailsWithDTO.Item2;
                    WeekDTO = weekDetailsWithDTO.Item3;
                    InsertActivityNotifyDTOsInWeekDays(WeekDTO);
                    //FoldDaysToChoiceBoards();
                    await NavigationService.RemoveLastFromBackStackAsync();
                    SetToGuardianMode(); //When initialized from NewScheduleViewModel, we set the mode to GuardianMode, so we can edit the schedule straight away
                    break;
                default:
                    throw new ArgumentException($"No instance of WeekPlannerViewModel takes {navigationData.GetType().ToString()} as parameter.", nameof(navigationData));
            }
            SaveText = "Gem Ugeplan";
            
            ToggleDaysAndOrderActivities();
        }
    }
}