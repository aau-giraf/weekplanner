import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/'
    'number_of_days_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'color_theme_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'privacy_information_screen.dart';
import 'package:weekplanner/screens/settings_screens/settings_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'time_representation_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_arrow_button.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_item.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_theme_display_box.dart';
import '../../di.dart';
import '../../widgets/settings_widgets/settings_section_arrow_button.dart';
import 'completed_activity_icon_selection_screen.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final ChooseCitizenBloc _cBloc = di.getDependency<ChooseCitizenBloc>();
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  GirafUserModel _user;
  String appBarTitleText = "Placeholder";

  /*Future<GirafUserModel> FetchUser() async {
    return await _cBloc.GetCurrentUser();
    setState(() {
      appBarTitleText = "New placeholder";
    });
    //return user;
  }*/

  void InitState() {
    super.initState();
    //_user = FetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: appBarTitleText + ' Indstillinger'),
        body: _buildAllSettings(context));
  }

  Widget _buildAllSettings(BuildContext context) {
    return ListView(
      children: <Widget>[_buildUserSettings()],
    );
  }

  Widget _buildUserSettings() {
    return Scaffold(
        appBar: GirafAppBar(
          title: appBarTitleText + ' indstillinger',
        ),
        body: StreamBuilder<GirafUserModel>(
            stream: _cBloc.guardian,
            builder:
                (BuildContext context, AsyncSnapshot<GirafUserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                print("Active state: ${snapshot.connectionState}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Error occured"));
                } else if (snapshot.hasData) {
                  print("Snapshot has Girafuser: " + snapshot.data.displayName);
                  _user = snapshot.data;

                  setState(() {
                    appBarTitleText = _user.displayName;
                    _settingsBloc.loadSettingsGirafUser(_user);
                  });
                } else {
                  print("Empty snapshot");
                  return Center(child: Text("Empty snapshot / No data"));
                }
              } else {
                print(snapshot.connectionState);
                return Center(
                  child: Text('State: ${snapshot.connectionState}'),
                );
              }
            }));

    /*return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel settingsModel = settingsSnapshot.data;
            return UserSettingsScreen();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });*/

    /*
        return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
          SettingsArrowButton(_user.displayName + ' indstillinger', () {}),
        ]);
              */
  }

  Widget _buildChangePasswordAndUsername(BuildContext context) {
    return SettingsSection(
        "_user.displayName" + ' - skift personlig information',
        <SettingsSectionItem>[
          SettingsArrowButton('Skift brugernavn', () {}),
          SettingsArrowButton('Skift kodeord', () {}),
        ]);
  }
}
