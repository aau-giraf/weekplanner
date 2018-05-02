using System;
using System.Globalization;
using WeekPlanner.ViewModels;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class StateToBackgroundColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            switch ((State)value)
            {
                case State.Normal:
                    return Color.Blue;
                case State.Checked:
                    return Color.Green;
                case State.Cancelled:
                    return Color.Red;

            }
            throw new NotImplementedException();
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
