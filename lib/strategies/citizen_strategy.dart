import 'Role_strategy.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_3button_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

import '../style/custom_color.dart' as theme;

class CitizenStrategy implements RoleStrategy {


  @override
  _buildWeekplanColumnview(BuildContext context){
    final Stream<List<WeekModel>> weekModels = widget._weekBloc.weekModels;
    final Stream<List<WeekModel>> oldWeekModels =
        widget._weekBloc.oldWeekModels;
    // Container which holds all of the UI elements on the screen
    return Container(
        child: Column(children: <Widget>[
          Expanded(
              flex: 5, child: _buildWeekplanGridview(context, weekModels, true)),
          // Overstået Uger bar
          InkWell(
            child: Container(
              color: Colors.grey,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(10.0, 3, 0, 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const AutoSizeText(
                    'Overståede uger',
                    style: TextStyle(fontSize: GirafFont.small),
                    maxLines: 1,
                    minFontSize: 14,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  showOldWeeks
                  // Icons for showing and hiding the old weeks are inside this
                  // When the old weeks are shown, show the hide icon
                      ? Expanded(
                    flex: 1,
                    child: IconButton(
                      key: const Key('HideOldWeeks'),
                      padding: const EdgeInsets.all(0.0),
                      alignment: Alignment.centerRight,
                      color: Colors.black,
                      icon: const Icon(Icons.remove, size: 50),
                      onPressed: () {
                        _toggleOldWeeks();
                      },
                    ),
                  )
                  // Icons for showing and hiding the old weeks are inside this
                  // When the old weeks are hidden, show the hide icon
                      : Expanded(
                    flex: 1,
                    child: IconButton(
                      key: const Key('ShowOldWeeks'),
                      padding: const EdgeInsets.all(0.0),
                      alignment: Alignment.centerRight,
                      color: Colors.black,
                      icon: const Icon(Icons.add, size: 50),
                      onPressed: () {
                        _toggleOldWeeks();
                      },
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              _toggleOldWeeks();
            },
          ),

          Visibility(
              visible: showOldWeeks,
              child: Expanded(
                  flex: 5,
                  child: Container(
                    // Container with old weeks if shown
                    // Background color of the old weeks
                      color: Colors.grey.shade600,
                      child:
                      _buildWeekplanGridview(context, oldWeekModels, false))))
        ]));


  }

}