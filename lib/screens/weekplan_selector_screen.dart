import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeekplanSelectorScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: "Vælg ugeplan",
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              // Padding for edges of grid.
              padding: const EdgeInsets.all(20.0),
              // Padding between collumns.
              mainAxisSpacing: 20.0,
              // Padding between rows.
              crossAxisSpacing: 20.0,
              children: <Widget>[
                _buildWeekPlanSelector(context, "Jonas Ugeplan"),
                _buildWeekPlanSelector(context, "Den bedste ugeplan 2018"),
                _buildWeekPlanSelector(context, "Ralles ugeplan"),
                _buildWeekPlanSelector(context, "Lasse ugeplan som også er meget lang lang lang lang lang lang lang lang lang lang lang lang lang lang"),
                _buildWeekPlanSelector(context, "En meget lang tekst som går ud over måske?")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeekPlanSelector(context, weekplanName){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(
                        builder: (context, constraint){
                          return Icon(
                            Icons.monetization_on,
                            size: constraint.biggest.height,
                          );
                        }
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        weekplanName,
                        style: TextStyle(fontSize: 20.0),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}