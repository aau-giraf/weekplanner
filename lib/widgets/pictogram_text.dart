import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';

/// This is a widget used to create text under the pictograms
class PictogramText extends StatelessWidget {
  /// Constructor
  const PictogramText(this._pictogram, this._settingsBloc,
      {this.minFontSize = 100});

  /// The pictogram to build the text for
  final PictogramModel _pictogram;

  /// The settings bloc which we get the settings from, you need to make sure
  /// you have loaded settings into it before hand otherwise text is never build
  final SettingsBloc _settingsBloc;

  /// Determines the minimum font size that text can scale down to
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final bool hasPictogramText = settingsSnapshot.data.pictogramText;
            if (hasPictogramText) {
              final String pictogramText = _pictogram.title.toUpperCase();
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context).size.width * 0.05),
                    child: AutoSizeText(
                      pictogramText,
                      minFontSize: minFontSize,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      // creates a ... postfix if text is too long (overflows)
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 150),
                    ),
                  ));
            }
          }
          return Container(width: 0, height: 0);
        });
  }
}
