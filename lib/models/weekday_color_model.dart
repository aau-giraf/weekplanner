import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/weekday_enum.dart';

class WeekdayColorModel implements Model{
  String hexColor;

  Weekday day;

  WeekdayColorModel({this.hexColor, this.day});

  WeekdayColorModel.fromJson(Map<String, dynamic> json){
    if (json == null) {
      throw FormatException("[WeekdayColorModel]: Cannot initialize from null");
    }

    this.hexColor = json['hexColor'];
    this.day = Weekday.values[(json['day'] as int) - 1];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "hexColor": this.hexColor,
      "day": this.day.index + 1
    };
  }

}