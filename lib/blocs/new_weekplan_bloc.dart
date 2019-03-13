import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';

class NewWeekPlanBloc extends BlocBase {

  String _title;
  PictogramModel gram = PictogramModel(id: 7, lastEdit: DateTime(1992), title: "test");

  void save(String title, String year, String weeknumber) {
    this._title = title;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}