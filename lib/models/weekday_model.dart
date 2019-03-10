import 'package:meta/meta.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/weekday_enum.dart';

class WeekdayModel implements Model {
  Weekday day;
  List<ActivityModel> activities;

  WeekdayModel({@required this.day, @required this.activities});

  WeekdayModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw new FormatException("[WeekdayModel]: Cannot instanciate from null");
    }

    day = Weekday.values[json["day"] - 1];
    activities = (json["activities"] as List)
        .map((val) => ActivityModel.fromJson(val))
        .toList();
  }

  @override
  Map<String, dynamic> toJson() => {
        "day": day.index + 1,
        "activities": activities.map((val) => val.toJson()).toList(),
      };
}
