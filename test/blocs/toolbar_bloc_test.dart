import 'package:api_client/api/api.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';

void main() {
  ToolbarBloc bloc;
  Api api;

  setUp(() {
    di.clearAll();
    api = Api('any');
    di.registerDependency<Api>((_) => api);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    bloc = ToolbarBloc();
    di.registerDependency<ToolbarBloc>((_) => bloc);
  });

  test('Should insert log out icon when none are defined',
      async((DoneFn done) {
    bloc.visibleButtons.skip(1).listen((List<IconButton> response) {
      expect(response.length, 1);
      done();
    });
    bloc.updateIcons(null, null);
  }));

  test('Defined icon is added to stream', async((DoneFn done) {
    final Map<AppBarIcon, VoidCallback> icons = <AppBarIcon, VoidCallback>{
      AppBarIcon.undo: null
    };

    bloc.visibleButtons.skip(1).listen((List<IconButton> response) {
      expect(response.length, 1);
      done();
    });

    bloc.updateIcons(icons, null);
  }));

  test('Defined icons are added to stream', async((DoneFn done) {
    final Map<AppBarIcon, VoidCallback> icons = <AppBarIcon, VoidCallback>{
      AppBarIcon.undo: null,
      AppBarIcon.search: null
    };

    bloc.visibleButtons.skip(1).listen((List<IconButton> response) {
      expect(response.length, 2);
      done();
    });

    bloc.updateIcons(icons, null);
  }));
}
