import 'dart:math';

import 'package:api_client/models/displayname_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/style/font_size.dart';

/// Citizen avatar used for choose citizen screen
class CitizenAvatar extends StatelessWidget {
  /// Constructor for the citizens avatar
  const CitizenAvatar({this.displaynameModel, this.onPressed});

  /// Usermodel for displaying a user
  final DisplayNameModel displaynameModel;

  /// Callback when pressed
  final VoidCallback onPressed;

  bool _isTablet(MediaQueryData query) {
    final Size size = query.size;
    final double diagonal =
    sqrt((size.width * size.width) + (size.height * size.height));
    return diagonal > 1100.0;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData query = MediaQuery.of(context);
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
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 200.0,
                            maxWidth: 200.0,
                            minHeight: 15.0,
                            maxHeight: _isTablet(query) ? 50.0 : 15.0,
                          ),
                          child: Center(
                            child: AutoSizeText(
                              displaynameModel.displayName.length <= 15
                                  ? displaynameModel.displayName
                                  : displaynameModel.displayName
                                                    .substring(0, 14) + '..',
                              key: const Key('WidgetText'),
                              style:
                              TextStyle(fontSize: _isTablet(query) ?
                              GirafFont.large : GirafFont.small),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      )
      ,
    );
  }
}
