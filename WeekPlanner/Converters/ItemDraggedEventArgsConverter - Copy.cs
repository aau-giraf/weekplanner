using System;
using System.Globalization;
using Syncfusion.ListView.XForms;
using Xamarin.Forms;

namespace WeekPlanner.Converters
{
    public class ItemDraggedEventArgsConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (!(value is ItemDraggingEventArgs eventArgs))
                throw new ArgumentException("Expected TappedEventArgs as value", nameof(value));

            return eventArgs.ItemData;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}