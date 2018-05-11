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
<<<<<<< HEAD
        private bool _editModeEnabled;
        private bool _selectModeEnabled;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _userModeImage;

        private List<StatefulPictogram> _selectedActivities;
        
        public bool EditModeEnabled
=======
        public ISettingsService SettingsService { get; }
        private bool _isDirty = false;

        private ActivityDTO _selectedActivity;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _toolbarButtonIcon;

        public WeekDTO WeekDTO
>>>>>>> master
        {
            get => _weekDto;
            set
            {
                _weekDto = value;
                RaisePropertyChanged(() => WeekDTO);
                RaisePropertyForDays();
            }
        }

<<<<<<< HEAD
        public bool SelectModeEnabled
        {
            get => _selectModeEnabled;
            set
            {
                _selectModeEnabled = value;
                RaisePropertyChanged(() => SelectModeEnabled);
            }
        }

        public WeekDTO WeekDTO
=======
        public string WeekName
>>>>>>> master
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
<<<<<<< HEAD
            _loginService = loginService;
            _selectedActivities = new List<StatefulPictogram>();
=======
            _requestService = requestService;
            SettingsService = settingsService;
>>>>>>> master

            OnBackButtonPressedCommand = new Command(async () => await BackButtonPressed());
            ShowToolbarButton = true;
            ToolbarButtonIcon = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
        }
        public ICommand ToggleSelectModeCommand  => new Command(() =>  ToggleSelectMode());

