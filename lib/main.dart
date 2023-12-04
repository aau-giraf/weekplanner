import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';
import 'package:weekplanner/screens/profil_screen.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/edit_profil.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';


final Api _api = di.get<Api>();
final AuthBloc _authBloc = di.get<AuthBloc>();

void main() {
  // Register all dependencies for injector
  Bootstrap().register();
  WidgetsFlutterBinding.ensureInitialized();

  /***
   * The weekplanner will by default run towards the dev-enviroment
   * Use the "environments.local.json" for running against your local web-api
   * For IOS users: change the SERVER_HOST in the environment.local file to "http://localhost:5000"
   */
  environment.setFile('assets/environments.local.json').whenComplete(() {
    _runApp();
  });
}

/// Stores the last state of being logged in
bool lastState = false;

/// Stores if this is first time,
/// since this fixes a bug with logging in first time
bool firstTimeLogIn = true;

void _runApp() {
  runApp(MaterialApp(
      title: 'Weekplanner',
      theme: ThemeData(fontFamily: 'Quicksand'),
      //debugShowCheckedModeBanner: false,

      home: StreamBuilder<bool>(
          initialData: false,
          stream: di.get<AuthBloc>().loggedIn.where((bool currentState) =>
              lastState != currentState || firstTimeLogIn),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            lastState = snapshot.data;
            //To make sure we only listen to the stream once we take advantage
            // of firstTimeLogin bool value
            if(firstTimeLogIn== true){
              _api.connectivity.connectivityStream.listen((dynamic event) {
                if(event == false){
                  lostConnectionDialog(context);
                }
              });
            }
            firstTimeLogIn = false;
            if (snapshot.data) {
              // Show screen dependent on logged in role
              switch (_authBloc.loggedInUser.role) {
                case Role.Citizen:
                  return WeekplanSelectorScreen(
                      DisplayNameModel(
                          displayName: _authBloc.loggedInUser.displayName,
                          role: describeEnum(_authBloc.loggedInUser.role),
                          id: _authBloc.loggedInUser.id));
                default:
                  return ChooseCitizenScreen();
              }
            } else {
              // Not loggedIn pop context to login screen.
              Routes().goHome(context);
              return LoginScreen();
            }
          }),


    routes: {
      '/edit': (context) => EditScreen(),
      '/profil': (context) => ProfileScreen(),
      '/skift bruger': (context) => ChooseCitizenScreen(),
      '/log af': (context) => LoginScreen(),
    },

  ));
}

/// Lost connection dialog
void lostConnectionDialog(BuildContext context) {
  showDialog<Center>(
      context: context,
      builder: (BuildContext context) {
        return const GirafNotifyDialog(
            title: 'Mistet forbindelse',
            description: 'Ændringer bliver gemt når du får forbindelse igen');
      });
}
