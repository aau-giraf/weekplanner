import 'package:async_test/async_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/providers/api/api.dart';

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

  test('Defined icon is added to stream', async((DoneFn done) {
    List<AppBarIcon> iconsList;
    iconsList = <AppBarIcon>[];
    iconsList.add(AppBarIcon.undo);
    bloc.updateIcons(iconsList, null);

    bloc.visibleButtons.listen((List<IconButton> response) {
      expect(response.length, 1);
    });

    done();
  }));

  test('Defined icons are added to stream', async((DoneFn done) {
    List<AppBarIcon> iconsList;
    iconsList = <AppBarIcon>[];
    iconsList.add(AppBarIcon.undo);
    iconsList.add(AppBarIcon.search);
    bloc.updateIcons(iconsList, null);

    bloc.visibleButtons.listen((List<IconButton> response) {
      expect(response.length, 2);
    });

    done();
  }));

}
