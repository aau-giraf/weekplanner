import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/copy_resolve_bloc.dart';

void main() {
  Api api = Api('any');
  CopyResolveBloc bloc = CopyResolveBloc(api);
  final WeekModel oldWeekmodel = WeekModel(
      thumbnail:
          PictogramModel(title: 'title', accessLevel: AccessLevel.PRIVATE),
      name: 'test',
      weekNumber: 23,
      weekYear: 2020);

  final DisplayNameModel mockUser =
      DisplayNameModel(displayName: 'testName', role: 'testRole', id: 'testId');

  setUp(() {
    api = Api('any');
    bloc = CopyResolveBloc(api);
    bloc.initializeCopyResolverBloc(mockUser, oldWeekmodel);
  });

  // Tests functionality for creating a new weekmodel,
  // which is used when creating a new week plan.
  test('Test createNewWeekmodel', async((DoneFn done) {
    // Add week 24 to the weekNoController
    // ignore: invalid_use_of_protected_member
    bloc.weekNoController.add('24');

    // Create a listener for the weekNoController to check for any updates.
    // ignore: invalid_use_of_protected_member
    bloc.weekNoController.listen((_) {
      // Create a new dummy weekmodel based on the old weekmodel.
      final WeekModel newWeekModel = bloc.createNewWeekmodel(oldWeekmodel);

      // Check if the new weekmodel has the correct weeknumber.
      expect(newWeekModel.weekNumber == 24, isTrue);

      done();
    });
  }));
}
