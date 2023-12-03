// ignore_for_file: lines_longer_than_80_chars, always_specify_types

import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';
import 'package:weekplanner/widgets/navigation_menu.dart';
// ignore: public_member_api_docs
class NewWeekplanScreen extends StatelessWidget {


  // ignore: public_member_api_docs
  NewWeekplanScreen({
    @required this.user,
    @required this.existingWeekPlans,
  }) : _bloc = di.get<NewWeekplanBloc>() {
    _bloc.initialize(user);
  }
  // ignore: public_member_api_docs
  final DisplayNameModel user;
  // ignore: public_member_api_docs
  final Stream<List<WeekNameModel>> existingWeekPlans;
  final NewWeekplanBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: InputNavigatoinMenu(
            ),
          ),
          Expanded(
            flex: 7,
            child: InputFieldsWeekPlan(
              bloc: _bloc, button: null,
            ),
          ),
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: IconButton(
                                  key: const Key('CheckIcon'),
                                  padding: const EdgeInsets.all(0.0),
                                  color: Colors.black, // Icon color
                                  icon: const Icon(Icons.check, size: 60),
                                  onPressed: () async {
                                    final WeekModel newWeekPlan = await _bloc.saveWeekplan(
                                      screenContext: context,
                                      existingWeekPlans: existingWeekPlans,
                                    );
                                    try {
                                      if (newWeekPlan != null) {
                                        Routes().pop<WeekModel>(context, newWeekPlan);
                                      }
                                    } catch (err) {
                                      print('No new weekplan exists' '\n Error: ' + err.toString());
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: IconButton(
                                  key: const Key('CloseIcon'),
                                  padding: const EdgeInsets.all(0.0),
                                  color: Colors.black, // Icon color
                                  icon: const Icon(Icons.close, size: 60),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: IconButton(
                                  key: const Key('copy'),
                                  padding: const EdgeInsets.all(0.0),
                                  color: Colors.black, // Icon color
                                  icon: const Icon(Icons.copy, size: 60),
                                  onPressed: () {

                                  },
                                ),
                              ),

                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: IconButton(
                                  key: const Key('cancel'),
                                  padding: const EdgeInsets.all(0.0),
                                  color: Colors.black, // Icon color
                                  icon: const Icon(Icons.cancel, size: 60),
                                  onPressed: () {

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
            ),
          ),
        ],
      ),

    );
  }
}