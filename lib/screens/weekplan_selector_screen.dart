import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/new_weekplan_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
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
        title: _user.name,
        appBarIcons: <AppBarIcon, VoidCallback>{
          AppBarIcon.edit: () => _weekBloc.toggleEditMode(),
          AppBarIcon.logout: () {}
        },
      ),
      bottomNavigationBar: StreamBuilder<bool>(
        stream: _weekBloc.editMode,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data) {
            return _buildBottomAppBar(context);
          } else {
            return Container(width: 0.0, height: 0.0);
          }
        },
      ),
      body: _buildWeekplanGridview(context),
    );
  }

  Widget _buildWeekplanGridview(BuildContext context) {
    return StreamBuilder<List<WeekModel>>(
        initialData: const <WeekModel>[],
        stream: _weekBloc.weekModels,
        builder: (BuildContext context,
            AsyncSnapshot<List<WeekModel>> weekplansSnapshot) {
          if (weekplansSnapshot.data == null) {
            return Container();
          } else {
            return StreamBuilder<List<WeekModel>>(
                stream: _weekBloc.markedWeekModels,
                builder: (BuildContext context,
                    AsyncSnapshot<List<WeekModel>> markedWeeksSnapshot) {
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
                      children:
                          weekplansSnapshot.data.map((WeekModel weekplan) {
                        return _buildWeekPlanSelector(context, weekplan,
                            markedWeeksSnapshot.data.contains(weekplan));
                      }).toList());
                });
          }
        });
  }

  Widget _buildWeekPlanSelector(
      BuildContext context, WeekModel weekplan, bool isMarked) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();

    if (weekplan.thumbnail != null) {
      bloc.loadPictogramById(weekplan.thumbnail.id);
    }

    if (isMarked) {
      return Container(
          key: const Key('isSelectedKey'),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 15)),
          child: _buildWeekplanCard(context, weekplan, bloc));
    } else {
      return _buildWeekplanCard(context, weekplan, bloc);
    }
  }

  Widget _buildWeekplanCard(
      BuildContext context, WeekModel weekplan, PictogramImageBloc bloc) {
    return StreamBuilder<bool>(
        stream: _weekBloc.editMode,
        builder:
            (BuildContext context, AsyncSnapshot<bool> inEditModeSnapshot) {
          return GestureDetector(
            key: Key(weekplan.name),
            onTap: () =>
                handleOnTap(context, weekplan, inEditModeSnapshot.data),
            child: Card(
                child: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraint) {
                    if (weekplan.thumbnail != null) {
                      return _getPictogram(weekplan, bloc);
                    } else {
                      return Icon(
                        Icons.add,
                        size: constraint.maxHeight,
                      );
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
          );
        });
  }

  /// Handles on tap on a weekplan card
  void handleOnTap(BuildContext context, WeekModel weekplan, bool inEditMode) {
    if (weekplan.thumbnail != null) {
      handleOnTapWeekPlan(inEditMode, weekplan, context);
    } else {
      handleOnTapWeekPlanAdd(inEditMode, context);
    }
  }

  /// Handles on tap on a add new weekplan card
  void handleOnTapWeekPlanAdd(bool inEditMode, BuildContext context) {
    if (!inEditMode) {
      Routes.push<WeekModel>(context, NewWeekplanScreen(_user))
          .then((WeekModel newWeek) => _weekBloc.load(_user, true));
    }
  }

  /// Handles on tap on a weekplan card
  void handleOnTapWeekPlan(
      bool inEditMode, WeekModel weekplan, BuildContext context) {
    if (inEditMode) {
      _weekBloc.toggleMarkedWeekModel(weekplan);
    } else {
      Routes.push(context, WeekplanScreen(weekplan, _user));
    }
  }

  Widget _getPictogram(WeekModel weekplan, PictogramImageBloc bloc) {
    return StreamBuilder<Image>(
      stream: bloc.image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.data == null) {
          return FittedBox(child: const CircularProgressIndicator());
        }
        return Container(
            child: snapshot.data, key: const Key('PictogramImage'));
      },
    );
  }

  /// Builds the BottomAppBar when in edit mode
  BottomAppBar _buildBottomAppBar(BuildContext context) {
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BottomAppBarButton(
                  buttonText: 'Redigér',
                  buttonKey: 'EditActivtiesButton',
                  assetPath: 'assets/icons/edit.png',
                  dialogFunction: _buildDeletionDialog),
                BottomAppBarButton(
                    buttonText: 'Slet',
                    buttonKey: 'DeleteActivtiesButton',
                    assetPath: 'assets/icons/delete.png',
                    dialogFunction: _buildDeletionDialog)
              ],

              )
          ),
        ),
      ],
    ));
  }

  /// Builds dialog box to confirm/cancel deletion
  Future<Center> _buildDeletionDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Slet ugeplaner',
              description: 'Vil du slette ' +
                  _weekBloc.getNumberOfMarkedWeekModels().toString() +
                  ' ugeplan(er)',
              confirmButtonText: 'Slet',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/delete.png')),
              confirmOnPressed: () {
                _weekBloc.deleteMarkedWeekModels();
                _weekBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
        });
  }

  /// Builds dialog box to confirm/cancel
  Future<Center> _buildEditDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          if (_weekBloc.getNumberOfMarkedWeekModels() != 1) {

          }
        });
  }
}
