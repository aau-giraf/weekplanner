using System;
using System.Globalization;
using Xamarin.Forms;
using static IO.Swagger.Model.ActivityDTO;

namespace WeekPlanner.Converters
{
    public class StateToOutlineConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            StateEnum? state = (StateEnum?)value;

            switch(state) {
                case StateEnum.Normal:
                case null:
                    return Color.Transparent;
                case StateEnum.Active:
                    return Color.SeaGreen;
                case StateEnum.Canceled:
                    return Color.Tomato;
                case StateEnum.Completed:
                    return Color.DarkGreen;
                default:
                    throw new NotSupportedException("StateToOutlineColor doesn't support this state");
            }

        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
