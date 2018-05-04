using System;
using System.Globalization;
using Xamarin.Forms;
using static IO.Swagger.Model.ActivityDTO;

namespace WeekPlanner.Converters
{
    public class StateToImageConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            StateEnum state = (StateEnum)value;

            switch(state) {
                case StateEnum.Canceled:
                    return ImageSource.FromFile("icon_cross.png");
                case StateEnum.Completed:
                    return ImageSource.FromFile("icon_check_mark.png");
                default:
                    return null;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
