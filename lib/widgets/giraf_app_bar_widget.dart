import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ToolbarBloc toolbarBloc;
  GirafAppBar({Key key, this.toolbarBloc, this.title}) : preferredSize = Size.fromHeight(56.0), super(key: key);

  @override
  final Size preferredSize;
  // Adding this.variablename to the constructor automatically assigns the value to the right variable.

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xAAFF6600),
      actions: <Widget>[
        StreamBuilder<bool>(
            stream: toolbarBloc.editVisible,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              return Visibility(
                visible: snapshot.data,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'Rediger',
                  onPressed: () {
                  },
                ),
              );
            }
        ),

        IconButton(
          icon: Icon(Icons.people),
          tooltip: 'Skift mode',

          onPressed: () {

          },
        ),

        IconButton(
          icon: Icon(Icons.settings),
          tooltip: 'Indstillinger',
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ]
    );
  }
}
