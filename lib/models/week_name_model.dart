import 'package:weekplanner/models/model.dart';

class WeekNameModel implements Model {
  /// A Name describing the week.
  String name;

  /// The year of the week.
  int weekYear;

  /// The number of the week, 0 - 52 (53).
  int weekNumber;

  WeekNameModel({
    this.name,
    this.weekYear,
    this.weekNumber,
  });

  WeekNameModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("[WeekNameModel]: Cannot initialize from null");
    }

    name = json["name"];
    weekYear = json["weekYear"] as int;
    weekNumber = json["weekNumber"] as int;
  }

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "weekYear": weekYear,
        "weekNumber": weekNumber,
      };
}
