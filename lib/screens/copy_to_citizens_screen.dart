import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/screens/copy_resolve_screen.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';
import 'package:weekplanner/widgets/giraf_3button_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import '../routes.dart';
import '../style/custom_color.dart' as theme;

/// The screen to choose a citizen
class CopyToCitizensScreen extends StatelessWidget {
  /// <param name="model">WeekModel that should be copied
  CopyToCitizensScreen(this._copiedWeekModel, this._currentUser);

  final CopyWeekplanBloc _bloc = di.getDependency<CopyWeekplanBloc>();
  final WeekModel _copiedWeekModel;
  final DisplayNameModel _currentUser;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
      .of(context)
      .size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_screen_background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        // Creates a new Dialog
        child: Dialog(
          child: Scaffold(
            appBar: GirafAppBar(
              title: 'Vælg borger',
              appBarIcons: const <AppBarIcon, VoidCallback>{},
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Expanded(child: _buildWeekplanGridview(context))),
                  Row(
                    children: <Widget>[
                      const Spacer(flex: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: GirafButton(
                            key: const Key('CancelButton'),
                            onPressed: () {
                              Routes.pop(context);
                            },
                            icon: const ImageIcon(
                              AssetImage('assets/icons/cancel.png')),
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: GirafButton(
                            key: const Key('AcceptButton'),
                            onPressed: () async {
                              _bloc
                                .numberOfConflictingUsers(
                                _copiedWeekModel, _currentUser, false)
                                .then((int conflicts) {
                                if (conflicts > 0) {
                                  _showConflictDialog(context, conflicts);
                                } else {
                                  _bloc.copyWeekplan(_copiedWeekModel,
                                    _currentUser, false);
                                  Routes.goHome(context);
                                  Routes.push(context,
                                    WeekplanSelectorScreen(_currentUser));
                                  _showCopySuccessDialog(context);
                                }
                              });
                            },
                            icon: const ImageIcon(
                              AssetImage('assets/icons/accept.png')))),
                      ),
                      const Spacer(flex: 1),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekplanGridview(BuildContext context) {
    final bool portrait =
      MediaQuery
        .of(context)
        .orientation == Orientation.portrait;
    return StreamBuilder<List<DisplayNameModel>>(
      initialData: const <DisplayNameModel>[],
      stream: _bloc.citizen,
      builder: (BuildContext context,
        AsyncSnapshot<List<DisplayNameModel>> usersSnapshot) {
        if (usersSnapshot.data == null) {
          return Container();
        } else {
          return StreamBuilder<List<DisplayNameModel>>(
            stream: _bloc.markedUserModels,
            builder: (BuildContext context,
              AsyncSnapshot<List<DisplayNameModel>> markedUsersSnapshot) {
              return GridView.count(
                crossAxisCount: portrait ? 2 : 4,
                children: usersSnapshot.data.map((DisplayNameModel user) {
                  return _buildUserSelector(context, user,
                    markedUsersSnapshot.data.contains(user));
                }).toList());
            });
        }
      });
  }

  Widget _buildUserSelector(BuildContext context, DisplayNameModel user,
    bool isMarked) {
    final CitizenAvatar avatar = CitizenAvatar(
      displaynameModel: user,
      onPressed: () => _bloc.toggleMarkedUserModel(user));

    if (isMarked) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.GirafColors.black, width: 10),
        ),
        child: avatar);
    } else {
      return avatar;
    }
  }

  ///Builds dialog box to fix conflict
  Future<Center> _showConflictDialog(BuildContext context, int conflicts) {
    return showDialog<Center>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Giraf3ButtonDialog(
          title: 'Kopiér konflikt',
          description: 'Der er $conflicts konflikter!',
          option1Text: 'Ændr',
          option1OnPressed: () {
            Routes.pop(context);
            Routes.push(
              context,
              CopyResolveScreen(
                currentUser: _currentUser,
                weekModel: _copiedWeekModel,
                copyBloc: _bloc,
                forThisCitizen: false,
              ));
          },
          option1Icon: const ImageIcon(AssetImage('assets/icons/copy.png')),
          option2Text: 'Overskriv',
          option2OnPressed: () {
            _bloc.copyWeekplan(_copiedWeekModel, _currentUser, false)
              .then((_) {
              Routes.goHome(context);
              Routes.push(context,
                WeekplanSelectorScreen(_currentUser));
            });
          },
          option2Icon: const ImageIcon(AssetImage('assets/icons/copy.png')),
        );
      });
  }

  Future<Center> _showCopySuccessDialog(BuildContext context) {
    return showDialog<Center>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const GirafNotifyDialog(
          title: 'Ugeplan kopieret',
          description: 'Ugeplanen blev kopieret til de valgte borgere',
          key: Key('OkaySuccessButton'));
      });
  }
}
