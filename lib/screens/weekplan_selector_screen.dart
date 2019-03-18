import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/weekplan_select_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeekplanSelectorScreen extends StatelessWidget {
  //final WeekplanSelectBloc weekplanSelectBloc(Globals.api);
  WeekplanSelectBloc testBloc = WeekplanSelectBloc(Globals.api);

  @override
  Widget build(BuildContext context) {
    //weekplanSelectBloc = BlocProviderTree.of<WeekplanSelectBloc>(context);
    testBloc.load();

    return Scaffold(
      appBar: GirafAppBar(
        title: "Vælg ugeplan",
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<List<WeekModel>>(
                  stream: testBloc.weekmodels,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<WeekModel>> snapshot) {
                    if (snapshot.data == null) {
                      return CircularProgressIndicator();
                    }
                    return GridView.count(
                      crossAxisCount: 3,
                      children: snapshot.data.map((WeekModel weekplan) {
                        return _buildWeekPlanSelector(context, weekplan);
                      }).toList(),
                    );
                  })),
        ],
      ),
    );
  }

  Widget _buildCreateWeekPlan(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Card(
                color: Color(0xFFf7f7f7),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return Icon(
                          Icons.add,
                          size: constraint.biggest.height,
                        );
                      }),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          "Tilføj ny ugeplan",
                          style: TextStyle(fontSize: 30.0),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekPlanSelector(context, weekplan) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () { Navigator.pushNamed(context, "/routerLinkHere");},
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return Icon(
                          Icons.monetization_on,
                          size: constraint.biggest.height,
                        );
                      }),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          weekplan.name,
                          style: TextStyle(fontSize: 30.0),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
