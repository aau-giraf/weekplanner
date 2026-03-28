import 'package:intl/intl.dart';

/// Platform-agnostic time-of-day so domain/data layers avoid importing Flutter.
typedef TimeValue = ({int hour, int minute});

/// Parse a time string like "HH:mm" or "HH:mm:ss" into a [TimeValue].
///
/// Returns `null` if the string cannot be parsed.
TimeValue? parseTimeValue(String time) {
  final parts = time.split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return (hour: hour, minute: minute);
}

/// Format a [TimeValue] as "HH:mm".
String formatTimeValue(TimeValue t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Format a [TimeValue] as "HH:mm:ss" for API serialization.
String formatTimeValueForApi(TimeValue t) => '${formatTimeValue(t)}:00';

class GirafDateUtils {
  /// Returns the ISO 8601 week number for a given date.
  static int getWeekNumber(DateTime date) {
    // Find the Thursday of the current week (ISO weeks are defined by their Thursday)
    final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));
    // Week 1 is the week containing January 4th
    final jan4 = DateTime(thursday.year, 1, 4);
    final jan4Thursday = jan4.add(Duration(days: DateTime.thursday - jan4.weekday));
    final weekNumber =
        ((thursday.difference(jan4Thursday).inDays) / 7).floor() + 1;
    return weekNumber;
  }

  /// Returns 7 dates (Monday to Sunday) for the week containing [date].
  static List<DateTime> getWeekDates(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => DateTime(monday.year, monday.month, monday.day + i));
  }

  /// Formats a date as DD/MM.
  static String formatDateDDMM(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  /// Formats a date as YYYY-MM-DD for API queries.
  static String formatQueryDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats a time as HH:mm.
  static String formatTimeHHMM(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Returns the day name for a weekday number (1=Monday).
  static String dayName(int weekday) {
    const names = ['Mandag', 'Tirsdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lørdag', 'Søndag'];
    return names[weekday - 1];
  }

  /// Short day name (3 chars).
  static String dayNameShort(int weekday) {
    const names = ['Man', 'Tir', 'Ons', 'Tor', 'Fre', 'Lør', 'Søn'];
    return names[weekday - 1];
  }
}
