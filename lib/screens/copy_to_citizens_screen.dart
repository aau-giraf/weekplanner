import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';
import 'package:weekplanner/widgets/giraf_3button_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import '../routes.dart';
import '../style/custom_color.dart' as theme;

/// The screen to choose a citizen
class CopyToCitizensScreen extends StatelessWidget {
  /// <param name="model">WeekModel that should be copied
  CopyToCitizensScreen(this._copiedWeekModel);

  final CopyWeekplanBloc _bloc = di.getDependency<CopyWeekplanBloc>();
  final WeekModel _copiedWeekModel;

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
                      Spacer(flex: 1),
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
                      Spacer(flex: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: GirafButton(
                                key: const Key('AcceptButton'),
                                onPressed: () {
                                   int conflicts = _bloc
                                      .numberOfConflictingUsers(
                                      _copiedWeekModel);
                                  if(conflicts > 0) {
                                    _showConflictDialog(context, conflicts);
                                  }
                                  _bloc.copyToMarkedCitizens(
                                      context, _copiedWeekModel);
                                },
                                icon: const ImageIcon(
                                    AssetImage('assets/icons/accept.png')))),
                      ),
                      Spacer(flex: 1),
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
    return StreamBuilder<List<UsernameModel>>(
        initialData: const <UsernameModel>[],
        stream: _bloc.citizen,
        builder: (BuildContext context,
            AsyncSnapshot<List<UsernameModel>> usersSnapshot) {
          if (usersSnapshot.data == null) {
            return Container();
          } else {
            return StreamBuilder<List<UsernameModel>>(
                stream: _bloc.markedUserModels,
                builder: (BuildContext context,
                    AsyncSnapshot<List<UsernameModel>> markedUsersSnapshot) {
                  return GridView.count(
                      crossAxisCount: portrait ? 2 : 4,
                      children: usersSnapshot.data.map((UsernameModel user) {
                        return _buildUserSelector(context, user,
                            markedUsersSnapshot.data.contains(user));
                      }).toList());
                });
          }
        });
  }

  Widget _buildUserSelector(BuildContext context, UsernameModel user,
      bool isMarked) {
    final CitizenAvatar avatar = CitizenAvatar(
        usernameModel: user,
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
            description: 'Der er ${conflicts} konflikter!',
            option1Text: 'ændr',
            option1OnPressed: () {
            },
            option1Icon: const ImageIcon(AssetImage('assets/icons/copy.png')),
            option2Text: 'Overskriv',
            option2OnPressed: () {
              _bloc.copyWeekplan(_copiedWeekModel);
              Routes.pop(context);
            },
            option2Icon: const ImageIcon(AssetImage('assets/icons/copy.png')),
          );
        });
  }
}
