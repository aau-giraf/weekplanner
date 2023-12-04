import 'package:flutter/material.dart';

class GirafDrawer extends StatefulWidget {
  @override
  GirafDrawerState createState() => GirafDrawerState();
}

class GirafDrawerState extends State<GirafDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: const Key('GirafDrawer'),
        child: ListView(
          children: [
            ListTile(
              key: const Key('Back'),
              leading: const Icon(Icons.arrow_back),
              title: const Text('Tilbage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              key: const Key('Profile'),
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profil');
              },
            ),
            ListTile(
              key: const Key('Change user'),
              leading: const Icon(Icons.change_circle_outlined),
              title: const Text('Skift bruger'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/skift bruger');
              },
            ),
            ListTile(
              key: const Key('Log off'),
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