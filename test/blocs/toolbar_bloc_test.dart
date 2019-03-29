import 'package:flutter_test/flutter_test.dart';

import 'package:weekplanner/blocs/toolbar_bloc.dart';


void main() {
  test('Stream should emit true', () {
    final ToolbarBloc toolbarBloc = ToolbarBloc();
    toolbarBloc.setEditVisible(true);
    expect(toolbarBloc.editVisible, emits(true));
  });

  test('Stream should emit false', () {
    final ToolbarBloc toolbarBloc = ToolbarBloc();
    toolbarBloc.setEditVisible(false);
    expect(toolbarBloc.editVisible, emits(false));
  });
}

