using IO.Swagger.Api;
using IO.Swagger.Model;
using Syncfusion.ListView.XForms;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using Syncfusion.DataSource.Extensions;
using WeekPlanner.Annotations;
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
using ItemTappedEventArgs = Syncfusion.ListView.XForms.ItemTappedEventArgs;

namespace WeekPlanner.ViewModels
{
	public partial class WeekPlannerViewModel : ViewModelBase
    {

        #region Properties
        #region ServicesAndApis
        protected readonly IRequestService RequestService;
        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        protected readonly IDialogService DialogService;
        public ISettingsService SettingsService { get; }
        #endregion
        
        private bool _isDirty = false;
        private int _choiceBoardIds;
        private long _temporaryActivityIds = long.MinValue;
        
        private readonly List<WeekdayDTO> _removedWeekdayDTOs;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _toolbarButtonIcon;
        private int _scheduleYear;
        private int _scheduleWeek;
        private readonly Dictionary<long?, List<ActivityWithNotifyDTO>> _choiceBoardActivities = new Dictionary<long?, List<ActivityWithNotifyDTO>>();
        private WeekPictogramDTO _standardChoiceBoardPictoDTO;
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

        [UsedImplicitly] public double PictoSize { get; } = Device.Idiom == TargetIdiom.Phone ? 100 : 150;

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

		[UsedImplicitly] public string CurrentDayLabel => DayHelpers.TranslateCurrentDay(); 

		[UsedImplicitly]
		public Color CurrentDayColor 
		    => Color.FromHex(SettingsService.CurrentCitizenSettingDTO.WeekDayColors
		    .Single(x => x.Day == DayHelpers.GetCurrentColorDay()).HexColor);

        [UsedImplicitly]
        public ObservableCollection<ActivityWithNotifyDTO> CurrentDayPictos 
            => _dayActivityCollections[DayHelpers.GetCurrentDay()];

        public SettingDTO.OrientationEnum Orientation = SettingDTO.OrientationEnum.Landscape;

        #region Commands
        
        [UsedImplicitly] 
        public ICommand ToolbarButtonCommand => new Command(async () => await SwitchUserModeAsync());
        [UsedImplicitly] 
        public ICommand SaveCommand => new Command(async () => await SaveSchedule());
        [UsedImplicitly]
        public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
        {
            if (IsBusy) return;
            IsBusy = true;
            _weekdayToAddPictogramTo = weekday;
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
            IsBusy = false;
        });

        [UsedImplicitly]
        public ICommand ActivityTappedCommand =>
            new Command<ItemTappedEventArgs>(async args => await OnActivityTapped(args));
        
        public ICommand ActivityDraggedCommand => new Command<ItemDraggingEventArgs>(OnActivityDragged);
        
        #endregion
        #endregion
        
        #region Initialization
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

            _dayActivityCollections = new Dictionary<DayEnum?, ObservableCollection<ActivityWithNotifyDTO>>
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
        
        public override async Task InitializeAsync(object navigationData)
        {
            await RequestService.SendRequestAndThenAsync(
                requestAsync: () => _pictogramApi.V1PictogramByIdGetAsync(2),
                onSuccess: result =>
                {
                    _standardChoiceBoardPictoDTO = result.Data;
                }
            );
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
                    await NavigationService.RemoveLastFromBackStackAsync();
                    SetToGuardianMode(); //When initialized from NewScheduleViewModel, we set the mode to GuardianMode, so we can edit the schedule straight away
                    break;
                default:
                    throw new ArgumentException($"No instance of WeekPlannerViewModel takes {navigationData.GetType()} as parameter.", nameof(navigationData));
            }
            SaveText = "Gem Ugeplan";
            
