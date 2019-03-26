import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthBloc authBloc;
  final ToolbarBloc toolbarBloc;
  final UserInfoBloc userInfoBloc;

  GirafAppBar({Key key, this.title})
      : authBloc = di.getDependency<AuthBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        userInfoBloc = di.getDependency<UserInfoBloc>(),
        preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xAAFF6600),
      actions: <Widget>[
        StreamBuilder<bool>(
            key: Key('streambuilderVisibility'),
            stream: toolbarBloc.editVisible,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              return Visibility(
                key: Key("visibilityEditBtn"),
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
            if (_userInfoBloc.isGuardian) {
              _userInfoBloc.setUserMode('Citizen');
            }
            else{
              _userInfoBloc.setUserMode('Guardian');
            }
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
