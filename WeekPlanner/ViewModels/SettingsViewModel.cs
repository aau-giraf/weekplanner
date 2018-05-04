using System;
using System.Collections.Generic;
using System.Linq;
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

        private IEnumerable<SettingDTO.ThemeEnum> _themes = new List<SettingDTO.ThemeEnum>(){
            SettingDTO.ThemeEnum.AndroidBlue, SettingDTO.ThemeEnum.GirafGreen, SettingDTO.ThemeEnum.GirafRed, SettingDTO.ThemeEnum.GirafYellow
        };
        public IEnumerable<SettingDTO.ThemeEnum> Themes => _themes;


        private SettingDTO.ThemeEnum _themeSelected;
        public SettingDTO.ThemeEnum ThemeSelected
        {
            get => _themeSelected;
            set
            {
                var currentTheme = Application.Current.Resources;
                _themeSelected = value;
                switch (value)
                {
                    case SettingDTO.ThemeEnum.GirafRed:
                        currentTheme.MergedWith = typeof(Themes.RedTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    case SettingDTO.ThemeEnum.GirafYellow:
                        currentTheme.MergedWith = typeof(Themes.OrangeTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    case SettingDTO.ThemeEnum.AndroidBlue:
                        currentTheme.MergedWith = typeof(Themes.BlueTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    case SettingDTO.ThemeEnum.GirafGreen:
                        currentTheme.MergedWith = typeof(Themes.GreenTheme);
                        SetThemeInSettingDTOAntUpdate(_themeSelected);
                        break;
                    default:
                        break;
                }
                RaisePropertyChanged(() => ThemeSelected);
            }
        }

        private void SetThemeInSettingDTOAntUpdate(SettingDTO.ThemeEnum pickedTheme)
        {
            Settings.Theme = pickedTheme;
            UpdateSettingsAsync();
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
        #region Weekplan Colours
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

        public List<string> WeekdayColors => _weekdayColorsDict.Keys.ToList();

        private void UpdateSettings(string key, Color value, int day)
        {
            var weekPlanTheme = WeekdayHexColors;
            _settingsService.CurrentCitizenSettingDTO.WeekDayColors = _settingsService.CurrentCitizenSettingDTO.WeekDayColors.OrderBy(wd => wd.Day).ToList();
            _settingsService.CurrentCitizenSettingDTO.WeekDayColors[day].HexColor = ColorToHex(value);
            App.Current.Resources[key] = value;
            UpdateSettingsAsync();
        }

        public static string ColorToHex(Color color)
        {
            return RGBToHexadecimal(color.R, color.G, color.B);
        }
        public static string RGBToHexadecimal(double r, double g, double b)
        {
            string rs = DecimalToHexadecimal((int)(r * 255));
            string gs = DecimalToHexadecimal((int)(g * 255));
            string bs = DecimalToHexadecimal((int)(b * 255));

            return '#' + rs + gs + bs;
        }

        public string[] WeekdayHexColors
        {
            get
            {
                return new string[7]
                {
                    ColorToHex(_weekdayColorsDict[MondaySelectedColor]),
                    ColorToHex(_weekdayColorsDict[TuesdaySelectedColor]),
                    ColorToHex(_weekdayColorsDict[WednesdaySelectedColor]),
                    ColorToHex(_weekdayColorsDict[ThursdaySelectedColor]),
                    ColorToHex(_weekdayColorsDict[FridaySelectedColor]),
                    ColorToHex(_weekdayColorsDict[SaturdaySelectedColor]),
                    ColorToHex(_weekdayColorsDict[SundaySelectedColor])
                };
            }
        }

        private static string DecimalToHexadecimal(int dec)
        {
            if (dec <= 0)
                return "00";

            int hex = dec;
            string hexStr = string.Empty;

            hex = dec % 16;

            if (hex < 10)
                hexStr = hexStr.Insert(0, Convert.ToChar(hex + 48).ToString());
            else
                hexStr = hexStr.Insert(0, Convert.ToChar(hex + 55).ToString());

            dec /= 16;


            hex = dec % 16;

            if (hex < 10)
                hexStr = hexStr.Insert(0, Convert.ToChar(hex + 48).ToString());
            else
                hexStr = hexStr.Insert(0, Convert.ToChar(hex + 55).ToString());

            dec /= 16;

            return hexStr;
        }

        string _mondaySelectedColor = "Grøn";

        public string MondaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[0].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => MondayColorSelected);
                _mondaySelectedColor = value;
                UpdateSettings("MondayColor", _weekdayColorsDict[value], 0);
            }
        }

        public Color MondayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[0].HexColor); }
        }

        string _tuesdaySelectedColor = "Lilla";
        public string TuesdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[1].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => TuesdayColorSelected);
                _tuesdaySelectedColor = value;
                UpdateSettings("TuesdayColor", _weekdayColorsDict[value], 1);
            }
        }

        public Color TuesdayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[1].HexColor); }
        }

        string _wednesdaySelectedColor = "Orange";

        public string WednesdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[2].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => WednesdayColorSelected);

                _wednesdaySelectedColor = value;
                UpdateSettings("WednesdayColor", _weekdayColorsDict[value], 2);
            }
        }

        public Color WednesdayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[2].HexColor); }
        }

        string _thursdaySelectedColor = "Blå";

        public string ThursdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[3].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => ThursdayColorSelected);
                _thursdaySelectedColor = value;
                UpdateSettings("ThursdayColor", _weekdayColorsDict[value], 3);
            }
        }

        public Color ThursdayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[3].HexColor); }
        }

        string _fridaySelectedColor = "Gul";

        public string FridaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[4].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => FridayColorSelected);
                _fridaySelectedColor = value;
                UpdateSettings("FridayColor", _weekdayColorsDict[value], 4);
            }
        }

        public Color FridayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[4].HexColor); }
        }

        string _saturdaySelectedColor = "Rød";

        public string SaturdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[5].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => SaturdayColorSelected);
                _saturdaySelectedColor = value;
                UpdateSettings("SaturdayColor", _weekdayColorsDict[value], 5);
            }
        }

        public Color SaturdayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[5].HexColor); }
        }

        string _sundaySelectedColor = "Hvid";

        public string SundaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[6].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => SundayColorSelected);
                _sundaySelectedColor = value;
                UpdateSettings("SundayColor", _weekdayColorsDict[value], 6);
            }
        }

        public Color SundayColorSelected
        {
            get { return Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[6].HexColor); }
        }

        #endregion

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
            _settingsService.UseTokenFor(UserType.Citizen);
            await _requestService.SendRequestAndThenAsync(
                requestAsync: () => _userApi.V1UserSettingsPatchAsync(Settings),
                onSuccess: dto => { });
        }


        private SettingDTO.OrientationEnum _orientationSetting;

        public SettingDTO Settings
        {
            get => _settingsService.CurrentCitizenSettingDTO;
            set
            {
                _settingsService.CurrentCitizenSettingDTO = value;
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
            _settingsService.UseTokenFor(UserType.Citizen);
            await _requestService.SendRequestAndThenAsync(
                requestAsync: async () => await _userApi.V1UserGetAsync(),
                onSuccess: result =>
                {
                    GirafCitizen = result.Data;
                },
                onExceptionAsync: async () => await NavigationService.PopAsync(),
                onRequestFailedAsync: async () => await NavigationService.PopAsync());
        }

    }
}