            ToggleDaysAndOrderActivities();
        }
        #endregion

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
        }
        
        private async Task OnActivityTapped(ItemTappedEventArgs args)
        {
            if (IsBusy) return;
            IsBusy = true;
            switch (args.ItemData)
            {
                case ActivityWithNotifyDTO activityWithNotifyDTO when activityWithNotifyDTO.IsChoiceBoard == true:
                    await NavigationService.NavigateToAsync<ChoiceBoardViewModel>(
                        (activityWithNotifyDTO.ToActivityDTO(), GetActivitiesForChoiceBoard(activityWithNotifyDTO.ChoiceBoardID)));
                    break;
                case ActivityWithNotifyDTO activityWithNotifyDTO:
                    if (activityWithNotifyDTO.State != null &&
                        (SettingsService.IsInGuardianMode || !activityWithNotifyDTO.State.Value.Equals(StateEnum.Canceled)))
                    {
                        await NavigationService.NavigateToAsync<ActivityViewModel>(activityWithNotifyDTO.ToActivityDTO());
                    }
                    break;
            }
            IsBusy = false;
        }

        private void OrderActivitiesInAllDayCollectionsAndWeekDTO()
        {
            _dayActivityCollections.ForEach(dayActivities => dayActivities.Value.Sort((a, b) => a.CompareTo(b)));
            WeekDTO.Days.ForEach(d => d.Activities = d.Activities.OrderBy(a => a.Order).ToList());
        }
        
        #region Drag'n'Drop
        private void OnActivityDragged(ItemDraggingEventArgs args)
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
                && args.ItemData is ActivityWithNotifyDTO activity)
            {
				UpdateOrderingOfActivities(activity, args.OldIndex, args.NewIndex);
            }

            IsBusy = false;
        }

		private void UpdateOrderingOfActivities(ActivityWithNotifyDTO activityWithNotify, int oldIndex, int newIndex)
        {
            if (oldIndex == newIndex || oldIndex < 0 || newIndex < 0 || activityWithNotify.Id == null) return;
            
            // Find dayEnum for day dragged in
            var dayChanged = FindDayEnumOfActivityById(activityWithNotify.Id);
                
            // Find new order with newIndex in observableCollection, since it hasn't updated yet
            var newOrder = _dayActivityCollections[dayChanged][newIndex].Order;
            
            var (dayCollection, _) = FindDayAndActivityWithNotifyDTOInWeekObservablesById(activityWithNotify.Id);

            var dayToReorder = WeekDTO.Days.FirstOrDefault(d => d.Day == dayChanged);

            // Update the orders of all activities in the day          
            if (newIndex < oldIndex) // Dragged upwards
            {
                for (int i = newIndex; i < oldIndex; i++)
                {
                    var activityInCollection = dayCollection[i];
                    var changedOrder = activityInCollection.Order + 1;
                    
                    if (activityInCollection.IsChoiceBoard == true)
                    {
                        UpdateOrderInChoiceBoardAndItems(activityInCollection, changedOrder);
                    }
                    else
                    {
                        activityInCollection.Order = changedOrder;
                    }
                }
            }
            else // Dragged downwards
            {
                for (int i = oldIndex + 1; i <= newIndex; i++)
                {
                    var activityInCollection = dayCollection[i];
                    var changedOrder = activityInCollection.Order - 1;
                    
                    if (activityInCollection.IsChoiceBoard == true)
                    {
                        UpdateOrderInChoiceBoardAndItems(activityInCollection, changedOrder);
                    }
                    else
                    {
                        activityInCollection.Order = changedOrder;
                    }
                }
            }

            
            if (activityWithNotify.IsChoiceBoard == true)
            {
                UpdateOrderInChoiceBoardAndItems(activityWithNotify, newOrder);
            }
            else
            {
                activityWithNotify.Order = newOrder;
            }

            // Sort Collection
            //dayCollection.Sort((a,b) => a.CompareTo(b));
            dayCollection = dayCollection.OrderBy(a => a.Order).ToObservableCollection();
            _dayActivityCollections[dayChanged] = dayCollection;
            
            // Update order so indexes are correct on next use
            dayToReorder?.Activities.ForEach(a =>
            {
                var activityFromCollection = dayCollection.FirstOrDefault(awn => awn.Id == a.Id);
                if (activityFromCollection != null)
                {
                    a.Order = activityFromCollection?.Order;
                }
                
            });
            dayToReorder.Activities = dayToReorder.Activities.OrderBy(a => a.Order).ToList();
            
            _isDirty = true;
        }

        private void UpdateOrderInChoiceBoardAndItems(ActivityWithNotifyDTO choiceBoard, int? newOrder)
        {
            if (choiceBoard == null || choiceBoard.IsChoiceBoard != true || choiceBoard.ChoiceBoardID == null || newOrder == null)
            {
                throw new ArgumentException("One or both of provided arguments are invalid.");
            }


            if (_choiceBoardActivities.ContainsKey(choiceBoard.ChoiceBoardID))
            {
                DayEnum? day = FindDayEnumOfActivityById(choiceBoard.Id);
                var dayToReorder = WeekDTO.Days.FirstOrDefault(d => d.Day == day);

                foreach (var item in _choiceBoardActivities[choiceBoard.ChoiceBoardID])
                {
                    dayToReorder.Activities.FirstOrDefault(a => a.Id == item.Id).Order = newOrder;
                }
                _choiceBoardActivities[choiceBoard.ChoiceBoardID]?.ForEach(a => a.Order = newOrder);
            }

            choiceBoard.Order = newOrder;
        }

        #endregion

        
        #region ToggleDays
        
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

                bool confirmed = dayFromWeekDTO.Activities.Count <= 0 || await DialogService.ConfirmAsync(
                                     title: "Bekræft sletning af ugedag",
                                     message: "Hvis du sletter en ugedag med aktiviteter, sletter du samtidigt disse aktiviter. Er du sikker på, at du vil fortsætte?",
                                     okText: "Slet ugedag",
                                     cancelText: "Annuller");

				if (confirmed)
				{
					var removedDay = WeekDTO.Days.FirstOrDefault(dayObj => dayObj.Day == dayToggleWrapper.Day);
					if (removedDay == null) return;
					_removedWeekdayDTOs.Add(removedDay);
					WeekDTO.Days.Remove(removedDay);
				    _isDirty = true;
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
                WeekDTO.Days = WeekDTO.Days.OrderBy(dayObj => (int)dayObj.Day).ToList();
                _isDirty = true;

                dayToggleWrapper.IsToggled = dayToggleWrapper.SwitchToggled = true;
            }
        }

        private void FlipToggledDays()
        {
            if (ToggledDaysWrapper.Count == 0 || WeekDTO == null) return;

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                var toggleDayWrapper = ToggledDaysWrapper.FirstOrDefault(toggledDay => toggledDay.Day == day);

                if (toggleDayWrapper == null)
                    continue;

                toggleDayWrapper.IsToggled = toggleDayWrapper.SwitchToggled = WeekDTO.Days.Any(dayObj => dayObj.Day == day);
            }

            RaisePropertyChangedForDayLabels();
        }
        
        #endregion

        
        #region ChoiceBoardMethods
        
        private List<ActivityDTO> GetActivitiesForChoiceBoard(long? choiceBoardId)
        {
            if (_choiceBoardActivities.ContainsKey(choiceBoardId))
            {
                return _choiceBoardActivities[choiceBoardId].ToActivityDTOs().ToList();
            }
            return null;
        }
        
        protected Dictionary<DayEnum?, ObservableCollection<ActivityWithNotifyDTO>> FoldDaysToChoiceBoards(WeekDTO weekDTO)
        {
            Dictionary<DayEnum?, List<ActivityWithNotifyDTO>> activitiesForDays = weekDTO.Days
                .ToDictionary(key => key.Day, value => value.Activities.ToActivityWithNotifyDTOs().ToList());
            
            foreach (var dayActivities in activitiesForDays)
            {
                List<int?> orderOfChoiceBoards = new List<int?>();
                Queue<List<ActivityWithNotifyDTO>> choiceBoardItems = new Queue<List<ActivityWithNotifyDTO>>();

                // Find activities with same order, and add them to the choiceboard
                foreach (var activityGroup in dayActivities.Value.GroupBy(d => d.Order, d => d))
                {
                    if (activityGroup.Count() <= 1) continue;

                    List<ActivityWithNotifyDTO> aChoiceBoardItems = new List<ActivityWithNotifyDTO>();

                    foreach (var activity in activityGroup)
                    {
                        activity.State = StateEnum.Normal;
                        aChoiceBoardItems.Add(activity);
                    }
                    choiceBoardItems.Enqueue(aChoiceBoardItems);
                    orderOfChoiceBoards.Add(activityGroup.Key);
                }

                // Remove the choiceboard activities from the day and replace with a choiceboardActivity
                foreach (var order in orderOfChoiceBoards)
                {
					
                    var choiceId = _choiceBoardIds++;

                    dayActivities.Value.RemoveAll(a => a.Order == order);
                    var choiceBoard = new ActivityWithNotifyDTO(_standardChoiceBoardPictoDTO, order, StateEnum.Normal,
                        true, choiceId)
                    {
                        ChoiceBoardID = choiceId
                    };
                    dayActivities.Value.Add(choiceBoard);
                    
                    _choiceBoardActivities.Add(choiceId, choiceBoardItems.Dequeue());
                }
            }

            return activitiesForDays.ToDictionary(k => k.Key, v => v.Value.ToObservableCollection());
        }
        
        // TODO: Refactor these methods below
        
        private void UpdateChoiceBoard(ActivityDTO choiceBoard, ObservableCollection<ActivityDTO> choiceBoardItems)
        {
            var day = FindDayEnumOfActivityById(choiceBoard.Id);
            var activities = WeekDTO.Days.FirstOrDefault(d => d.Day == day).Activities;
            var orderForChoiceBoards = choiceBoard.Order;

            // Update WeekDTO
            // Set order to match the activityChanged
            choiceBoardItems.ForEach(cbi => cbi.Order = orderForChoiceBoards);

            
            // Remove old choiceboardItems and insert new ones in the weekDTO
            activities.RemoveAll(a => a.Order == orderForChoiceBoards);
            activities.AddRange(choiceBoardItems);
            
            // Insert into ChoiceBoardDictionary
            _choiceBoardActivities[choiceBoard.ChoiceBoardID] =
                choiceBoardItems.ToActivityWithNotifyDTOs().ToList();

            _isDirty = true;
        }

        private void RevertChoiceBoardToRegular(ActivityDTO choiceBoard, ActivityDTO replacementActivityDTO)
        {
            choiceBoard.IsChoiceBoard = false;
            
            // Cleanup choiceBoardDict
            _choiceBoardActivities.Remove(choiceBoard.ChoiceBoardID);
            
            // Change Activity in collection
            var (_, activityInCollection) = FindDayAndActivityWithNotifyDTOInWeekObservablesById(choiceBoard.Id);
            activityInCollection.IsChoiceBoard = false;
            activityInCollection.Pictogram = replacementActivityDTO.Pictogram;
            
            // Remove old choiceBoardItems from WeekDTO except for remaining
            var (day, activity) = FindDayAndActivityDTOInWeekDTOById(choiceBoard.Id);
            day.Activities.RemoveAll(a => a.Order == choiceBoard.Order && a.Id != choiceBoard.Id);
            activity.IsChoiceBoard = false;
            activity.State = StateEnum.Normal;
            activity.Pictogram = replacementActivityDTO.Pictogram;

            _isDirty = true;
        }

        private void ReplaceActivityWithChoiceBoard(ActivityDTO activityChangedToChoiceBoard, ObservableCollection<ActivityDTO> choiceBoardItems)
        {
            // Ignore choiceboards of size 1
            if (choiceBoardItems.Count == 1) return;
            
            var (day, activity) = FindDayAndActivityDTOInWeekDTOById(activityChangedToChoiceBoard.Id);
            
            
            // Update WeekDTO
            // Set ids to match the activityChanged
            choiceBoardItems.ForEach(cbi => cbi.Id = activity.Id);
            var newChoiceBoardId = _choiceBoardIds++;
            activity.ChoiceBoardID = newChoiceBoardId;
            activity.State = StateEnum.Normal;
            
            // Remove the activityChanged and insert all of the choiceBoardItems
            day.Activities.Remove(activity);
            day.Activities.AddRange(choiceBoardItems);
            
            // Insert into ChoiceBoardDictionary
            _choiceBoardActivities[activity.ChoiceBoardID] =
                choiceBoardItems.ToActivityWithNotifyDTOs().ToList();
            
            // Update activity in ObservableCollection
            var (_, activityInCollection) =
                FindDayAndActivityWithNotifyDTOInWeekObservablesById(activityChangedToChoiceBoard.Id);
            activityInCollection.IsChoiceBoard = true;
            activityInCollection.ChoiceBoardID = newChoiceBoardId;
            activityInCollection.Pictogram = _standardChoiceBoardPictoDTO;
            activityInCollection.State = StateEnum.Normal;
            
            _isDirty = true;
        }
        
        private void DeleteChoiceBoard(ActivityDTO choiceBoardDeleted)
        {
            var dayEnum = FindDayEnumOfActivityById(choiceBoardDeleted.Id);
            // Delete activities in weekDTO
            WeekDTO.Days.FirstOrDefault(d => d.Day == dayEnum).Activities.RemoveAll(a => a.Order == choiceBoardDeleted.Order);
            
            // Delete from observables
            var (dayCollection, activityInCollection) =
                FindDayAndActivityWithNotifyDTOInWeekObservablesById(choiceBoardDeleted.Id);
            dayCollection.Remove(activityInCollection);

			// Remove from choiceBoardDict
			_choiceBoardActivities.Remove(choiceBoardDeleted.ChoiceBoardID);

            _isDirty = true;
        }
        
        #endregion

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
            // Needed due to the hack with temporary ids, which, in turn, is needed for the ActivityWithNotifyDTO-hack
            SetTemporaryIdsToNullInWeekDTO();
            
            string onSuccesMessage = WeekDTO.WeekYear == null || WeekDTO.WeekNumber == null ?
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

            ClearObservableAndInsert();
        }

        private void ClearObservableAndInsert()
        {
            _dayActivityCollections.ForEach(d => d.Value.Clear());
            ClearDays();
            AddReferenceToDays();
            
            InsertActivityNotifyDTOsInWeekDays(WeekDTO);
            
        }

        private void ClearDays()
        {
            MondayPictos.Clear();
            TuesdayPictos.Clear();
            WednesdayPictos.Clear();
            ThursdayPictos.Clear();
            FridayPictos.Clear();
            SaturdayPictos.Clear();
            SundayPictos.Clear();
        }

        private void AddReferenceToDays()
        {
            _dayActivityCollections[DayEnum.Monday] = MondayPictos;
            _dayActivityCollections[DayEnum.Tuesday] = TuesdayPictos;
            _dayActivityCollections[DayEnum.Wednesday] = WednesdayPictos;
            _dayActivityCollections[DayEnum.Thursday] = ThursdayPictos;
            _dayActivityCollections[DayEnum.Friday] = FridayPictos;
            _dayActivityCollections[DayEnum.Saturday] = SaturdayPictos;
            _dayActivityCollections[DayEnum.Sunday] = SundayPictos;
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
                LandscapeOrGuardian = true;
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

        private bool _showOrientationButton = false;
        /// <summary>
        /// Returns the opposite of SettingsService.IsInGuardinMode.
        /// </summary>
        public bool ShowOrientationButton
        {
            get { return _showOrientationButton; }
            set
            {
                _showOrientationButton = value;
                RaisePropertyChanged(() => ShowOrientationButton);
            }
        }

        private bool _landscapeOrGuardian;

        public bool LandscapeOrGuardian
        {
            get { return _landscapeOrGuardian; }
            set
            {
                _landscapeOrGuardian = value;
                RaisePropertyChanged(() => LandscapeOrGuardian);
            }
        }


        public ICommand ToggleOrientationCommand => new Command(ToggleOrientation);

        private void ToggleOrientation()
        {
            if(Orientation == SettingDTO.OrientationEnum.Landscape)
            {
                PortraitOrientation();
                LandscapeOrGuardian = false;
            }
            else
            {
                LandscapeOrientation();
                LandscapeOrGuardian = true;
            }
        }

		private void PortraitOrientation()
		{
			MessagingCenter.Send(this, MessageKeys.SetOrientation, SettingDTO.OrientationEnum.Portrait);
			MessagingCenter.Send(this, MessageKeys.ChangeView, SettingDTO.OrientationEnum.Portrait);

            Orientation = SettingDTO.OrientationEnum.Portrait;
        }

		private void LandscapeOrientation()
		{
			MessagingCenter.Send(this, MessageKeys.SetOrientation, SettingDTO.OrientationEnum.Landscape);
			MessagingCenter.Send(this, MessageKeys.ChangeView, SettingDTO.OrientationEnum.Landscape);

            Orientation = SettingDTO.OrientationEnum.Landscape;
		}

		private bool WeekNameIsEmpty => string.IsNullOrEmpty(WeekName);

        protected virtual async Task ShowWeekNameEmptyPrompt()
        {
            await DialogService.ShowAlertAsync("Giv venligst ugeplanen et navn, og gem igen.", "Ok",
                "Ugeplanen blev ikke gemt");
        }

        [UsedImplicitly]
        public int Height
        {
            get
            {
                const int minimumHeight = 1500;
                const int elementHeight = 250;

                if (WeekDTO == null || WeekDTO.Days.Count == 0)
                {
                    return minimumHeight;
                }

                // Set height based on observable collection max element count
                int dynamicHeight = _dayActivityCollections.Values.Max(d => d.Count) * elementHeight;

                return dynamicHeight > minimumHeight ? dynamicHeight : minimumHeight;
            }
        }

        private void SetToCitizenMode()
        {
			ShowBackButton = false;
            ShowOrientationButton = true;
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
                WeekDTO == null && ToggledDaysWrapper.First(dayObj => dayObj.Day == day).SwitchToggled || //Happens upon initialization of the view. WeekDTO is still null at this point, so we rely on SwitchToggled for the day
                WeekDTO != null && WeekDTO.Days.Any(dayObj => dayObj.Day == day); //Happens when refreshing the view
        }

        private void SetToGuardianMode()
        {
            ShowBackButton = true;
            ShowOrientationButton = false;
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

        public ObservableCollection<ActivityWithNotifyDTO> MondayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> TuesdayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> WednesdayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> ThursdayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> FridayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> SaturdayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();
        public ObservableCollection<ActivityWithNotifyDTO> SundayPictos { get; } =
            new ObservableCollection<ActivityWithNotifyDTO>();

        private readonly Dictionary<DayEnum?, ObservableCollection<ActivityWithNotifyDTO>> _dayActivityCollections;

        private void InsertActivityNotifyDTOsInWeekDays(WeekDTO weekDTO)
        {
            var activiesForDays = FoldDaysToChoiceBoards(weekDTO);

            foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
            {
                if (activiesForDays.ContainsKey(day))
                {
                    activiesForDays[day] = activiesForDays[day].OrderBy(a => a.Order).ToObservableCollection();
                }
            }

            AddReferenceToDays();

            // Add so we keep the binding to observable collection
            activiesForDays.ForEach(kvp =>
            {
                _dayActivityCollections[kvp.Key].AddRange(kvp.Value);
            });
            
            
            RaisePropertyChanged(() => Height);
        }

        private void SetTemporaryIdsToNullInWeekDTO()
        {
            WeekDTO.Days.SelectMany(d => d.Activities)
                .Where(a => a.Id <= _temporaryActivityIds)
                .ForEach(a => { a.Id = null; });
        }

        protected void ToggleDaysAndOrderActivities()
        {
            FlipToggledDays();
            OrderActivitiesInAllDayCollectionsAndWeekDTO();
        }

        public override async Task OnReturnedToAsync(object navigationData)
        {
            switch (navigationData)
            {
                case WeekPictogramDTO weekPictogramDTO:
                    // Happens after choosing a pictogram in Pictosearch
                    InsertNewActivity(weekPictogramDTO);
                    break;
                case ValueTuple<ActivityDTO, string> tuple when tuple.Item2 == MessageKeys.ActivityDeleted:
                    // Happens when popping from ActivityViewModel and activity was deleted
                    RemoveActivity(tuple.Item1.ToActivityWithNotifyDTO());
                    break;
                case ValueTuple<ActivityDTO, string> tuple when tuple.Item2 == MessageKeys.ActivityUpdated:
                    // Happens when popping from ActivityViewModel and activity was updated
                    await UpdateActivity(tuple.Item1);
                    break;
                // Happens after logging in as guardian when switching to guardian mode
                case string s when s == MessageKeys.GuardianLoggedIn:
                    SetToGuardianMode();
                    break;
                case ValueTuple<ActivityDTO, ObservableCollection<ActivityDTO>, string> triple when triple.Item3 == MessageKeys.NewChoiceBoard:
                    ReplaceActivityWithChoiceBoard(triple.Item1, triple.Item2);
                    break;
                case ValueTuple<ActivityDTO, ObservableCollection<ActivityDTO>, string> triple when triple.Item3 == MessageKeys.UpdateChoiceBoard:
                    if (triple.Item2.Count == 1)
                    {
                        RevertChoiceBoardToRegular(triple.Item1, triple.Item2.SingleOrDefault());
                    }
                    else
                    {
                        UpdateChoiceBoard(triple.Item1, triple.Item2);
                    }
                    break;
                case ValueTuple<ActivityDTO, string> tuple when tuple.Item2 == MessageKeys.DeleteChoiceBoard:
                    DeleteChoiceBoard(tuple.Item1);
                    break;
                case ValueTuple<ActivityDTO, ObservableCollection<ActivityDTO>> tuple:

                    var day = FindDayEnumOfActivityById(tuple.Item1.Id);
                    DeleteChoiceBoard(tuple.Item1);
                    WeekDTO.Days.Single(d => d.Day == day).Activities.Add(tuple.Item2.First());
                    _dayActivityCollections[day].Add(tuple.Item2.First().ToActivityWithNotifyDTO());

                    await SaveOrUpdateSchedule();
                    break;
            }
            SetOrientation();
        }

        
        #region CRUD
        private async Task UpdateActivity(ActivityDTO alteredActivityDTO)
        {
            // Find activity in WeekDTO and update it
            var (dayChangedIn, activityToBeUpdated) = FindDayAndActivityDTOInWeekDTOById(alteredActivityDTO.Id);
            activityToBeUpdated.Pictogram = alteredActivityDTO.Pictogram;
            activityToBeUpdated.State = alteredActivityDTO.State;

            // Update it in observable collection
            var (_, activityWithNotifyToBeUpdated) =
                FindDayAndActivityWithNotifyDTOInWeekObservablesById(alteredActivityDTO.Id);
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
        
        private void InsertNewActivity(WeekPictogramDTO pictogramDTO)
        {
            var dayToAddTo = WeekDTO.Days.FirstOrDefault(d => d.Day == _weekdayToAddPictogramTo);
            var pictoCollectoToAddTo = _dayActivityCollections[_weekdayToAddPictogramTo];
            
            if (dayToAddTo == null && pictoCollectoToAddTo == null) return;
            
            // Insert pictogram in the very bottom of the day
            var newOrderInBottom = dayToAddTo?.Activities.Max(d => d.Order) + 1 ?? 0;
            ActivityDTO newActivityDTO = new ActivityDTO(pictogramDTO, newOrderInBottom, StateEnum.Normal, Id: _temporaryActivityIds++);
            dayToAddTo?.Activities.Add(newActivityDTO);
            
            // Add to collection
            pictoCollectoToAddTo.Add(newActivityDTO.ToActivityWithNotifyDTO());
            
            _isDirty = true;
            
            RaisePropertyChanged(() => Height);
        }

        private void RemoveActivity(ActivityWithNotifyDTO activityWithNotifyToBeRemoved)
        {
            var (dayChangedIn, activityToBeRemoved) = FindDayAndActivityDTOInWeekDTOById(activityWithNotifyToBeRemoved.Id);
           
            if (dayChangedIn != null && activityToBeRemoved != null)
            {
                // Remove from WeekDTO
                dayChangedIn.Activities.Remove(activityToBeRemoved);
            }

            var (_, activityInCollection) =
                FindDayAndActivityWithNotifyDTOInWeekObservablesById(activityWithNotifyToBeRemoved.Id);
            
            // Remove from ObservableCollection
            _dayActivityCollections[dayChangedIn.Day].Remove(activityInCollection);

            _isDirty = true;
        }
        #endregion
        
        #region FindHelpers
        private (WeekdayDTO, ActivityDTO) FindDayAndActivityDTOInWeekDTOById(long? id)
        {
            var dayContaining = WeekDTO.Days.FirstOrDefault(d => d.Activities.FirstOrDefault(a => a.Id == id) != null);
            return (dayContaining, dayContaining?.Activities.FirstOrDefault(a => a.Id == id));
        }

        private (ObservableCollection<ActivityWithNotifyDTO>, ActivityWithNotifyDTO) FindDayAndActivityWithNotifyDTOInWeekObservablesById(long? id)
        {
            var dayCollection =
                _dayActivityCollections.Values.FirstOrDefault(day => day.FirstOrDefault(act => act.Id == id) != null);
            var activity = dayCollection?.FirstOrDefault(act => act.Id == id);
            return (dayCollection, activity);
        }

        private DayEnum? FindDayEnumOfActivityById(long? activityId)
        {
            return _dayActivityCollections
                .FirstOrDefault(kvp => kvp.Value.FirstOrDefault(a => a.Id == activityId) != null).Key;
        }
        #endregion
    }
}