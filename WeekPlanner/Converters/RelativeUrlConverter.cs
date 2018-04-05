using System;
using System.Globalization;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class RelativeUrlConverter : IValueConverter
    {
        public RelativeUrlConverter()
        {
        }

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var url = (String)value;
            return GlobalSettings.DefaultEndpoint + url;

        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
