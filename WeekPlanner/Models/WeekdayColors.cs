using System.Collections.Generic;
using System.Linq;
using IO.Swagger.Model;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Models
{
    public class WeekdayColors : ExtendedBindableObject
    {
        readonly SettingDTO _settings;

        public WeekdayColors(SettingDTO settings)
        {
            _settings = settings;
        }
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

        public List<string> ColorNames => _weekdayColorsDict.Keys.ToList();

        public static string ColorToHex(Color color)
        {
            var red = (int)(color.R * 255);
            var green = (int)(color.G * 255);
            var blue = (int)(color.B * 255);
            var hex = $"#{red:X2}{green:X2}{blue:X2}";

            return hex;
        }

        public string MondaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[0].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["MondayColor"] = hex;
                _settings.WeekDayColors[0].HexColor = hex;
                RaisePropertyChanged(() => MondayHexColor);
            }
        }

        public Color MondayHexColor => Color.FromHex(_settings.WeekDayColors[0].HexColor);

        public string TuesdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[1].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["TuesdayColor"] = hex;
                _settings.WeekDayColors[1].HexColor = hex;
                RaisePropertyChanged(() => TuesdayHexColor);
            }
        }

        public Color TuesdayHexColor => Color.FromHex(_settings.WeekDayColors[1].HexColor);

        public string WednesdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[2].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["WednesdayColor"] = hex;
                _settings.WeekDayColors[2].HexColor = hex;
                RaisePropertyChanged(() => WednesdayHexColor);
            }
        }

        public Color WednesdayHexColor => Color.FromHex(_settings.WeekDayColors[2].HexColor);

        public string ThursdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[3].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["ThursdayColor"] = hex;
                _settings.WeekDayColors[3].HexColor = hex;
                RaisePropertyChanged(() => ThursdayHexColor);
            }
        }

        public Color ThursdayHexColor => Color.FromHex(_settings.WeekDayColors[3].HexColor);

        public string FridaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[4].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["FridayColor"] = hex;
                _settings.WeekDayColors[4].HexColor = hex;
                RaisePropertyChanged(() => FridayHexColor);
            }
        }

        public Color FridayHexColor => Color.FromHex(_settings.WeekDayColors[4].HexColor);

        public string SaturdaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[5].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["SaturdayColor"] = hex;
                _settings.WeekDayColors[5].HexColor = hex;
                RaisePropertyChanged(() => SaturdayHexColor);
            }
        }

        public Color SaturdayHexColor => Color.FromHex(_settings.WeekDayColors[5].HexColor);

        public string SundaySelectedColor
        {
            get { return _weekdayColorsDict.First(color => color.Value == Color.FromHex(_settings.WeekDayColors[6].HexColor)).Key; }
            set
            {
                var hex = ColorToHex(_weekdayColorsDict[value]);
                Application.Current.Resources["SundayColor"] = hex;
                _settings.WeekDayColors[6].HexColor = hex;
                RaisePropertyChanged(() => SundayHexColor);
            }
        }

        public Color SundayHexColor => Color.FromHex(_settings.WeekDayColors[6].HexColor);
    }
}
