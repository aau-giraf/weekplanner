import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_base_model.dart';
import 'package:weekplanner/models/weekday_model.dart';

class WeekModel extends WeekBaseModel implements Model{
  int weekYear;

  int weekNumber;

  WeekModel({
    PictogramModel thumbnail,
    String name,
    List<WeekdayModel> days,
    this.weekYear,
    this.weekNumber,
  }) : super(thumbnail: thumbnail, name: name, days: days);

  WeekModel.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    this.weekYear = json['weekYear'];
    this.weekNumber = json['weekNumber'];
  }


  @override
  Map<String, dynamic> toJson() {

    Map<String, dynamic> response = {
      "weekYear": this.weekYear,
      "weekNumber": this.weekNumber,
      "name": this.name,
    };

    // We have to take into account that this object
    // is used in two different ways, one with thumbnail
    // and another without thumbnail.
    if(this.thumbnail != null){
      response['thumbnail'] = this.thumbnail.toJson();
    }

    // We have to take into account that this object
    // is used in two different ways, one with days
    // and another without days.
    if(this.days != null){
      response['days'] = this.days.map((element) => element.toJson()).toList();
    }

    return response;
  }

}