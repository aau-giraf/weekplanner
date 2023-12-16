/// Adds functionality for calculating week number
extension DateTimeExtension on DateTime {


  /// Calculates the current week number from a given date
  int _getWeekNumberFromDate(DateTime date) {
    // Get the preliminary week number
    final int weekNum = _getWeekNumberFromNearestThursday(date);

    /// Define a day that is in the last week of the year.
    /// ## December 28th is always in the last week of the year ##
    final DateTime dayInLastWeekThisYear = DateTime(date.year, 12, 28);
    final DateTime dayInLastWeekLastYear = DateTime(date.year - 1, 12, 28);

    // If the preliminary week number is 0,
    // the given date is in last year's last week
    if (weekNum == 0) {
      return _getWeekNumberFromNearestThursday(dayInLastWeekLastYear);
    }
    // If the preliminary week number is bigger than the amount of weeks in
    // the given date's year, it is in the next year's week 1
    else if (weekNum >
        _getWeekNumberFromNearestThursday(dayInLastWeekThisYear)) {
      return 1;
    }
    // If none of the cases described above are true, the
    // preliminary week number is the actual week number
    else {
      return weekNum;
    }
  }

  /// Calculates the week number from the nearest Thursday of the given date
  int _getWeekNumberFromNearestThursday(DateTime date) {
    // Sets the time of day to be noon, thus mitigating the summer time issue
    date = DateTime(date.year, date.month, date.day, 12);

    // Find the number of days we are into the year. June 1st would be day 153
    final int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;

    const int dayOfWeekThursday = 4;

    // Find the day of the year for the nearest Thursday to the given date.
    // ## The week number for the given date,
    //    is the same as its nearest Thursday's ##
    final int nearestThursday = (dayOfYear - date.weekday) + dayOfWeekThursday;

    // Find how many weeks have passed since the first Thursday plus 1 as:
    // ## The first Thursday of a year is always in week 1 ##
    return (nearestThursday / 7).floor() + 1;
  }

  /// Gets the current weeknumber as an integer
  int get weekNumber {
    return _getWeekNumberFromDate(DateTime.now());
  }
}