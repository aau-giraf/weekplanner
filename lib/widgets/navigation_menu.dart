import 'package:flutter/material.dart';

class InputNavigationMenu extends StatefulWidget {
  @override
  InputNavigationMenuState createState() => InputNavigationMenuState();
}

class InputNavigationMenuState extends State<InputNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
        children: [
            Container(
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
                      mainAxisSize: MainAxisSize.min,
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
                                  Scaffold.of(context).openDrawer();
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
    );
  }
}