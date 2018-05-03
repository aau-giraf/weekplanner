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

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private readonly ILoginService _loginService;
        private readonly IRequestService _requestService;
        private readonly IWeekApi _weekApi;
        private readonly IDialogService _dialogService;
        private bool _editModeEnabled;
        private bool _selectModeEnabled;
        private WeekDTO _weekDto;
        private DayEnum _weekdayToAddPictogramTo;
        private ImageSource _userModeImage;

        private List<StatefulPictogram> _selectedActivities;
        
        public bool EditModeEnabled
        {
            get => _editModeEnabled;
            set
            {
                _editModeEnabled = value;
                RaisePropertyChanged(() => EditModeEnabled);
            }
        }

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
        {
            get => _weekDto;
            set
            {
                _weekDto = value;
                RaisePropertyChanged(() => WeekDTO);
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
	    
        public WeekPlannerViewModel(INavigationService navigationService, ILoginService loginService, 
            IRequestService requestService, IWeekApi weekApi, IDialogService dialogService) : base(navigationService)
        {
            _requestService = requestService;
            _weekApi = weekApi;
            _dialogService = dialogService;
            _loginService = loginService;
            _selectedActivities = new List<StatefulPictogram>();

            UserModeImage = (FileImageSource)ImageSource.FromFile("icon_default_citizen.png");
            
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                InsertPicto);
            MessagingCenter.Subscribe<ActivityViewModel, int>(this, MessageKeys.DeleteActivity,
                DeleteActivity);
            MessagingCenter.Subscribe<LoginViewModel>(this, MessageKeys.LoginSucceeded, (sender) => SetToGuardianMode());
        }
        public ICommand ToggleSelectModeCommand  => new Command(() =>  ToggleSelectMode());

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
            
		    if (WeekDTO.Id is null)
		    {
			    await SaveNewSchedule();
		    }
		    else
		    {
			    await UpdateExistingSchedule();
		    }
	    }
	    
	    private async Task SaveNewSchedule()
	    {
		    await _requestService.SendRequestAndThenAsync(this,
			    async () => await _weekApi.V1WeekPostAsync(WeekDTO), result => 
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
            
		    await _requestService.SendRequestAndThenAsync(this,
			    async () => await _weekApi.V1WeekByIdPutAsync((int) WeekDTO.Id, WeekDTO),
			    result =>
			    {
				    _dialogService.ShowAlertAsync(message: $"Ugeplanen '{result.Data.Name}' blev gemt.");
			    });
	    }
	    
	    #endregion

        public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
        {
            _weekdayToAddPictogramTo = weekday;
            await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        });

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
            }
        }
    }
}