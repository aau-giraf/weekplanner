using System;
using IO.Swagger.Model;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public partial class WeekPlannerViewModel
    {
        /// <inheritdoc />
        /// <summary>
        /// Small wrapper for handling which days have been toggled.
        /// Inheritance from Switch means we don't have to manually handle PropertyChanged etc.
        /// </summary>
        public class DayToggledWrapper : Switch
        {
            public readonly WeekdayDTO.DayEnum Day;

            //SwitchToggled is used for visual purposes (see binding of schedule days in .XAML)
            private bool _switchToggled;
            public bool SwitchToggled
            {
                get => _switchToggled;
                set
                {
                    _switchToggled = value;
                    OnPropertyChanged(nameof(SwitchToggled));
                }
            }

            public bool InternalChange;

            public DayToggledWrapper(WeekdayDTO.DayEnum day, EventHandler<ToggledEventArgs> toggledEventCallback)
            {
                IsToggled = SwitchToggled = true;
                Day = day;
                Toggled += toggledEventCallback;
                InternalChange = false;
            }
        }
    }
}