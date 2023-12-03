import 'package:flutter/material.dart';

class InputNavigatoinMenu extends StatefulWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  InputNavigatoinMenuState createState() => InputNavigatoinMenuState();
}

class InputNavigatoinMenuState extends State<InputNavigatoinMenu> {
  final TextStyle _style = TextStyle(fontSize: 5.0); // Adjust the font size as needed

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: InputNavigatoinMenu._scaffoldKey,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(

              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/icons/giraf_blue_long.png',
                    repeat: ImageRepeat.repeat,
                    height: screenSize.height,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                key: const Key('NavigationMenu'),
                                padding: const EdgeInsets.all(0.0),
                                color: Colors.white,
                                icon: const Icon(Icons.menu, size: 55),
                                onPressed: () {
                                  InputNavigatoinMenu._scaffoldKey.currentState.openDrawer();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ugeplaner'),
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
      ),
    );
  }
}