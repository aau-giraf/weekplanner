import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/weekday_model.dart';

abstract class WeekBaseModel {
  PictogramModel thumbnail;

  String name;

  List<WeekdayModel> days;


  WeekBaseModel({
    this.thumbnail,
    this.name,
    this.days
  });

  WeekBaseModel.fromJson(Map<String, dynamic> json){
    if (json == null) {
      throw FormatException("[WeekBaseModel]: Cannot initialize from null");
    }

    this.name = json["name"];

    // WeekModel sometimes dont have a thumbnail
    if(json['thumbnail'] != null){
      this.thumbnail = PictogramModel.fromJson(json['thumbnail']);
    }

    // WeekModel sometimes dont have days
    if(json['days'] != null){
      this.days = (json["days"] as List).map(
              (element) => WeekdayModel.fromJson(element)
      ).toList();
    }

  }

}