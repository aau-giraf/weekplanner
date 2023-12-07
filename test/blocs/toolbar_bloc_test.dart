@Timeout(Duration(seconds: 5))

import 'package:api_client/api/api.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';

void main() {
  Api api = Api('baseUrl');
  late ToolbarBloc bloc;

  setUp(() {
    di.clearAll();
    api = Api('any');
    di.registerDependency<Api>(() => api);
    di.registerDependency<AuthBloc>(() => AuthBloc(api));
    bloc = ToolbarBloc();
    di.registerDependency<ToolbarBloc>(() => bloc);
  });

  test('Should insert log out icon when none are defined',
      async((DoneFn done) {
        // Creates listener for visibleButtons, using a list of IconButtons
        //When fired, it expects that the list contains one element
    bloc.visibleButtons.skip(1).listen((List<IconButton> response) {
      expect(response.length, 1);
      done();
    });
    //Updates the icons on bloc with null and null.
    bloc.updateIcons(null, null);
  }));

  test('Defined icon is added to stream', async((DoneFn done) {
    // Creates a map method Icon setting AppBarIcon.undo to null.
    final Map<AppBarIcon, VoidCallback> icons = <AppBarIcon, VoidCallback>{
      AppBarIcon.undo: () {}
    };
    // Creates listener for visibleButtons to a list of IconButton
    //When fired, the response is expected to have one element.
    bloc.visibleButtons.skip(1).listen((List<IconButton> response) {
      expect(response.length, 1);
      done();
    });
    //Updates bloc with updateIcons and fires the listener.
    bloc.updateIcons(icons, null);
  }));

  test('Defined icons are added to stream', async((DoneFn done) {
    // Creates map method called icons, setting AppBarIcon.undo and .search
    // to null
    final Map<AppBarIcon, VoidCallback> icons = <AppBarIcon, VoidCallback>{
      AppBarIcon.undo: () {},
      AppBarIcon.search: () {}
    };
    // Creates Listener on visibleButtons to a list of IconButtons
    // Expects the response be to have two elements
    bloc.visibleButtons.skip(1).listen((List<IconButton> response) {
      expect(response.length, 2);
      done();
    });
    //Updates the bloc with updateIcons carrying the icon, firing the listener
    bloc.updateIcons(icons, null);
  }));
}
