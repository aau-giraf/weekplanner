using System;
using System.Globalization;
using Autofac;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Services.Settings;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class IdToRawPictoUrlConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var id = (long?)value;
            
            using(var scope = AppContainer.Container.BeginLifetimeScope())
            {
                var settingsService = scope.Resolve<ISettingsService>();
                return settingsService.BaseEndpoint + $"/v1/pictogram/{id}/image/raw";
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
