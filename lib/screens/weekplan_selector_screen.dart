import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/copy_resolve_screen.dart';
import 'package:weekplanner/screens/copy_to_citizens_screen.dart';
import 'package:weekplanner/screens/edit_weekplan_screen.dart';
import 'package:weekplanner/screens/new_weekplan_screen.dart';
import 'package:weekplanner/screens/settings_screens/settings_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_3button_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

import '../style/custom_color.dart' as theme;

/// Screen to select a weekplan for a given user
class WeekplanSelectorScreen extends StatelessWidget {
  /// Constructor for weekplan selector screen.
  /// Requires a user to load weekplans
  WeekplanSelectorScreen(this._user)
      : _weekBloc = di.getDependency<WeekplansBloc>() {
    _weekBloc.load(_user, true);
  }

  final WeekplansBloc _weekBloc;
  final DisplayNameModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: _user.displayName,
          appBarIcons: <AppBarIcon, VoidCallback>{
            AppBarIcon.edit: () => _weekBloc.toggleEditMode(),
            AppBarIcon.logout: () {},
            AppBarIcon.settings: () =>
                Routes.push(context, SettingsScreen(_user))
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
        body: _buildWeekplanColumnview(context));
  }

  Widget _buildWeekplanColumnview(BuildContext context) {
    final Stream<List<WeekModel>> weekModels = _weekBloc.weekModels;
    final Stream<List<WeekModel>> oldWeekModels = _weekBloc.oldWeekModels;

    return Container(
        child: Column(children: <Widget>[
      Expanded(flex: 75, child: _buildWeekplanGridview
        (context, weekModels, true)),
      Container(
        color: Colors.grey,
        child:
          const AutoSizeText(
            'Overståede uger',
            style: TextStyle(fontSize: 18),
            maxLines: 1,
            minFontSize: 14,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(10.0, 3, 0, 3),
      ),
      Expanded(flex: 25, child:
              _buildWeekplanGridview(context, oldWeekModels, false)),

    ]));
  }

  Widget _buildWeekplanGridview(
      BuildContext context, Stream<List<WeekModel>> weekModels,
      bool isUpcomingWeekplan) {
    List<WeekModel> initial = <WeekModel>[WeekModel(name: 'Tilføj ugeplan')];
    if(!isUpcomingWeekplan) {
      initial = <WeekModel>[];
    }
    return StreamBuilder<List<WeekModel>>(
        initialData: initial,
        stream: weekModels,
        builder: (BuildContext context,
            AsyncSnapshot<List<WeekModel>> weekplansSnapshot) {
          return StreamBuilder<List<WeekModel>>(
              stream: _weekBloc.markedWeekModels,
              builder: (BuildContext context,
                  AsyncSnapshot<List<WeekModel>> markedWeeksSnapshot) {
                return GridView.count(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    crossAxisCount:
                            MediaQuery.of(context).orientation ==
                                Orientation.landscape
                                ? 4
                                : 3,

                    crossAxisSpacing:
                        MediaQuery.of(context).size.width / 100 * 1.5,
                    mainAxisSpacing:
                        MediaQuery.of(context).size.width / 100 * 1.5,
                    children: weekplansSnapshot.data.map((WeekModel weekplan) {
                      return _buildWeekPlanSelector(
                        context,
                        weekplan,
                        markedWeeksSnapshot.hasData &&
                            markedWeeksSnapshot.data.contains(weekplan),
                        isUpcomingWeekplan
                      );
                    }).toList());
              });
        });
  }

  Widget _buildWeekPlanSelector(
      BuildContext context, WeekModel weekplan, bool isMarked, bool current) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();

    if (weekplan.thumbnail != null) {
      bloc.loadPictogramById(weekplan.thumbnail.id);
    }

    if (isMarked) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.GirafColors.black, width: 15),
          ),
          child: _buildWeekplanCard(context, weekplan, bloc, current,
              ));
    } else {
      return _buildWeekplanCard(context, weekplan, bloc, current,
          );
    }
  }

  Widget _buildWeekplanCard(BuildContext context, WeekModel weekplan,
      PictogramImageBloc bloc, bool current) {
    return StreamBuilder<bool>(
        stream: _weekBloc.editMode,
        builder:
            (BuildContext context, AsyncSnapshot<bool> inEditModeSnapshot) {
          return GestureDetector(
              key: Key(weekplan.name),
              onTap: () =>
                  handleOnTap(context, weekplan, inEditModeSnapshot.data),
              child: ColorFiltered(
                colorFilter:
                    ColorFilter.mode(
                        Colors.grey,
                        current ? BlendMode.dst : BlendMode.modulate),
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
                    })),
                    Container(
                      child: weekplan.weekNumber == null
                          ? null
                          : Expanded(child: LayoutBuilder(builder:
                              (BuildContext context,
                                  BoxConstraints constraints) {
                              return AutoSizeText(
                                'Uge: ${weekplan.weekNumber}      '
                                'År: ${weekplan.weekYear}',
                                key: const Key('weekYear'),
                                style: const TextStyle(fontSize: 18),
                                maxLines: 1,
                                minFontSize: 14,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              );
                            })),
                    )
                  ],
                )),
              ));
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
      Routes.push<WeekModel>(
        context,
        NewWeekplanScreen(
          user: _user,
          existingWeekPlans: _weekBloc.weekNameModels,
        ),
      ).then((WeekModel newWeekPlan) => _weekBloc.load(_user, true));
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
          return const FittedBox(child: CircularProgressIndicator());
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
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: <double>[
                    1 / 3,
                    2 / 3
                  ],
                      colors: <Color>[
                    theme.GirafColors.appBarYellow,
                    theme.GirafColors.appBarOrange,
                  ])),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GirafButton(
                      key: const Key('EditButtonKey'),
                      text: 'Redigér',
                      icon:
                          const ImageIcon(AssetImage('assets/icons/edit.png')),
                      onPressed: () => _pushEditWeekPlan(context)),
                  BottomAppBarButton(
                      buttonText: 'Kopiér',
                      buttonKey: 'CopyWeekplanButton',
                      assetPath: 'assets/icons/copy.png',
                      isEnabled: false,
                      isEnabledStream: _weekBloc.onlyOneModelMarkedStream(),
                      dialogFunction: _buildCopyDialog),
                  BottomAppBarButton(
                      buttonText: 'Slet',
                      buttonKey: 'DeleteActivtiesButton',
                      assetPath: 'assets/icons/delete.png',
                      dialogFunction: _buildDeletionDialog),
                ],
              )),
        ),
      ],
    ));
  }

  void _pushEditWeekPlan(BuildContext context) {
    final int markedCount = _weekBloc.getNumberOfMarkedWeekModels();
    if( markedCount != 1) {
      final String description = markedCount > 1 ?
        'Der kan kun redigeres en uge ad gangen' :
        'Markér en uge for at redigere den';
      showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: 'Fejl',
              description: description);
      });
      return;
    }
    Routes.push<WeekModel>(
      context,
      EditWeekPlanScreen(
        user: _user,
        weekModel: _weekBloc.getMarkedWeekModels()[0],
        selectorBloc: _weekBloc,
      ),
    ).then((WeekModel newWeek) => _weekBloc.load(_user, true));
    _weekBloc.toggleEditMode();
    _weekBloc.clearMarkedWeekModels();
  }

  ///Builds dialog box to select where to copy weekplan or cancel
  Future<Center> _buildCopyDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Giraf3ButtonDialog(
            title: 'Kopiér ugeplaner',
            description: 'Hvor vil du kopiére den valgte ugeplan hen? ',
            option1Text: 'Anden borger',
            option1OnPressed: () {
              _weekBloc.getMarkedWeekModel().then((WeekModel weekmodel) {

                Routes.push(
                  context,
                  CopyToCitizensScreen(
                    weekmodel, _user));

              });
            },
            option1Icon: const ImageIcon(AssetImage('assets/icons/copy.png')),
            option2Text: 'Denne borger',
            option2OnPressed: () {
              _weekBloc.getMarkedWeekModel().then((WeekModel weekmodel) {
                Routes.push(
                  context,
                  CopyResolveScreen(
                    currentUser: _user,
                    weekModel: weekmodel,
                    forThisCitizen: true,
                  )
                );
              });
            },
            option2Icon: const ImageIcon(AssetImage('assets/icons/copy.png')),
          );
        });
  }

  /// Builds dialog box to confirm/cancel deletion
  Future<Center> _buildDeletionDialog(BuildContext context) {
    if(_weekBloc.getNumberOfMarkedWeekModels() == 0) {
      return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const GirafNotifyDialog(
              title: 'Fejl',
              description: 'Der skal markeres mindst én uge for at slette');
      });
    }

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
}
