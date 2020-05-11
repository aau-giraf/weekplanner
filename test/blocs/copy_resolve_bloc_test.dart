import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/copy_resolve_bloc.dart';

void main() {
  CopyResolveBloc bloc;
  Api api;
  final WeekModel oldWeekmodel = WeekModel(
    name: 'test', weekNumber: 23, weekYear: 2020);

  final DisplayNameModel mockUser =
  DisplayNameModel(displayName: 'testName', role: 'testRole', id: 'testId');

  setUp(() {
    api = Api('any');
    bloc = CopyResolveBloc(api);
    bloc.initializeCopyResolverBloc(mockUser, oldWeekmodel);
  });


  test('Test createNewWeekmodel', async((DoneFn done) {
    // ignore: invalid_use_of_protected_member
    bloc.weekNoController.add('24');
    // ignore: invalid_use_of_protected_member
    bloc.weekNoController.listen((_) {
      final WeekModel newWeekModel = bloc.createNewWeekmodel(oldWeekmodel);
      expect(newWeekModel.weekNumber == 24, isTrue);
      done();
    });
  }));
}