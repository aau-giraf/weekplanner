import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import 'package:weekplanner/routes.dart';

import 'giraf_button_widget.dart';

class InputFieldsWeekPlan extends StatefulWidget {
  /// Class created for keeping the input fields for the new and
  /// edit week plan screen consisten-t
  InputFieldsWeekPlan({
    @required this.bloc,
    @required this.button,
    this.weekModel
  });
  NewWeekplanBloc bloc;
  GirafButton button;
  WeekModel weekModel;

  final TextStyle _style = const TextStyle(fontSize: 20);

  @override
  InputFieldsWeekPlanState createState() => InputFieldsWeekPlanState();
}

class InputFieldsWeekPlanState extends State<InputFieldsWeekPlan> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          _titleInputField(),
          _yearInputField(),
          _weekNumberInputField(),
          _pictogramInputField(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: widget.button,
            ),
          ])
        ]
    );
  }

  Widget _titleInputField(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: StreamBuilder<bool>(
            stream: widget.bloc.validTitleStream,
            builder:
                (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return TextFormField(
                key: const Key('NewWeekplanTitleField'),
                onChanged: widget.bloc.onTitleChanged.add,
                initialValue: widget.weekModel == null
                  ? ''
                  : widget.weekModel.name,
                keyboardType: TextInputType.text,
                // To avoid emojis and other special characters
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter(
                      RegExp('[ -~\u00C0-\u00FF]'))
                ],
                style: widget._style,
                decoration: InputDecoration(
                    labelText: 'Titel',
                    errorText: (snapshot?.data == false)
                        ? 'Titel skal angives'
                        : null,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide())),
              );
            })
    );
  }

  Widget _yearInputField(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: StreamBuilder<bool>(
            stream: widget.bloc.validYearStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                onChanged: widget.bloc.onYearChanged.add,
                initialValue: widget.weekModel == null
                    ? ''
                    : widget.weekModel.weekYear.toString(),
                style: widget._style,
                decoration: InputDecoration(
                    labelText: 'År',
                    errorText: (snapshot?.data == false)
                        ? 'År skal angives som fire cifre'
                        : null,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide())),
              );
            })
    );
  }

  Widget _weekNumberInputField() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: StreamBuilder<bool>(
            stream: widget.bloc.validWeekNumberStream,
            builder:
                (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                onChanged: widget.bloc.onWeekNumberChanged.add,
                initialValue: widget.weekModel == null
                    ? ''
                    : widget.weekModel.weekNumber.toString(),
                style: widget._style,
                decoration: InputDecoration(
                    labelText: 'Ugenummer',
                    errorText: (snapshot?.data == false)
                        ? 'Ugenummer skal være mellem 1 og 53'
                        : null,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide())),
              );
            })
    );
  }

  Widget _pictogramInputField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        key: const Key('NewWeekplanThumbnailKey'),
        width: 200,
        height: 200,
        child: StreamBuilder<PictogramModel>(
          stream: widget.bloc.thumbnailStream,
          builder: _buildThumbnail,
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, AsyncSnapshot<PictogramModel> snapshot) {
    if (snapshot?.data == null) {
      return GestureDetector(
        onTap: () => _openPictogramSearch(context, widget.bloc),
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('Vælg billede til ugeplan', style: widget._style),
              ),
              Expanded(child: Image.asset('assets/icons/galleryBig.png')),
            ],
          ),
        ),
      );
    } else {
      return PictogramImage(
          pictogram: snapshot.data,
          onPressed: () => _openPictogramSearch(context, widget.bloc));
    }
  }

  void _openPictogramSearch(BuildContext context, NewWeekplanBloc bloc) {
    Routes.push<PictogramModel>(context, PictogramSearch())
        .then((PictogramModel pictogram) {
      if (pictogram != null) {
        bloc.onThumbnailChanged.add(pictogram);
      }
    });
  }

}


