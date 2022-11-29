import 'package:api_client/api/api.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/widgets/pictogram_password_widgets/pictogram_password_widget.dart';
import '../di.dart';
import '../style/custom_color.dart' as theme;
import '../style/custom_color.dart';
import '../widgets/giraf_button_widget.dart';

/// The screen that contains functionality for logging in with pictograms.
class PictogramLoginScreen extends StatefulWidget {
  @override
  _PictogramLoginState createState() => _PictogramLoginState();
}

class _PictogramLoginState extends State<PictogramLoginScreen> {
  final ButtonStyle girafButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: theme.GirafColors.loginButtonColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
  void onPasswordUpdate(String password){
    return;
  }

  @override
  // Widget build(BuildContext context) {
  //   final Size screenSize = MediaQuery.of(context).size;
  //   return Scaffold(
  //       body: Container(
  //     width: screenSize.width,
  //     height: screenSize.height,
  //     alignment: Alignment.center,
  //     decoration: const BoxDecoration(
  //       // The background of the login-screen
  //       image: DecorationImage(
  //         image: AssetImage('assets/login_screen_background_image.png'),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //         // Container(
  //         //   child: Transform.scale(
  //         //     scale: 0.8,
  //         //     child: const Image(
  //         //       image: AssetImage('assets/giraf_splash_logo.png'),
  //         //     ),
  //         //   ),
  //         //  ),
  //           children: <Widget>[
  //             Expanded(
  //               child: PictogramPassword(
  //                 onPasswordChanged: (String pass) {
  //                   onPasswordUpdate(pass);
  //                   },
  //                 api: di.get<Api>()),
  //             ),
  //         // Spacer(),
  //         Stack(
  //           // crossAxisAlignment: CrossAxisAlignment.center,
  //           // mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Container(
  //               alignment: Alignment.centerRight,
  //               padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
  //               child: Transform.scale(
  //                 scale: 1.2,
  //                 child: ElevatedButton(
  //                   style: girafButtonStyle,
  //                   child: const Text(
  //                     'Brug standard adgangskode',
  //                     key: Key('UseNormalPasswordKey'),
  //                     style:
  //                     TextStyle(color: theme.GirafColors.white),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute<void>(
  //                             builder: (BuildContext context) =>
  //                                 LoginScreen()
  //                         )
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             const Spacer(),
  //             Center(
  //               child: Container(
  //                 child: ElevatedButton(
  //                     style: girafButtonStyle,
  //                     child: const Text(
  //                   'Login',
  //                   key: Key('PictogramLoginKey'),
  //                   style:
  //                   TextStyle(color: theme.GirafColors.white),
  //                   ),
  //                   onPressed: () {
  //
  //                   }
  //               )),
  //             )
  //           ]
  //         )
  //       ],
  //     ),
  //   ));
  // }

  Widget build(BuildContext context) {
    return Scaffold(

        //appBar: GirafAppBar(title: 'Ny bruger'),
        body: ListView(shrinkWrap: false, children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: StreamBuilder<bool>(
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return const Text('Opret piktogram kode til ',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: GirafColors.grey,
                          fontSize: 28,
                          fontWeight: FontWeight.bold));
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PictogramPassword(
                onPasswordChanged: (String pass) {
                  onPasswordUpdate(pass);
                },
                api: di.get<Api>(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: StreamBuilder<bool>(
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return const GirafButton(
                  key: const Key('saveButton'),
                  icon: const ImageIcon(AssetImage('assets/icons/save.png')),
                  text: 'Gem bruger',
                  isEnabled: false,
                  onPressed: null,


                );
              },
            ),
          ),
        ]));
  }
}
