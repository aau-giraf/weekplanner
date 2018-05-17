using System;
using System.Globalization;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    class NegateBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            bool? editModeEnabled = value as bool?;

            return editModeEnabled == null ? false : !editModeEnabled;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
