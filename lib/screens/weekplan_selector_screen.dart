import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplan_select_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeekplanSelectorScreen extends StatelessWidget {
  WeekplanSelectBloc weekbloc = WeekplanSelectBloc(Globals.api);

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
                  stream: weekbloc.weekmodels,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<WeekModel>> snapshot) {
                    if (snapshot.data == null) {
                      return CircularProgressIndicator();
                    }
                    return GridView.count(
                      crossAxisCount: 3,
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
    return GestureDetector(onTap: () => print("going to ${weekplan.name}"), // TODO route to weekplan.name
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
        child: Icon(Icons.add, size: constraint.maxWidth,));
  }

  Widget _buildWeekPlanSelector(context, weekplan) {
    PictogramImageBloc bloc = PictogramImageBloc(Globals.api);
    print(weekplan.name);

    if(weekplan.name != "Tilføj Ugeplan")
      bloc.loadID(weekplan.thumbnail.id);

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
                      if (weekplan.name != "Tilføj Ugeplan") {
                        return _buildWeekPlanAdder(context, weekplan, bloc);
                      }
                      else {
                        return _buildWeekPlan(context, weekplan, constraint);
                      }
                    }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        weekplan.name,
                        style: TextStyle(fontSize: 30.0),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
