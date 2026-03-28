import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

void main() {
  group('GirafDateUtils', () {
    group('getWeekNumber', () {
      test('returns correct week number for a known date', () {
        // 2025-01-06 is Monday of week 2
        expect(GirafDateUtils.getWeekNumber(DateTime(2025, 1, 6)), 2);
      });

      test('returns week 1 for first days of 2025', () {
        // 2024-12-30 is Monday of week 1 of 2025 (ISO)
        expect(GirafDateUtils.getWeekNumber(DateTime(2024, 12, 30)), 1);
      });

      test('handles year boundary correctly', () {
        // 2024-12-28 is Saturday of week 52 of 2024
        expect(GirafDateUtils.getWeekNumber(DateTime(2024, 12, 28)), 52);
      });

      test('returns week 53 for years with 53 weeks', () {
        // 2020 has 53 weeks, Dec 31 2020 is Thursday
        expect(GirafDateUtils.getWeekNumber(DateTime(2020, 12, 31)), 53);
      });
    });

    group('getWeekDates', () {
      test('returns 7 dates', () {
        final dates = GirafDateUtils.getWeekDates(DateTime(2025, 3, 19));
        expect(dates.length, 7);
      });

      test('first date is Monday', () {
        final dates = GirafDateUtils.getWeekDates(DateTime(2025, 3, 19));
        expect(dates[0].weekday, DateTime.monday);
      });

      test('last date is Sunday', () {
        final dates = GirafDateUtils.getWeekDates(DateTime(2025, 3, 19));
        expect(dates[6].weekday, DateTime.sunday);
      });

      test('dates are consecutive', () {
        final dates = GirafDateUtils.getWeekDates(DateTime(2025, 3, 19));
        for (int i = 1; i < dates.length; i++) {
          expect(dates[i].difference(dates[i - 1]).inDays, 1);
        }
      });

      test('returns correct week when given a Sunday', () {
        // 2025-03-23 is a Sunday
        final dates = GirafDateUtils.getWeekDates(DateTime(2025, 3, 23));
        expect(dates[0], DateTime(2025, 3, 17)); // Monday
        expect(dates[6], DateTime(2025, 3, 23)); // Sunday
      });
    });

    group('formatQueryDate', () {
      test('formats date as yyyy-MM-dd', () {
        expect(
          GirafDateUtils.formatQueryDate(DateTime(2025, 3, 5)),
          '2025-03-05',
        );
      });
    });

    group('formatDateDDMM', () {
      test('formats date as dd/MM', () {
        expect(
          GirafDateUtils.formatDateDDMM(DateTime(2025, 3, 5)),
          '05/03',
        );
      });
    });

    group('formatTimeHHMM', () {
      test('formats time as HH:mm', () {
        expect(
          GirafDateUtils.formatTimeHHMM(DateTime(2025, 3, 5, 14, 30)),
          '14:30',
        );
      });
    });

    group('dayName', () {
      test('returns correct Danish day names', () {
        expect(GirafDateUtils.dayName(1), 'Mandag');
        expect(GirafDateUtils.dayName(5), 'Fredag');
        expect(GirafDateUtils.dayName(7), 'Søndag');
      });
    });

    group('dayNameShort', () {
      test('returns correct short Danish day names', () {
        expect(GirafDateUtils.dayNameShort(1), 'Man');
        expect(GirafDateUtils.dayNameShort(7), 'Søn');
      });
    });
  });

  group('parseTimeValue', () {
    test('parses HH:mm format', () {
      expect(parseTimeValue('08:30'), (hour: 8, minute: 30));
    });

    test('parses HH:mm:ss format (ignores seconds)', () {
      expect(parseTimeValue('14:05:00'), (hour: 14, minute: 5));
    });

    test('returns null for empty string', () {
      expect(parseTimeValue(''), isNull);
    });

    test('returns null for single segment', () {
      expect(parseTimeValue('8'), isNull);
    });

    test('returns null for non-numeric parts', () {
      expect(parseTimeValue('abc:def'), isNull);
    });

    test('returns null for out-of-range hour', () {
      expect(parseTimeValue('25:00'), isNull);
    });

    test('returns null for out-of-range minute', () {
      expect(parseTimeValue('12:60'), isNull);
    });

    test('returns null for negative values', () {
      expect(parseTimeValue('-1:30'), isNull);
    });

    test('parses boundary values', () {
      expect(parseTimeValue('00:00'), (hour: 0, minute: 0));
      expect(parseTimeValue('23:59'), (hour: 23, minute: 59));
    });
  });

  group('formatTimeValue', () {
    test('formats as HH:mm with zero padding', () {
      expect(formatTimeValue((hour: 8, minute: 5)), '08:05');
    });

    test('formats double-digit values', () {
      expect(formatTimeValue((hour: 14, minute: 30)), '14:30');
    });
  });

  group('formatTimeValueForApi', () {
    test('appends :00 seconds', () {
      expect(formatTimeValueForApi((hour: 8, minute: 30)), '08:30:00');
    });
  });
}
