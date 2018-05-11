using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

namespace WeekPlanner.Helpers
{
    public static class YearAndWeekHelper
    {
        // The GetIso8601WeekOfYear method is taken directly from https://stackoverflow.com/a/11155102 // https://blogs.msdn.microsoft.com/shawnste/2006/01/24/iso-8601-week-of-year-format-in-microsoft-net/
        //ISO8601 is the standard way of determining week numbering used in Denmark (https://da.wikipedia.org/wiki/Uge#Ugenummerering)
        // This presumes that weeks start with Monday.
        // Week 1 is the 1st week of the year with a Thursday in it. 
        public static int GetIso8601WeekOfYear(DateTime time)
        {
            // Seriously cheat.  If its Monday, Tuesday or Wednesday, then it'll 
            // be the same week# as whatever Thursday, Friday or Saturday are,
            // and we always get those right
            DayOfWeek day = CultureInfo.InvariantCulture.Calendar.GetDayOfWeek(time);
            if (day >= DayOfWeek.Monday && day <= DayOfWeek.Wednesday)
            {
                time = time.AddDays(3);
            }

            // Return the week of our adjusted day
            return CultureInfo.InvariantCulture.Calendar.GetWeekOfYear(time, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
        }

        //Gets the dates of the week corresponding to to the weeknumber and date
        public static DateTime[] GetDaysOfWeekByWeekNumber(DateTime date, int weekNumber)
        {
            if (date == null || weekNumber < 1)
                throw new ArgumentException("Invalid arguments: " + date == null ? "date parameter is null." : "Cannot convert a negative week number to a valid date");

            DateTime start = new DateTime(date.Year, 1, 1);
            DateTime firstDayOfFirstWeekOfYear;

            //Set firstDayOfFirstWeekOfYear to be the first monday of week 1 of the year
            //Note that the first monday of week 1 of any given year MAY be in december!
            //Also note that DayOfWeek.Monday = 1 and DayOfWeek.Sunday = 0
            if (start.DayOfWeek >= DayOfWeek.Monday && start.DayOfWeek <= DayOfWeek.Thursday)
            {
                firstDayOfFirstWeekOfYear = start.AddDays(-(int)start.DayOfWeek + 1);
            }
            else
            {
                firstDayOfFirstWeekOfYear = start.AddDays(start.DayOfWeek == DayOfWeek.Sunday ? 1 : 8 - (int)start.DayOfWeek);
            }

            DateTime result = firstDayOfFirstWeekOfYear.AddDays(7 * weekNumber - 7);

            return Enumerable.Range(0, 7).Select(dayNumber => result.AddDays(dayNumber)).ToArray();
        }
    }
}
