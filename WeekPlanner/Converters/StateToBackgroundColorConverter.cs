using System;
using System.Globalization;
using Xamarin.Forms;
using static IO.Swagger.Model.ActivityDTO;

namespace WeekPlanner.Converters
{
    public class StateToBackgroundColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            StateEnum? state = (StateEnum?)value;
            switch(state) {
                case null:
                case StateEnum.Normal:
                    return Color.Blue;
                case StateEnum.Active:
                    return Color.SeaGreen;
                case StateEnum.Canceled:
                    return Color.Red;
                case StateEnum.Completed:
                    return Color.DarkGreen;
                default:
                    throw new NotSupportedException("StateToBackgroundConverter");
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
