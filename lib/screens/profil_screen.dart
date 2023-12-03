
// ignore_for_file: public_member_api_docs, always_specify_types, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_drawer.dart';

import '../widgets/navigation_menu.dart';


class ProfileScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: InputNavigationMenu(),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              padding: portrait
                  ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                  : const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: portrait
                            ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                            : const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Profil - concept page',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 60.0,
                                  fontFamily: 'Quicksand-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                key: const Key('EditUser'),
                                padding: portrait
                                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                                    : const EdgeInsets.fromLTRB(310, 0, 40, 0),
                                color: Colors.black,
                                icon: const Icon(Icons.create_outlined, size: 50),
                                onPressed: () {
                                  ///_pushEditWeekPlan(context); //Does not work yet
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 60.0),
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage: AssetImage('assets/icons/login_logo.png'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBox('Bruger navn', 'rasmus1238'),
                        const SizedBox(height: 24.0),
                        _buildBox('Navn', 'Rasmus rasmus'),
                        const SizedBox(height: 24.0),
                        _buildBox('Kode', '********'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: screenSize.height,
              child: Image.asset(
                'assets/icons/giraf_blue_long.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      drawer: GirafDrawer(),
    );
  }



  Widget _buildBox(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            value,
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}