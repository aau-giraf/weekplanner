import 'package:weekplanner/models/model.dart';

class WeekTemplateNameModel implements Model{
  String name;

  int id;


  WeekTemplateNameModel({this.name, this.id});

  WeekTemplateNameModel.fromJson(Map<String, dynamic> json){
    if (json == null) {
      throw FormatException("[WeekTemplateNameModel]: Cannot initialize from null");
    }

    this.name = json['name'];
    this.id = json['templateId'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "templateId": this.id
    };
  }

}