import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/weekplan_select_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class WeekplanSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WeekplanSelectBloc bloc = WeekplanSelectBloc(Globals.api, GirafUserModel());

    return Scaffold(
      appBar: GirafAppBar(title: "Vælg ugeplan"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<List<WeekModel>>(
                stream: bloc.weekmodels,
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<WeekModel>> snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }

                  return GridView.count(
                    crossAxisCount: 3,
                    children: snapshot.data.map((WeekModel week) {
                      return _buildIcon(context, week);
                    }).toList(),
                  );
              }),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIcon(BuildContext context, WeekModel gram) {
    return StreamBuilder<Image>(
      builder: (context, snapshot) {
        return Card(
            child: FittedBox(
                fit: BoxFit.contain, child: Icon(Icons.ac_unit)));
      }
    );
  }
}

 
