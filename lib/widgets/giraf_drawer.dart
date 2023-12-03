import 'package:flutter/material.dart';

class GirafDrawer extends StatefulWidget {
  @override
  GirafDrawerState createState() => GirafDrawerState();
}

class GirafDrawerState extends State<GirafDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ugeplaner TEST XD'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Skift bruger'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/skift bruger');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log af'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/log af');
              },
            ),
          ],
        ),
    );
  }
}