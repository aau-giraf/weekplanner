using System;
using System.Collections.Generic;
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

namespace WeekPlanner.ViewModels
{
    public class SettingsViewModel : ViewModelBase
    {
        private readonly ISettingsService _settingsService;
        private readonly IRequestService _requestService;
        private readonly IUserApi _userApi;

        public IEnumerable<SettingDTO.ThemeEnum> Themes => new List<SettingDTO.ThemeEnum>{
            SettingDTO.ThemeEnum.AndroidBlue, SettingDTO.ThemeEnum.GirafGreen, SettingDTO.ThemeEnum.GirafRed, SettingDTO.ThemeEnum.GirafYellow
        };

        public SettingDTO.ThemeEnum ThemeSelected
        {
            get => _settingsService.CurrentCitizenSettingDTO.Theme;
            set
            {
                var currentTheme = Application.Current.Resources;
                switch (value)
                {
                    case SettingDTO.ThemeEnum.GirafRed:
                        currentTheme.MergedWith = typeof(Themes.RedTheme);
                        SetThemeInSettingDTOAndUpdate(value);
                        break;
                    case SettingDTO.ThemeEnum.GirafYellow:
                        currentTheme.MergedWith = typeof(Themes.OrangeTheme);
                        SetThemeInSettingDTOAndUpdate(value);
                        break;
                    case SettingDTO.ThemeEnum.AndroidBlue:
                        currentTheme.MergedWith = typeof(Themes.BlueTheme);
                        SetThemeInSettingDTOAndUpdate(value);
                        break;
                    case SettingDTO.ThemeEnum.GirafGreen:
                        currentTheme.MergedWith = typeof(Themes.GreenTheme);
                        SetThemeInSettingDTOAndUpdate(value);
                        break;
                    default:
                        break;
                }
                RaisePropertyChanged(() => ThemeSelected);
            }
        }

        private void SetThemeInSettingDTOAndUpdate(SettingDTO.ThemeEnum pickedTheme)
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

        private void UpdateSettings(string key, Color value, int day)
        {
            _settingsService.CurrentCitizenSettingDTO.WeekDayColors = _settingsService.CurrentCitizenSettingDTO.WeekDayColors.OrderBy(wd => wd.Day).ToList();
            _settingsService.CurrentCitizenSettingDTO.WeekDayColors[day].HexColor = ColorToHex(value);
            Application.Current.Resources[key] = value;
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

        public string MondaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[0].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => MondayColorSelected);
                UpdateSettings("MondayColor", _weekdayColorsDict[value], 0);
            }
        }

        public Color MondayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[0].HexColor);

        public string TuesdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[1].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => TuesdayColorSelected);
                UpdateSettings("TuesdayColor", _weekdayColorsDict[value], 1);
            }
        }

        public Color TuesdayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[1].HexColor);

        public string WednesdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[2].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => WednesdayColorSelected);
                UpdateSettings("WednesdayColor", _weekdayColorsDict[value], 2);
            }
        }

        public Color WednesdayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[2].HexColor);

        public string ThursdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[3].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => ThursdayColorSelected);
                UpdateSettings("ThursdayColor", _weekdayColorsDict[value], 3);
            }
        }

        public Color ThursdayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[3].HexColor);

        public string FridaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[4].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => FridayColorSelected);
                UpdateSettings("FridayColor", _weekdayColorsDict[value], 4);
            }
        }

        public Color FridayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[4].HexColor);

        public string SaturdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[5].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => SaturdayColorSelected);
                UpdateSettings("SaturdayColor", _weekdayColorsDict[value], 5);
            }
        }

        public Color SaturdayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[5].HexColor);

        public string SundaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[6].HexColor)).Key; }
            set
            {
                RaisePropertyChanged(() => SundayColorSelected);
                UpdateSettings("SundayColor", _weekdayColorsDict[value], 6);
            }
        }

        public Color SundayColorSelected => Color.FromHex(_settingsService.CurrentCitizenSettingDTO.WeekDayColors[6].HexColor);

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

        public SettingDTO Settings => _settingsService.CurrentCitizenSettingDTO;

        public SettingsViewModel(ISettingsService settingsService, INavigationService navigationService, 
            IRequestService requestService, IUserApi userApi) : base(navigationService)
        {
            _settingsService = settingsService;
            _requestService = requestService;
            _userApi = userApi;
        }
    }
}