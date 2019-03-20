import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplan_select_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeekplanSelectorScreen extends StatelessWidget {
  final WeekplanSelectBloc weekBloc;

  WeekplanSelectorScreen() : weekBloc = di.getDependency<WeekplanSelectBloc>(){
    this.weekBloc.load(GirafUserModel(id: "379d057b-85b1-41b6-a1bd-6448c132745b"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: "Vælg ugeplan",
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<List<WeekModel>>(
                  stream: weekBloc.weekModels,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<WeekModel>> snapshot) {
                    if (snapshot.data == null) {
                      return CircularProgressIndicator();
                    }
                    return GridView.count(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 4
                          : 3,
                      crossAxisSpacing:
                          MediaQuery.of(context).size.width / 100 * 1.5,
                      mainAxisSpacing:
                          MediaQuery.of(context).size.width / 100 * 1.5,
                      children: snapshot.data.map((WeekModel weekplan) {
                        return _buildWeekPlanSelector(context, weekplan);
                      }).toList(),
                    );
                  })),
        ],
      ),
    );
  }

  Widget _buildWeekPlanAdder(context, weekplan, bloc) {
    return GestureDetector(
      onTap: () => print("going to ${weekplan.name}"),
      // TODO route to weekplan.name
      child: StreamBuilder<Image>(
          stream: bloc.image,
          builder: (context, snapshot) {
            return Container(child: snapshot.data);
          }),
    );
  }

  Widget _buildWeekPlan(context, weekplan, constraint) {
    return GestureDetector(
        onTap: () => print("adding"), // TODO route to adding a new weekplan
        child: Icon(
          Icons.add,
          size: constraint.maxWidth,
        ));
  }

  Widget _buildWeekPlanSelector(context, weekplan) {
    PictogramImageBloc bloc = PictogramImageBloc();
    print(weekplan.name);

    if (weekplan.thumbnail != null) bloc.loadID(weekplan.thumbnail.id);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Card(
                  child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: LayoutBuilder(builder: (context, constraint) {
                  if (weekplan.thumbnail != null) {
                    return _buildWeekPlanAdder(context, weekplan, bloc);
                  } else {
                    return _buildWeekPlan(context, weekplan, constraint);
                  }
                }),
              ),
              Expanded(child: LayoutBuilder(builder: (context, constraints) {
                return AutoSizeText(
                  weekplan.name,
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                );
              }))
            ],
          )))
        ],
      ),
    );
  }
}
