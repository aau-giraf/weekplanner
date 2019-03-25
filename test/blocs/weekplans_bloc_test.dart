import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:async_test/async_test.dart';
import 'package:weekplanner/providers/api/week_api.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplansBloc bloc;
  Api api;
  MockWeekApi weekApi;

  setUp(() {
    api = Api("any");
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = WeekplansBloc(api);
  });

  test("Should be able to load weekplans for a user", async((DoneFn done) {
    List<WeekNameModel> weekNameModelList = [];

    WeekNameModel weekNameModel =
        new WeekNameModel(name: "name", weekNumber: 1, weekYear: 1);
    weekNameModelList.add(weekNameModel);

    when(weekApi.getNames("test"))
        .thenAnswer((_) => BehaviorSubject.seeded(weekNameModelList));

    List<WeekModel> weekModelList = [];
    WeekModel weekModel = WeekModel(name: "weekModel");
    weekModelList.add(weekModel);

    when(weekApi.get("test", weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject.seeded(weekModel));

    bloc.weekNameModels.listen((List<WeekNameModel> response) {
      expect(response, isNotNull);
      expect(response, equals(weekNameModelList));
    });

    bloc.weekModels.listen((List<WeekModel> response) {
      expect(response, isNotNull);
      expect(response, equals(weekModelList));
      done();
    });

    bloc.load(GirafUserModel(id: "test"));
  }));

  test("Should dispose weekModels stream", async((DoneFn done) {
    bloc.weekModels.listen((_) {}, onDone: done);
    bloc.dispose();
  }));

  test("Should dispose weekNameModel stream", async((DoneFn done) {
    bloc.weekNameModels.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
