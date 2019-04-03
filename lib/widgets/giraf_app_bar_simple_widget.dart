import 'package:flutter/material.dart';

class GirafAppBarSimple extends StatelessWidget implements PreferredSizeWidget {
  const GirafAppBarSimple({Key key, this.title, this.leading})
      : super(key: key);

  final String title;
  final Widget leading;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: const Color(0xAAFF6600),
      leading: leading,
    );
  }
}