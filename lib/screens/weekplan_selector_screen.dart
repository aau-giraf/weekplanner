import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

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
              children: <Widget>[
                _buildWeekPlanSelector(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeekPlanSelector(context){
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
                    child: LayoutBuilder(
                        builder: (context, constraint){
                          return Text(
                            "Jonas Ugeplan",
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: constraint.biggest.height/30.0));
                        }
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