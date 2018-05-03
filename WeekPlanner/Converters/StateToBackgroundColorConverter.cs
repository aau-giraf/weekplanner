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
                case StateEnum.Active:
                case null:
                    return Color.Blue;
                case StateEnum.Canceled:
                    return Color.Red;
                case StateEnum.Completed:
                    return Color.Green;
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
