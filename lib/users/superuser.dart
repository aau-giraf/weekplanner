import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/Users/Iuser.dart';

import 'Iuser.dart';

class superuser implements Iuser{
  @override
  Widget build_avatar_icon_behavior (BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: const CircleAvatar(
          key: Key('PlaceholderAvatar'),
          radius: 20,
          backgroundImage: AssetImage('assets/login_screen_background_image.png'),
        ),
      ),
    );
  }
  @override
  Widget build_choice_board_behavior (){

  }

}