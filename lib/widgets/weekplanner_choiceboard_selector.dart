import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

import '../style/custom_color.dart' as theme;
import 'giraf_confirm_dialog.dart';

///This is a class
class WeekplannerChoiceboardSelector extends StatelessWidget {
  ///Constructor
  WeekplannerChoiceboardSelector(this._activity, this._activityBloc, this._user,
      this._weekplanBloc, this._week) {
    _activityBloc.load(_activity, _user);
  }

  final ActivityModel _activity;

  final WeekplanBloc _weekplanBloc;

  final WeekModel _week;

  final DisplayNameModel _user;

  final ActivityBloc _activityBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        key: const Key('ChoiceBoardActivitySelector'),
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
                  child: displayPictograms(context)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                        child: GirafButton(
                          key: const Key('ChoiceBoardDialogCancelButton'),
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
      ),
    );
  }

  Widget _getPictogram(PictogramModel pictogram) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();
    bloc.loadPictogramById(pictogram.id);
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
    final List<Widget> pictograms = <Widget>[];
    for (int i = 0; i < _activity.pictograms.length; i++) {
      pictograms.add(_getPictogram(_activity.pictograms[i]));
    }

    final List<Widget> pictogramImages = <Widget>[];

    for (int i = 0; i < pictograms.length; i++) {
      pictogramImages.add(
        _displayPictogram(context, pictograms, i),
      );
    }

    return Container(
      child: Row(
        key: const Key('SelectorPictogram'),
        children: pictogramImages,
      ),
    );
  }

  Widget _displayPictogram(
      BuildContext context, List<Widget> pictograms, int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
      child: FittedBox(
        child: GestureDetector(
            onTap: () {
              _selectedPictogramFromChoiceBoard(context, pictograms, index)
                  .then((_) {
                Routes.pop(context);
              });
            },
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: theme.GirafColors.blueBorderColor, width: 1)),
              child: pictograms[index],
            )),
      ),
    );
  }

  Future<Center> _selectedPictogramFromChoiceBoard(
      BuildContext context, List<Widget> pictograms, int index) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              key: const Key('PictogramSelectorConfirmDialog'),
              title: 'Vælg aktivitet',
              description: 'Vil du vælge aktiviteten ' +
                  _activity.pictograms[index].title,
              confirmButtonText: 'Ja',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/accept.png')),
              confirmOnPressed: () {
                _activity.isChoiceBoard = false;
                final List<PictogramModel> _pictogramModels = <PictogramModel>[
                  _activity.pictograms[index]
                ];
                _activity.pictograms = _pictogramModels;

                _activityBloc.update();
                _activityBloc.activityModelStream.skip(1).take(1).listen((_) {
                  _weekplanBloc.loadWeek(_week, _user);
                  Routes.pop(context);
                });
                // Closes the dialog box
              },
              cancelOnPressed: () {});
        });
  }
}
