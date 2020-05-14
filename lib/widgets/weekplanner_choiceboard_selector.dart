import 'package:flutter/material.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';
import '../style/custom_color.dart' as theme;
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';

///This is a class
class WeekplannerChoiceboardSelector extends StatelessWidget {
  ///Constructor
  WeekplannerChoiceboardSelector(
        this._activity
      );

  final ActivityModel _activity;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        titlePadding: const EdgeInsets.all(0.0),
        shape: Border.all(
            color: theme.GirafColors.transparentDarkGrey, width: 5.0),
        title: const Center(
            child: GirafTitleHeader(
              title: 'Vælg aktivitet',
            )),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: displayPictograms(context)
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: GirafButton(
                        key: const Key('TimePickerDialogCancelButton'),
                        onPressed: () => Routes.pop(context),
                        icon: const ImageIcon(
                            AssetImage('assets/icons/cancel.png')),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPictogram(ActivityModel activity) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();
    bloc.loadPictogramById(activity.pictograms.first.id);
    return StreamBuilder<Image>(
      stream: bloc.image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }
        return Container(
            child: snapshot.data, key: const Key('PictogramImage'));
      },
    );
  }

  /// This is a function
  Widget displayPictograms(BuildContext context) {
    List<Widget> pictograms = [_getPictogram(_activity), _getPictogram(_activity), _getPictogram(_activity), _getPictogram(_activity)];

    List<Widget> temp = [ ];

    for(int i = 0; i < pictograms.length; i++) {
      temp.add(displayPictogram(context, pictograms, i));
    }

    return Container(
      child: Row(
        children: temp,
      ),
    );
  }

  Widget displayPictogram(BuildContext context, List<Widget> pictograms, int index) {
    return GestureDetector(
      onTap: () {
        selectedPictogramFromChoiceBoard(context, pictograms, index);
      },
      child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 5,
        maxHeight: MediaQuery.of(context).size.height / 1.2,
      ),
      decoration: BoxDecoration(
          border: Border.all(
              color: theme.GirafColors.blueBorderColor, width: 1)),
      child: pictograms[index],
    )
    );
  }

  Widget selectedPictogramFromChoiceBoard(BuildContext context, List<Widget> pictograms, int index) {
    _activity.isChoiceBoard = false;
    print(index);

    List<Widget> selectedPictogram = [pictograms[index]];

    ///TODO: Når backendvirker implementer dette
    ///_activity.pictogram = selectedPictogram;

    Routes.pop(context);
  }



}