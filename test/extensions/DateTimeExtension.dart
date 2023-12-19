import 'package:weekplanner/extensions/DateTimeWeekExtension.dart';
import 'package:async_test/async_test.dart';
import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  
  DateTime date = DateTime(2020,10,14);

  group('customWeekNumber', () {
/*
  This test is to find errors with customWeekNumber if the next test
  fails on one if its 4000 cases. It might not be enough though. More dates
  can be added to cover more cases. Good luck!

  The test is skipped for now (Remove skip from the end of the test)
   */
    test('Check if the correct week number is returned', async((DoneFn done) {
/* Semi-random checks */
      expect(date.customWeekNumber(DateTime(2020, 10, 14)), 42);
      expect(date.customWeekNumber(DateTime(2020, 10, 7)), 41);
      expect(date.customWeekNumber(DateTime(2020, 12, 28)), 53);
      expect(date.customWeekNumber(DateTime(2020, 12, 31)), 53);
      expect(date.customWeekNumber(DateTime(2021, 1, 3)), 53);
      expect(date.customWeekNumber(DateTime(2021, 1, 4)), 1);
      expect(date.customWeekNumber(DateTime(2021, 6, 20)), 24);
      expect(date.customWeekNumber(DateTime(2021, 6, 21)), 25);
      expect(date.customWeekNumber(DateTime(2021, 12, 26)), 51);
      expect(date.customWeekNumber(DateTime(2021, 12, 27)), 52);
      expect(date.customWeekNumber(DateTime(2022, 1, 2)), 52);
      expect(date.customWeekNumber(DateTime(2022, 1, 3)), 1);
      expect(date.customWeekNumber(DateTime(2022, 3, 27)), 12);
      expect(date.customWeekNumber(DateTime(2022, 3, 28)), 13);
      expect(date.customWeekNumber(DateTime(2022, 10, 30)), 43);
      expect(date.customWeekNumber(DateTime(2022, 10, 31)), 44);

/* These next expects checks the same week in years where the
     first of January starts on different week days.
     */

/* Monday */
      expect(date.customWeekNumber(DateTime(2024, 3, 10)), 10);
      expect(date.customWeekNumber(DateTime(2024, 3, 11)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 12)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 13)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 14)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 16)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 17)), 11);
      expect(date.customWeekNumber(DateTime(2024, 3, 18)), 12);

/* Tuesday */
      expect(date.customWeekNumber(DateTime(2030, 3, 10)), 10);
      expect(date.customWeekNumber(DateTime(2030, 3, 11)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 12)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 13)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 14)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 16)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 17)), 11);
      expect(date.customWeekNumber(DateTime(2030, 3, 18)), 12);

/* Wednesday */
      expect(date.customWeekNumber(DateTime(2025, 3, 9)), 10);
      expect(date.customWeekNumber(DateTime(2025, 3, 10)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 11)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 12)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 13)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 14)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 16)), 11);
      expect(date.customWeekNumber(DateTime(2025, 3, 17)), 12);

/* Thursday */
      expect(date.customWeekNumber(DateTime(2026, 3, 8)), 10);
      expect(date.customWeekNumber(DateTime(2026, 3, 9)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 10)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 11)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 12)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 13)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 14)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2026, 3, 16)), 12);

/* Friday */
      expect(date.customWeekNumber(DateTime(2021, 3, 14)), 10);
      expect(date.customWeekNumber(DateTime(2021, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 16)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 17)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 18)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 19)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 20)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 21)), 11);
      expect(date.customWeekNumber(DateTime(2021, 3, 22)), 12);

/* Saturday */
      expect(date.customWeekNumber(DateTime(2022, 3, 13)), 10);
      expect(date.customWeekNumber(DateTime(2022, 3, 14)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 16)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 17)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 18)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 19)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 20)), 11);
      expect(date.customWeekNumber(DateTime(2022, 3, 21)), 12);

/* Sunday */
      expect(date.customWeekNumber(DateTime(2023, 3, 12)), 10);
      expect(date.customWeekNumber(DateTime(2023, 3, 13)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 14)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 15)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 16)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 17)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 18)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 19)), 11);
      expect(date.customWeekNumber(DateTime(2023, 3, 20)), 12);

      done();
    }) /*, skip: 'Only needed if the function breaks'*/);

    test(
        'Check if the correct week number is returned '
            'from list of dates', async((DoneFn done) {
// Because GitHub CI is stupid
      File file = File('${Directory.current.path}/blocs/'
          'Dates_with_weeks_2020_to_2030_semi.csv');

      if (!file.existsSync()) {
        file = File('${Directory.current.path}/test/blocs/'
            'Dates_with_weeks_2020_to_2030_semi.csv');
      }
//Reads from a file and writes the information to a string
      final String csv = file.readAsStringSync();
// Creates a converter which can convert the csv to a list.
      const CsvToListConverter converter = CsvToListConverter(
          fieldDelimiter: ',',
          textDelimiter: '"',
          textEndDelimiter: '"',
          eol: ';');

//Converts the csv to a list called datesAndWeeks
      final List<List<dynamic>> datesAndWeeks = converter.convert<dynamic>(csv);
// Foreach element in the datesAndWeeks, parse the current element to a
// dDateTime and gets gets the weeknumber from the date.
//Checks if the actual date (gotten from the file) is equal to the number
// Gotten from customWeekNumber function.
      for (int i = 0; i < datesAndWeeks.length; i++) {
        final DateTime date = DateTime.parse(datesAndWeeks[i][0]);
        final int expectedWeek = datesAndWeeks[i][1];

        final int actualWeek = date.customWeekNumber(date);

        try {
          expect(actualWeek, expectedWeek);
        } on TestFailure {
          print('Error in calculating week number for date: '
              '${date.toString()}\nGot $actualWeek, '
              'expected $expectedWeek');
          fail('');
        }
      }

      done();
    }));
  });



}
