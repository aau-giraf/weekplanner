import 'package:meta/meta.dart';
import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'activityState_enum.dart';  

class ActivityModel implements Model{
	int id;
	PictogramModel pictogram;
	int order;
	ActivityState state;


	ActivityModel({ 
    @required int id,
    @required PictogramModel pictogram,
    @required int order,
    @required ActivityState state,
    });

  ActivityModel.fromJson(Map<String, dynamic> json) {    
        if (json == null) {
      throw FormatException("[ActivityModel]: Cannot initialize from null");
    }

      id  = json['id'];
      pictogram = json['pictogram'].map((value) => PictogramModel.fromJson(value));
      order = json['order'];
      state = json['state'].map((value) => ActivityModel.fromJson(value));   
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pictogram':pictogram.toJson() ,
      'order': order,
      'state': state,
    };
  }
}