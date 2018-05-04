using System;
using System.Globalization;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class CitizenIdIsSetConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return false;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}