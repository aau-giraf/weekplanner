import 'package:api_client/models/username_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Citizen avatar used for choose citizen screen
class CitizenAvatar extends StatelessWidget {
  /// Constructor for the citizens avatar
  const CitizenAvatar({this.usernameModel, this.onPressed});

  /// Usermodel for displaying a user
  final UsernameModel usernameModel;
  /// Callback when pressed
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              child: const CircleAvatar(
                                key: Key('WidgetAvatar'),
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/login_screen_background_image.png'),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: AutoSizeText(
                            usernameModel.name.length <= 15
                                ? usernameModel.name
                                : usernameModel.name.substring(0, 14) + '..',
                            style: const TextStyle(fontSize: 40.0),
                            key: const Key('WidgetText'),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
