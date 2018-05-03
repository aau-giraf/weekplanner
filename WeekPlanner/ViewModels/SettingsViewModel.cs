using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
	public class SettingsViewModel : ViewModelBase
	{
		private readonly ISettingsService _settingsService;
		private readonly IRequestService _requestService;
		private readonly IDialogService _dialogService;
		private readonly IUserApi _userApi;

		private GirafUserDTO _girafCitizen;
		public GirafUserDTO GirafCitizen
		{
			get => _girafCitizen;
			set
			{
				_girafCitizen = value;
				RaisePropertyChanged(() => GirafCitizen);
			}
		}

		private bool _orientationSlider;
		public bool OrientationSwitch
		{
			get => _orientationSlider;
			set
			{
				if (Settings.Orientation == SettingDTO.OrientationEnum.Portrait)
				{
					_orientationSlider = true;
				}
				else
				{
					_orientationSlider = false;
				}
				RaisePropertyChanged(() => OrientationSwitch);
				UpdateSettingsAsync();
			}
		}
		Dictionary<string, Color> _weekdayColorsDict = new Dictionary<string, Color>
		{
			{ "Aqua", Color.Aqua }, { "Sort", Color.Black },
			{ "Blå", Color.Blue }, { "Fucshia", Color.Fuchsia },
			{ "Grå", Color.Gray }, { "Grøn", Color.Green },
			{ "Lime", Color.Lime }, { "Maroon", Color.Maroon },
			{ "Navy", Color.Navy }, { "Oliven", Color.Olive },
			{ "Lilla", Color.Purple }, { "Rød", Color.Red },
			{ "Sølv", Color.Silver }, { "Teal", Color.Teal },
			{ "Hvid", Color.White }, { "Gul", Color.Yellow },
			{ "Orange", Color.Orange }
		};

		public List<string> WeekdayColors
		{
			get
			{
				var returnList = new List<string>();
				foreach (var elem in _weekdayColorsDict.Keys)
				{
					returnList.Add(elem);
				}

				return returnList;
			}
		}

		string _mondaySelectedColor = "Grøn";
		public string MondaySelectedColor { get { return _mondaySelectedColor; } set { RaisePropertyChanged(() => MondayColorSelected); _mondaySelectedColor = value; } }
		public Color MondayColorSelected { get { return _weekdayColorsDict[_mondaySelectedColor]; } }

		string _tuesdaySelectedColor = "Lilla";
		public string TuesdaySelectedColor { get { return _tuesdaySelectedColor; } set { RaisePropertyChanged(() => TuesdayColorSelected); _tuesdaySelectedColor = value; } }
		public Color TuesdayColorSelected { get { return _weekdayColorsDict[_tuesdaySelectedColor]; } }

		string _wednessdaySelectedColor = "Orange";
		public string WednessdaySelectedColor { get { return _wednessdaySelectedColor; } set { RaisePropertyChanged(() => WednessdayColorSelected); _wednessdaySelectedColor = value; } }
		public Color WednessdayColorSelected { get { return _weekdayColorsDict[_wednessdaySelectedColor]; } }

		string _thursdaySelectedColor = "Blå";
		public string ThursdaySelectedColor { get { return _thursdaySelectedColor; } set { RaisePropertyChanged(() => ThursdayColorSelected); _thursdaySelectedColor = value; } }
		public Color ThursdayColorSelected { get { return _weekdayColorsDict[_thursdaySelectedColor]; } }

		string _fridaySelectedColor = "Gul";
		public string FridaySelectedColor { get { return _fridaySelectedColor; } set { RaisePropertyChanged(() => FridayColorSelected); _fridaySelectedColor = value; } }
		public Color FridayColorSelected { get { return _weekdayColorsDict[_fridaySelectedColor]; } }

		string _saturdaySelectedColor = "Rød";
		public string SaturdaySelectedColor { get { return _saturdaySelectedColor; } set { RaisePropertyChanged(() => SaturdayColorSelected); _saturdaySelectedColor = value; } }
		public Color SaturdayColorSelected { get { return _weekdayColorsDict[_saturdaySelectedColor]; } }

		string _sundaySelectedColor = "Hvid";
		public string SundaySelectedColor { get { return _sundaySelectedColor; } set { RaisePropertyChanged(() => SundayColorSelected); _sundaySelectedColor = value; } }
		public Color SundayColorSelected { get { return _weekdayColorsDict[_sundaySelectedColor]; } }

		public string HexTestString
		{
			get { return ColorToHexConverter(_weekdayColorsDict[_mondaySelectedColor]); }
		}

		public string[] WeekdayHexColors
		{
			get
			{
				return new string[7] {ColorToHexConverter(_weekdayColorsDict[_mondaySelectedColor]),
										ColorToHexConverter(_weekdayColorsDict[_tuesdaySelectedColor]),
										ColorToHexConverter(_weekdayColorsDict[_wednessdaySelectedColor]),
										ColorToHexConverter(_weekdayColorsDict[_thursdaySelectedColor]),
										ColorToHexConverter(_weekdayColorsDict[_fridaySelectedColor]),
										ColorToHexConverter(_weekdayColorsDict[_saturdaySelectedColor]),
										ColorToHexConverter(_weekdayColorsDict[_sundaySelectedColor])
				};
			}
		}

		public string ColorToHexConverter(Color color)
		{
			var red = (int)(color.R * 255);
			var green = (int)(color.G * 255);
			var blue = (int)(color.B * 255);
			var alpha = (int)(color.A * 255);
			var hex = $"#{alpha:X2}{red:X2}{green:X2}{blue:X2}";

			return hex;
		}

		public ICommand HandleSwitchChangedCommand => new Command(() =>
		{
			if (Settings.Orientation == SettingDTO.OrientationEnum.Portrait)
			{
				Settings.Orientation = SettingDTO.OrientationEnum.Landscape;
			}
			else
			{
				Settings.Orientation = SettingDTO.OrientationEnum.Portrait;
			}
		});


		private async void UpdateSettingsAsync()
		{
			await _requestService.SendRequestAndThenAsync(
				requestAsync: () => _userApi.V1UserByIdSettingsPatchAsync(_settingsService.CurrentCitizenId, _settings),
				onSuccess: dto => { });
		}


		private SettingDTO.OrientationEnum _orientationSetting;
		private SettingDTO _settings;

		public SettingDTO Settings
		{
			get => _settings;
			set
			{
				_settings = value;
				RaisePropertyChanged(() => Settings);
			}
		}



		public SettingsViewModel(ISettingsService settingsService, INavigationService navigationService,
			IDialogService dialogService, IRequestService requestService, IUserApi userApi) : base(navigationService)
		{
			_settingsService = settingsService;
			_requestService = requestService;
			_userApi = userApi;
			_dialogService = dialogService;

		}

		public override async Task InitializeAsync(object navigationData)
		{
			_settingsService.UseTokenFor(UserType.Citizen);
			await InitializeCitizen();
		}

		private async Task InitializeCitizen()
		{
			await _requestService.SendRequestAndThenAsync(
				requestAsync: async () => await _userApi.V1UserGetAsync(),
				onSuccessAsync: async result =>
				{
					GirafCitizen = result.Data;
					await InitalizeSettings();
				},
				onExceptionAsync: async () => await NavigationService.PopAsync(),
				onRequestFailedAsync: async () => await NavigationService.PopAsync());
		}

		private async Task InitalizeSettings()
		{
			await _requestService.SendRequestAndThenAsync(
				requestAsync: async () => await _userApi.V1UserSettingsGetAsync(),
				onSuccess: result =>
				{
					Settings = result.Data;
				},
				onExceptionAsync: async () => await NavigationService.PopAsync(),
				onRequestFailedAsync: async () => await NavigationService.PopAsync());
		}
	}
}
