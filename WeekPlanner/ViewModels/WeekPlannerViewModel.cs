using System;
using System.IO;
using IO.Swagger.Model;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Login;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using WeekPlanner.Services.Settings;
using System.Windows.Input;
using WeekPlanner.Views;
using static IO.Swagger.Model.WeekdayDTO;

namespace WeekPlanner.ViewModels
{
	public class WeekPlannerViewModel : ViewModelBase
	{
		private readonly IWeekApi _weekApi;
		private readonly IPictogramApi _pictogramApi;
		private readonly ILoginService _loginService;

		private bool _editModeEnabled;
		private WeekDTO _weekDto;
		private DayEnum _weekdayToAddPictogramTo;

		public bool EditModeEnabled
		{
			get { return _editModeEnabled; }
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
			}
		}

		public ICommand ToggleEditModeCommand => new Command(() => EditModeEnabled = !EditModeEnabled);

		public ICommand NavigateToPictoSearchCommand => new Command<DayEnum>(async weekday =>
		{
			_weekdayToAddPictogramTo = weekday;
			await NavigationService.NavigateToAsync<PictogramSearchViewModel>();
		});

		public WeekPlannerViewModel(INavigationService navigationService, IWeekApi weekApi,
			ILoginService loginService, IPictogramApi pictogramApi) : base(navigationService)
		{
			_weekApi = weekApi;
			_pictogramApi = pictogramApi;
			_loginService = loginService;
			MessagingCenter.Subscribe<WeekPlannerPage>(this, MessageKeys.ScheduleSaveRequest,
				async _ => await SaveSchedule());
			MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
				InsertPicto);
		}

		private void InsertPicto(PictogramSearchViewModel sender, PictogramDTO pictogramDTO)
		{
			String imgSource =
				GlobalSettings.DefaultEndpoint + pictogramDTO.ImageUrl;
			WeekdayPictos[_weekdayToAddPictogramTo].Add(new StatefulPictogram(imgSource, PictogramState.Normal));

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


		private async Task SaveSchedule()
		{
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
			ResponseWeekDTO result;

			try
			{
				// Saves new schedule
				result = await _weekApi.V1WeekPostAsync(WeekDTO);
			}
			catch (ApiException)
			{
				SendRequestFailedMessage();
				return;
			}

			if (result.Success == true)
			{
				MessagingCenter.Send(this, MessageKeys.RequestSucceeded,
					$"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
			}
			else
			{
				SendRequestFailedMessage(result.ErrorKey);
			}
		}

		private async Task UpdateExistingSchedule()
		{
			if (WeekDTO.Id == null)
			{
				throw new InvalidDataException("WeekDTO should always have an Id when updating.");
			}

			ResponseWeekDTO result;
			try
			{
				// TODO remove cast to int when backend has been fixed
				result = await _weekApi.V1WeekByIdPutAsync((int)WeekDTO.Id, WeekDTO);
			}
			catch (ApiException)
			{
				SendRequestFailedMessage();
				return;
			}

			if (result.Success == true)
			{
				MessagingCenter.Send(this, MessageKeys.RequestSucceeded, $"Ugeplanen '{result.Data.Name}' blev gemt.");
			}
			else
			{
				SendRequestFailedMessage(result.ErrorKey);
			}
		}

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

		// TODO: Cleanup method and rename
		private async Task GetWeekPlanForCitizenAsync()
		{
			ResponseWeekDTO result;
			try
			{
				// TODO: Find the correct id to retrieve : Modal view -> choose what schedule (probably current by default)
				result = await _weekApi.V1WeekByIdGetAsync(1);
			}
			catch (ApiException)
			{
				SendRequestFailedMessage();
				await NavigationService.PopAsync();
				return;
			}

			if (result.Success == true && result.Data.Days != null)
			{
				WeekDTO = result.Data;
				SetWeekdayPictos();
			}
			else
			{
				SendRequestFailedMessage(result.ErrorKey);
				await NavigationService.PopAsync();
			}
		}

		private void SetWeekdayPictos()
		{
			var tempDict = new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();
			foreach (WeekdayDTO day in WeekDTO.Days)
			{
				var weekday = day.Day.Value;
				ObservableCollection<StatefulPictogram> pictos = new ObservableCollection<StatefulPictogram>();
				foreach (var eleID in day.ElementIDs)
				{
					pictos.Add(
						new StatefulPictogram(GlobalSettings.DefaultEndpoint + $"/v1/pictogram/{eleID}/image/raw", PictogramState.Normal));
				}

				tempDict.Add(weekday, pictos);
			}

			WeekdayPictos = tempDict;
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
					weekDayPicto.Value.Where((s) => s.PictogramState == PictogramState.Normal).First().Border = "Black";
					return;
				}
			}
		}

		#region Boilerplate for each weekday's pictos

		private Dictionary<DayEnum, ObservableCollection<StatefulPictogram>> _weekdayPictos =
			new Dictionary<DayEnum, ObservableCollection<StatefulPictogram>>();

		public Dictionary<DayEnum, ObservableCollection<StatefulPictogram>> WeekdayPictos
		{
			get => _weekdayPictos;
			set
			{
				_weekdayPictos = value;
				SetBorderStatusPictograms(DateTime.Today.DayOfWeek);
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
			if (!WeekdayPictos.TryGetValue(day, out var pictogramMocks))
				pictogramMocks = new ObservableCollection<StatefulPictogram>();



			return new ObservableCollection<StatefulPictogram>(pictogramMocks);
		}

		#endregion

		private void SendRequestFailedMessage(
			ResponseWeekDTO.ErrorKeyEnum? errorKeyEnum = ResponseWeekDTO.ErrorKeyEnum.Error)
		{
			var friendlyErrorMessage = errorKeyEnum.ToFriendlyString();
			MessagingCenter.Send(this, MessageKeys.RequestFailed, friendlyErrorMessage);
		}
	}


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
		public DateTimeConverter()
		{
		}

		// Convert a specific day.
		public WeekdayDTO.DayEnum GetWeekDay(DayOfWeek weekDay)
		{
			switch (weekDay)
			{
				case DayOfWeek.Monday:
					return WeekdayDTO.DayEnum.Monday;
				case DayOfWeek.Tuesday:
					return WeekdayDTO.DayEnum.Tuesday;
				case DayOfWeek.Wednesday:
					return WeekdayDTO.DayEnum.Wednesday;
				case DayOfWeek.Thursday:
					return WeekdayDTO.DayEnum.Thursday;
				case DayOfWeek.Friday:
					return WeekdayDTO.DayEnum.Friday;
				case DayOfWeek.Saturday:
					return WeekdayDTO.DayEnum.Saturday;
				case DayOfWeek.Sunday:
					return WeekdayDTO.DayEnum.Sunday;
				default:
					return WeekdayDTO.DayEnum.Monday;
			}
		}
	}

	/// <summary>
	///  A mock class for pictograms, it contains both the URL and State of a pictogram. 
	/// </summary>
	public class StatefulPictogram
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
			}
		}

		public StatefulPictogram(string url, PictogramState pictogramState)
		{
			PictogramState = pictogramState;
			URL = url;
			Border = "Transparent";
		}
	}
}