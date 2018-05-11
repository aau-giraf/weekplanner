using System;
using System.Globalization;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class CitizenToSettingsTitle : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return "Instillinger for " + value;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}