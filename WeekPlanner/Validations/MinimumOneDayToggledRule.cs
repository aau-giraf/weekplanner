using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using WeekPlanner.ViewModels;

namespace WeekPlanner.Validations
{
    public class MinimumOneDayToggledRule<T> : IValidationRule<T>
    {
        public string ValidationMessage { get; set; }

        public bool Check(T value)
        {
            if(!(value is ICollection<NewScheduleViewModel.DayToggledWrapper> toggledDays))
            {
                return false;
            }

            bool result = false;
            foreach(NewScheduleViewModel.DayToggledWrapper day in toggledDays)
            {
                result |= day.IsToggled;
                if (result) break;
            }

            return result;
        }
    }
}
