import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthBloc _authBloc;
  final UserInfoBloc _userInfoBloc;

  GirafAppBar({Key key, this.title})
      : _authBloc = di.getDependency<AuthBloc>(),
        _userInfoBloc = di.getDependency<UserInfoBloc>(),
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
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Indstillinger',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.subdirectory_arrow_right),
            tooltip: 'trains',
            onPressed: () {
              _authBloc.logout();
            },
          ),
          IconButton(
            icon: Icon(Icons.place),
            tooltip: 'trains',
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              if (_userInfoBloc.isGuardian) {
                _userInfoBloc.setUserMode("Citizen");
              }
              else{
                _userInfoBloc.setUserMode("Guardian");
              }

            },
          )

        ]);
  }
}
