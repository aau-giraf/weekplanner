import 'dart:async';

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
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    bloc = ToolbarBloc();
    di.registerDependency<ToolbarBloc>((_) => bloc);
  });

  test('Should insert standard icons when none are defined',
      async((DoneFn done) {
    bloc.updateIcons(null, null);
    bloc.visibleButtons.listen((List<IconButton> response) {
      expect(response.length, 2);
    });
    done();
  }));

  test('Defined icon is added to stream', async((DoneFn done) async {
    final Completer<bool> done = Completer<bool>();
    final Map<AppBarIcon, VoidCallback> icons = <AppBarIcon, VoidCallback>
    {AppBarIcon.undo : null};
    
    bloc.visibleButtons.listen((List<IconButton> response) {
      expect(response.length, 1);
      done.complete();
    });

    bloc.updateIcons(icons, null);
    await done.future;
  }));

  test('Defined icons are added to stream', async((DoneFn done) {
    final Map<AppBarIcon, VoidCallback> icons = <AppBarIcon, VoidCallback>
    {AppBarIcon.undo : null, AppBarIcon.search: null};

    bloc.visibleButtons.listen((List<IconButton> response) {
      expect(response.length, 2);
      done();
    });

    bloc.updateIcons(icons, null);
  }));

}
