import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_base_model.dart';
import 'package:weekplanner/models/weekday_model.dart';

class WeekTemplateModel extends WeekBaseModel implements Model{
  int departmentKey;

  int id;

  WeekTemplateModel({
    PictogramModel thumbnail,
    String name,
    List<WeekdayModel> days,
    this.departmentKey,
    this.id
  }) : super(thumbnail: thumbnail, name: name, days: days);

  WeekTemplateModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json == null) {
      throw FormatException("[WeekTemplateModel]: Cannot initialize from null");
    }

    this.departmentKey = json['departmentKey'];
    this.id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "departmentKey": this.departmentKey,
      "id": this.id,
      "thumbnail": this.thumbnail.toJson(),
      "name": this.name,
      "days": this.days.map((element) => element.toJson()).toList()
    };
  }

}