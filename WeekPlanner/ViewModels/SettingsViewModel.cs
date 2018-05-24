using System;
using System.Collections.Generic;
using System.Linq;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using IO.Swagger.Model;
using WeekPlanner.Services.Request;
using IO.Swagger.Api;
using System.Threading.Tasks;

namespace WeekPlanner
{
	public class SettingsViewModel : ViewModelBase
	{
		private readonly ISettingsService _settingsService;
		private readonly IRequestService _requestService;
		private readonly IUserApi _userApi;
		public SettingsViewModel(INavigationService navigationService, ISettingsService settingsService, IRequestService requestService, IUserApi userApi) : base(navigationService)
		{
			_settingsService = settingsService;
			_requestService = requestService;
			_userApi = userApi;
		}

		public IEnumerable<string> WeekdayColours => _weekdayColorsDict.Keys.ToList();
		Dictionary<string, Color> _weekdayColorsDict = new Dictionary<string, Color>
		{
			{"Aqua", Color.Aqua},
			{"Sort", Color.Black},
			{"Blå", Color.FromHex("#0017ff")},
			{"Fucshia", Color.Fuchsia},
			{"Grå", Color.Gray},
			{"Grøn", Color.FromHex("#067700")},
			{"Lime", Color.Lime},
			{"Maroon", Color.Maroon},
			{"Navy", Color.Navy},
			{"Oliven", Color.Olive},
			{"Lilla", Color.FromHex("#8c1086")},
			{"Rød", Color.FromHex("#ff0102")},
			{"Sølv", Color.Silver},
			{"Teal", Color.Teal},
			{"Hvid", Color.FromHex("#ffffff")},
			{"Gul", Color.FromHex("#ffdd00")},
			{"Orange", Color.FromHex("#ff7f00")}
		};

		public static string ColorToHex(Color color)
		{
			var red = (int)(color.R * 255);
			var green = (int)(color.G * 255);
			var blue = (int)(color.B * 255);
			var hex = $"#{red:X2}{green:X2}{blue:X2}";
			return hex;
		}

		private string _selectedMondayColour = "Rød";
		public string SelectedMondayColour
		{
			get
			{
				return _selectedMondayColour;
			}
			set
			{
				_selectedMondayColour = value;
				_settingsService.CurrentCitizenSettingDTO.WeekDayColors.First((WeekDayColorDTO wdc) => wdc.Day == WeekDayColorDTO.DayEnum.Monday)
								.HexColor = ColorToHex(MondayColour);
				RaisePropertyChanged(() => MondayColour);
				RaisePropertyChanged(() => UpdateSettings());
			}
		}
		public SettingDTO Settings => _settingsService.CurrentCitizenSettingDTO;
		public async Task UpdateSettings()
		{
			await _requestService.SendRequest(_userApi.V1UserByIdSettingsPutAsync(_settingsService.CurrentCitizen.UserId, Settings));
		}
		public Color MondayColour => _weekdayColorsDict[SelectedMondayColour];

	}
}
