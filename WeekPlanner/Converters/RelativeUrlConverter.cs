using System;
using System.Globalization;
using Autofac;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Services.Settings;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class RelativeUrlConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var url = (string)value;
            
            using(var scope = AppContainer.Container.BeginLifetimeScope())
            {
                var settingsService = scope.Resolve<ISettingsService>();
                return settingsService.BaseEndpoint + url;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
