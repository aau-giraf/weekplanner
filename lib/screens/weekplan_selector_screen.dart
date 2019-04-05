import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// Screen to select a weekplan for a given user
class WeekplanSelectorScreen extends StatelessWidget {
  /// Constructor for weekplan selector screen.
  /// Requies a UsernameModel user to load weekplans
  WeekplanSelectorScreen(UsernameModel user)
      : _weekBloc = di.getDependency<WeekplansBloc>() {
    _weekBloc.load(user, true);
  }

  final WeekplansBloc _weekBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Vælg ugeplan',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<List<WeekModel>>(
                initialData:const <WeekModel> [],
                  stream: _weekBloc.weekModels,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<WeekModel>> snapshot) {
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    return GridView.count(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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

  Widget _buildWeekPlanAdder(
      BuildContext context, WeekModel weekplan, PictogramImageBloc bloc) {
    return GestureDetector(
      onTap: () {}, //  onTap for going to an existing weekplan
      child: StreamBuilder<Image>(
          stream: bloc.image,
          builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
            return Container(child: snapshot.data);
          }),
    );
  }

  Widget _buildWeekPlan(
      BuildContext context, WeekModel weekplan, BoxConstraints constraint) {
    return GestureDetector(
        onTap: () => () {}, // onTap for adding a new weekplan
        child: Icon(
          Icons.add,
          size: constraint.maxHeight,
        ));
  }

  Widget _buildWeekPlanSelector(BuildContext context, WeekModel weekplan) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();

    if (weekplan.thumbnail != null) {
      bloc.loadPictogramById(weekplan.thumbnail.id);
    }

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
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraint) {
                    if (weekplan.thumbnail != null) {
                      return _buildWeekPlanAdder(context, weekplan, bloc);
                    } else {
                      return _buildWeekPlan(context, weekplan, constraint);
                    }
                  }),
                ),
                Expanded(child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return AutoSizeText(
                    weekplan.name,
                    style: const TextStyle(fontSize: 18),
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