<<<<<<< HEAD
	    #region Message Callbacks (Insert, delete and SetToGuardianMode)
		private void InsertPicto(PictogramSearchViewModel sender, PictogramDTO pictogramDTO)
		{
			StatefulPictogram statefulPictogram = new StatefulPictogram(GlobalSettings.DefaultEndpoint + pictogramDTO.ImageUrl,
				PictogramState.Normal);
			WeekdayPictos[_weekdayToAddPictogramTo].Add(statefulPictogram);
			// Add pictogramId to the correct weekday
			// TODO: Fix
			RaisePropertyChanged(() => MondayPictos);
			RaisePropertyChanged(() => TuesdayPictos);
			RaisePropertyChanged(() => WednesdayPictos);
			RaisePropertyChanged(() => ThursdayPictos);
			RaisePropertyChanged(() => FridayPictos);
			RaisePropertyChanged(() => SaturdayPictos);
			RaisePropertyChanged(() => SundayPictos);
			RaisePropertyChanged(() => CountOfMaxHeightWeekday);
			RaisePropertyChanged(() => WeekdayPictos);
		}
	    
		private void DeleteActivity(ActivityViewModel activityVM, int activityID)
		{
			// TODO: Remove activityID from List<Resource> 
		}
	    
		private void SetToGuardianMode()
		{
			EditModeEnabled = true;
            SelectModeEnabled = false;
            _selectedActivities.Clear();
			UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_guardian.png");
			var tempDict = new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

			foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
			{
				tempDict.Add(day, new ObservableCollection<StatefulPictogram>());
			}

			foreach (WeekdayDTO dayDTO in WeekDTO.Days)
			{
				var weekday = dayDTO.Day.Value;
				ObservableCollection<StatefulPictogram> pictos = new ObservableCollection<StatefulPictogram>();
				foreach (var a in dayDTO.Activities)
				{
					pictos.Add(new StatefulPictogram(
						GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{a.Pictogram.Id}/image/raw", PictogramState.Normal));
				}

				tempDict[weekday] = pictos;
			}

			WeekdayPictos = tempDict;
		}
	    #endregion
	    
	    #region Command: ToggleEditMode
        public ICommand ToggleEditModeCommand => new Command(async () => await SwitchUserModeAsync());
	    private async Task SwitchUserModeAsync()
	    {
		    if (EditModeEnabled)
		    {
                if (SelectModeEnabled)
                {
                    foreach (StatefulPictogram activity in _selectedActivities)
                    {
                        activity.Border = "Transparent";
                    }
                    _selectedActivities.Clear();
                    SelectModeEnabled = false;
                }
                //SetBorderStatusPictograms(DateTime.Today.DayOfWeek);
			    EditModeEnabled = false;
			    UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
		    }
		    else
		    {
			    await NavigationService.NavigateToAsync<LoginViewModel>(this);
		    }
	    }
	    #endregion

	    #region Command: SavePicto
        public ICommand SaveCommand => new Command(async () => await SaveSchedule());
	    private async Task SaveSchedule()
	    {
		    bool confirmed = await _dialogService.ConfirmAsync(
			    title: "Gem ugeplan", 
			    message: "Vil du gemme ugeplanen?", 
			    okText: "Gem", 
			    cancelText: "Annuller");

		    if(!confirmed){
			    return;   
		    }
=======
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
>>>>>>> master
            
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

<<<<<<< HEAD
        public ICommand PictoClickedCommand =>  new Command<StatefulPictogram>(async activity =>
        {
            // mark activities start
            if (SelectModeEnabled)
            {
                if(_selectedActivities.Contains(activity)){
                    await DeSelectActivity(activity);
                }
                else
                {
                    await SelectActivity(activity);
                }
            }
            // mark activities end 
        });


	    #region InitAsync: Show weekplan

		public override async Task InitializeAsync(object navigationData)
		{
			if (navigationData is UserNameDTO userNameDTO)
			{
				await _loginService.LoginAndThenAsync(GetWeekPlanForCitizenAsync, UserType.Citizen,
					userNameDTO.UserName);
			}
			else
			{
				throw new ArgumentException("Must be of type userNameDTO", nameof(navigationData));
			}
		}

		// TODO: Handle situation where no days exist
		private async Task GetWeekPlanForCitizenAsync()
		{
			// TODO: Make dynamic regarding weekId
			await _requestService.SendRequestAndThenAsync(this,
				requestAsync: async () => await _weekApi.V1WeekByIdGetAsync(1),
				onSuccessAsync: async result =>
				{
					WeekDTO = result.Data;
					SetWeekdayPictos();
				},
				onExceptionAsync: async () => await NavigationService.PopAsync(),
				onRequestFailedAsync: async () => await NavigationService.PopAsync()
			);
		}

		private void SetWeekdayPictos()
		{
			var tempDict = new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

			foreach (DayEnum day in Enum.GetValues(typeof(DayEnum)))
			{
				tempDict.Add(day, new ObservableCollection<StatefulPictogram>());
			}

			foreach (WeekdayDTO dayDTO in WeekDTO.Days)
			{
				if (dayDTO.Day == null) continue;
				var weekday = dayDTO.Day.Value;
				ObservableCollection<StatefulPictogram> pictos = new ObservableCollection<StatefulPictogram>();
				foreach (var eleID in dayDTO.Activities.Select(a => a.Pictogram.Id))
				{
					pictos.Add(new StatefulPictogram(
						GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw", PictogramState.Normal));
				}

				tempDict[weekday] = pictos;
			}

			WeekdayPictos = tempDict;
		}
	    #endregion


		#region Boilerplate for each weekday's pictos

		private Dictionary<DayEnum, ObservableCollection<StatefulPictogram>> _weekdayPictos =
			new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

		public Dictionary<DayEnum, ObservableCollection<StatefulPictogram>> WeekdayPictos
		{
			get => _weekdayPictos;
			set
			{
				_weekdayPictos = value;
				RaisePropertyChanged(() => MondayPictos);
				RaisePropertyChanged(() => TuesdayPictos);
				RaisePropertyChanged(() => WednesdayPictos);
				RaisePropertyChanged(() => ThursdayPictos);
				RaisePropertyChanged(() => FridayPictos);
				RaisePropertyChanged(() => SaturdayPictos);
				RaisePropertyChanged(() => SundayPictos);
				RaisePropertyChanged(() => CountOfMaxHeightWeekday);
				RaisePropertyChanged(() => WeekdayPictos);
			}
		}

		public int CountOfMaxHeightWeekday
		{
			get { return _weekdayPictos.Any() ? _weekdayPictos.Max(w => GetPictosOrEmptyList(w.Key).Count) : 0; }
		}

		public ObservableCollection<StatefulPictogram> MondayPictos => GetPictosOrEmptyList(DayEnum.Monday);

		public ObservableCollection<StatefulPictogram> TuesdayPictos => GetPictosOrEmptyList(DayEnum.Tuesday);

		public ObservableCollection<StatefulPictogram> WednesdayPictos => GetPictosOrEmptyList(DayEnum.Wednesday);

		public ObservableCollection<StatefulPictogram> ThursdayPictos => GetPictosOrEmptyList(DayEnum.Thursday);

		public ObservableCollection<StatefulPictogram> FridayPictos => GetPictosOrEmptyList(DayEnum.Friday);

		public ObservableCollection<StatefulPictogram> SaturdayPictos => GetPictosOrEmptyList(DayEnum.Saturday);

		public ObservableCollection<StatefulPictogram> SundayPictos => GetPictosOrEmptyList(DayEnum.Sunday);

		private ObservableCollection<StatefulPictogram> GetPictosOrEmptyList(DayEnum day)
		{
			if (!WeekdayPictos.TryGetValue(day, out var pictoSources))
				pictoSources = new ObservableCollection<StatefulPictogram>();
			return new ObservableCollection<StatefulPictogram>(pictoSources);
		}
		#endregion

		#region Highlighting pictogram

		// An enum type for determining which state a pictogram is in.
		public enum PictogramState
		{
			Normal = 0,
			Cancelled = 1,
			Checked = 2
		}

		/// <summary>
		///  Converts a DayOfWeek to a WeekdayDTO
		/// </summary>
		public class DateTimeConverter
		{
			// Convert a specific day.
			public DayEnum GetWeekDay(DayOfWeek weekDay)
			{
				switch (weekDay)
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
						throw new ArgumentException($"{weekDay} is not valid");
				}
			}
		}

		public void SetBorderStatusPictograms(DayOfWeek weekday)
		{
			// Find the current day in WeekDTO object.
			DateTimeConverter dateTimeConverter = new DateTimeConverter();

			// Find the first pictogram, that are: normal state and first.
			foreach (var weekDayPicto in WeekdayPictos)
			{
				if (weekDayPicto.Key == dateTimeConverter.GetWeekDay(weekday))
				{
					weekDayPicto.Value.Where(s => s.PictogramState == PictogramState.Normal).First().Border = "Black";
					return;
				}
			}
		}

		/// <summary>
		///  A mock class for pictograms, it contains both the URL and State of a pictogram. 
		/// </summary>
        public class StatefulPictogram : ExtendedBindableObject
		{
			private string _url;

			public string URL
			{
				get { return _url; }
				set { _url = value; }
			}

			private PictogramState _pictogramState;

			public PictogramState PictogramState
			{
				get { return _pictogramState; }
				set { _pictogramState = value; }
			}

			private string _border;

			public string Border
			{
				get { return _border; }
				set 
                { 
                    _border = value;
                    RaisePropertyChanged(() => Border);
                }
			}

			public StatefulPictogram(string url, PictogramState pictogramState)
			{
				PictogramState = pictogramState;
				URL = url;
				Border = "Lime";
			}
		}
		#endregion

        private async Task SelectActivity(StatefulPictogram activity){
            _selectedActivities.Add(activity);
            activity.Border = "Blue";
        }

        private async Task DeSelectActivity(StatefulPictogram activity)
        {
            _selectedActivities.Remove(activity);
            activity.Border = "Transparent";
        }

        private async Task ToggleSelectMode()
        {
            if (SelectModeEnabled)
            {
                foreach(StatefulPictogram activity in _selectedActivities){
                    activity.Border = "Transparent";
                }
                _selectedActivities.Clear();
                SelectModeEnabled = false;
            }
            else
            {
                SelectModeEnabled = true;
=======
            // Happens when popping from ActivityViewModel
            if (navigationData is ActivityViewModel activityViewModel && activityViewModel.Activity == null)
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
            else if (navigationData is ActivityViewModel activityVM)
            {
                _selectedActivity = activityVM.Activity;
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
>>>>>>> master
            }
        }
    }
}