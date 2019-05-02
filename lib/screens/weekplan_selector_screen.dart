import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/new_weekplan_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

/// Screen to select a weekplan for a given user
class WeekplanSelectorScreen extends StatelessWidget {
  /// Constructor for weekplan selector screen.
  /// Requires a user to load weekplans
  WeekplanSelectorScreen(this._user)
      : _weekBloc = di.getDependency<WeekplansBloc>() {
    _weekBloc.load(_user, true);
  }

  final WeekplansBloc _weekBloc;
  final UsernameModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Vælg ugeplan',
        appBarIcons: <AppBarIcon, VoidCallback>{
          AppBarIcon.edit: () => _weekBloc.toggleEditMode(),
          AppBarIcon.settings: () {},
          AppBarIcon.logout: () {}
        },
      ),
      bottomNavigationBar: StreamBuilder<bool>(
        stream: _weekBloc.editMode,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data) {
            return buildBottomAppBar(context);
          } else {
            return Container(width: 0.0, height: 0.0);
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<List<WeekModel>>(
                  initialData: const <WeekModel>[],
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
      onTap: () => Routes.push(context, WeekplanScreen(weekplan, _user)),
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
        onTap: () => Routes.push<WeekModel>(context, NewWeekplanScreen(_user))
            .then((WeekModel newWeek) => {_weekBloc.load(_user, true)}),
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
                    maxLines: 1,
                    minFontSize: 14,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  );
                }))
              ],
            )),
          ))
        ],
      ),
    );
  }

  /// Builds the BottomAppBar when in edit mode
  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: <double>[
                          1 / 3,
                          2 / 3
                        ],
                        colors: <Color>[
                          Color.fromRGBO(254, 215, 108, 1),
                          Color.fromRGBO(253, 187, 85, 1),
                        ])),
                child: IconButton(
                  key: const Key('DeleteActivtiesButton'),
                  iconSize: 50,
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    // Shows dialog to confirm/cancel deletion
                    buildShowDialog(context);
                  },
                ),
              ),
            ),
          ],
        ));
  }

  /// Builds dialog box to confirm/cancel deletion
  Future<Center> buildShowDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Bekræft',
              description: 'Vil du slette ' +
                  _weekBloc.getNumberOfMarkedWeekModels().toString() +
                  ' ugeplan(er)',
              confirmButtonText: 'Bekræft',
              confirmButtonIcon:
              const ImageIcon(AssetImage('assets/icons/accept.png')),
              confirmOnPressed: () {
                _weekBloc.deleteMarkedWeekModels();
                _weekBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
        });
  }
}
