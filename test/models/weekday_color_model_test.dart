import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/weekday_color_model.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';

void main(){
  Map<String, dynamic> response = {
    "hexColor": "#067700",
    "day": 1
  };


  test("Can instantiate from JSON", (){
    WeekdayColorModel weekdaycolor = WeekdayColorModel.fromJson(response);

    expect(weekdaycolor.hexColor, response['hexColor']);
    expect(weekdaycolor.day, Weekday.values[(response['day'] as int) - 1]);
  });

  test("Throws exception if JSON input is null", (){
    expect(() => WeekdayColorModel.fromJson(null), throwsFormatException);
  });

  test("Can serialize to json", (){
    WeekdayColorModel weekdaycolor = WeekdayColorModel.fromJson(response);

    expect(weekdaycolor.toJson(), response);
  });
}