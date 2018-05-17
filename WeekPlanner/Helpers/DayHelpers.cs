using System;
using IO.Swagger.Model;

namespace WeekPlanner.Helpers
{
    public static class DayHelpers
    {
        public static WeekdayDTO.DayEnum GetCurrentDay()
        {
            var today = DateTime.Today.DayOfWeek;
            switch (today)
            {
                case DayOfWeek.Monday:
                    return WeekdayDTO.DayEnum.Monday;
                case DayOfWeek.Tuesday:
                    return WeekdayDTO.DayEnum.Tuesday;
                case DayOfWeek.Wednesday:
                    return WeekdayDTO.DayEnum.Wednesday;
                case DayOfWeek.Thursday:
                    return WeekdayDTO.DayEnum.Thursday;
                case DayOfWeek.Friday:
                    return WeekdayDTO.DayEnum.Friday;
                case DayOfWeek.Saturday:
                    return WeekdayDTO.DayEnum.Saturday;
                case DayOfWeek.Sunday:
                    return WeekdayDTO.DayEnum.Sunday;
                default:
                    throw new NotSupportedException("DayEnum out of bounds");
            }

        }

        public static string TranslateCurrentDay()
        {
            switch (GetCurrentDay())
            {
                case WeekdayDTO.DayEnum.Monday:
                    return "Mandag";
                case WeekdayDTO.DayEnum.Tuesday:
                    return "Tirsdag";
                case WeekdayDTO.DayEnum.Wednesday:
                    return "Onsdag";
                case WeekdayDTO.DayEnum.Thursday:
                    return "Torsdag";
                case WeekdayDTO.DayEnum.Friday:
                    return "Fredag";
                case WeekdayDTO.DayEnum.Saturday:
                    return "Lørdag";
                case WeekdayDTO.DayEnum.Sunday:
                    return "Søndag";
                default:
                    throw new NotSupportedException("DayEnum out of bounds");
            }
        }

        public static WeekDayColorDTO.DayEnum GetCurrentColorDay()
        {
            switch (GetCurrentDay())
            {
                case WeekdayDTO.DayEnum.Monday:
                    return WeekDayColorDTO.DayEnum.Monday;
                case WeekdayDTO.DayEnum.Tuesday:
                    return WeekDayColorDTO.DayEnum.Tuesday;
                case WeekdayDTO.DayEnum.Wednesday:
                    return WeekDayColorDTO.DayEnum.Wednesday;
                case WeekdayDTO.DayEnum.Thursday:
                    return WeekDayColorDTO.DayEnum.Thursday;
                case WeekdayDTO.DayEnum.Friday:
                    return WeekDayColorDTO.DayEnum.Friday;
                case WeekdayDTO.DayEnum.Saturday:
                    return WeekDayColorDTO.DayEnum.Saturday;
                case WeekdayDTO.DayEnum.Sunday:
                    return WeekDayColorDTO.DayEnum.Sunday;
                default:
                    throw new NotSupportedException("ColorDayEnum out of bounds");
            }
        }
    }
}