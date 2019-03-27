import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeekplanSelectorScreen extends StatelessWidget {
  final WeekplansBloc weekBloc;

  WeekplanSelectorScreen(GirafUserModel user)
      : weekBloc = di.getDependency<WeekplansBloc>() {
    this.weekBloc.load(user, true);
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
      onTap: () {}, //  onTap for going to a existing weekplan
      child: StreamBuilder<Image>(
          stream: bloc.image,
          builder: (context, snapshot) {
            return Container(child: snapshot.data);
          }),
    );
  }

  Widget _buildWeekPlan(context, weekplan, constraint) {
    return GestureDetector(
        onTap: () => () {}, // onTap for adding a new weekplan
        child: Icon(
          Icons.add,
          size: constraint.maxHeight,
        ));
  }

  Widget _buildWeekPlanSelector(context, weekplan) {
    PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();

    if (weekplan.thumbnail != null)
      bloc.loadPictogramById(weekplan.thumbnail.id);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: InkWell(
            onTap: () {},
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
            )),
          ))
        ],
      ),
    );
  }
}
