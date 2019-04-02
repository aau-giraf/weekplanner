import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// Screen to show activity, mark done/canceled and see timer.
class ShowActivityScreen extends StatelessWidget {
  ///
  ShowActivityScreen(this._activity, {Key key}) : super(key: key) {
    _PictoImagebloc.load(_activity.pictogram);
  }

  final ActivityModel _activity;
  final PictogramImageBloc _PictoImagebloc =
      di.getDependency<PictogramImageBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Activitet',
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(color: Colors.green),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('Aktivitet', style: TextStyle(
                          fontSize: 30)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.add)
                  ),
                  Expanded(
                    flex: 1,
                    child: ButtonBar(
                      mainAxisSize: MainAxisSize.max,
                      alignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(onPressed: null, child: Icon(Icons.check)),
                        RaisedButton(onPressed: null, child: Icon(Icons.cancel))
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(color: Colors.orange),
            ),
          )
        ],
      ),
    );
  }
}
