import 'package:api_client/api/activity_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/user_week_model.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(GirafUserModel(
        id: '1',
        department: 3,
        role: Role.Guardian,
        roleName: 'Guardian',
        displayName: 'Kurt',
        username: 'SpaceLord69'));
  }
}

class MockActivityApi extends Mock implements ActivityApi {
  @override
  Stream<ActivityModel> update(ActivityModel activity, String userId) {
    return rx_dart.BehaviorSubject<ActivityModel>.seeded(activity);
  }
  @override
  Stream<ActivityModel> add(ActivityModel activity, String userId,
      String weekplanName, int weekYear, int weekNumber, Weekday weekDay) {
    return rx_dart.BehaviorSubject<ActivityModel>.seeded(activity);
  }
}

void main() {
  WeekplanBloc weekplanBloc;
  Api api;

  WeekModel week;

  final DisplayNameModel user =
  DisplayNameModel(
    role: Role.Guardian.toString(),
    displayName: 'User',
    id: '1'
  );

  setUp(() {
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday)
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);

    api = Api('any');

    api.user = MockUserApi();
    api.week = MockWeekApi();
    api.activity = MockActivityApi();
    when(api.week.update(any, any, any, any)).thenAnswer((Invocation inv) {
      return Stream<WeekModel>.value(inv.positionalArguments[3]);
    });

    when(api.week.get(any, any, any)).thenAnswer((Invocation inv) {
      return Stream<WeekModel>.value(week);
    });
    when(api.week.getDay(any, any, any, any)).thenAnswer((Invocation inv) {
      return Stream<WeekdayModel>.value(week.days.singleWhere(
              (WeekdayModel day) => day.day == inv.positionalArguments[3]));
    });
    when(api.week.updateDay(any, any, any, any)).thenAnswer((Invocation inv) {
      return Stream<WeekdayModel>.value(inv.positionalArguments[3]);
    });

    weekplanBloc = WeekplanBloc(api);
  });

  test('Loads a weekplan for the weekplan view', async((DoneFn done) {
    // Loads up a week, listen for the done() function to be called. The expect
    // function evaluates if the weekplans functions correctly by looking at the
    // response.
    weekplanBloc.getWeek(week, user);
    weekplanBloc.userWeek.listen((UserWeekModel response) {
      expect(response, isNotNull);
      expect(response.week, equals(week));
      verify(api.week.get(user.id, week.weekYear, week.weekNumber));
      done();
    });
  }));

  test('Adds an activity to a list of marked activities', async((DoneFn done) {
    // Create an ActivityModel, to add to the list of marked activites.
    //Then looks for the marked activities within the list.
    // Skips the first entry
    final ActivityModel activityModel = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
            accessLevel: null,
            id: null,
            imageHash: null,
            imageUrl: null,
            lastEdit: null,
            title: 'test')
        ],
        id: 1,
        isChoiceBoard: null,
        order: null,
        state: null
    );

    weekplanBloc.markedActivities
        .skip(1)
        .listen((List<ActivityModel> markedActivitiesList) {
      expect(markedActivitiesList.length, 1);
      done();
    });

    // Add the ActivityModel to the list of marked activities.
    weekplanBloc.addMarkedActivity(activityModel);
  }));

  test('Removes an activity to a list of marked activities',
      async((DoneFn done) {
        //Creates two activities and addes them to a list.
        //Creates a listener for activities on the list.
        //Removes one activity, and checks that the list lenght is = 1
    final ActivityModel firstActivityModel = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
            accessLevel: null,
            id: null,
            imageHash: null,
            imageUrl: null,
            lastEdit: null,
            title: 'test')
        ],
        id: 1,
        isChoiceBoard: null,
        order: null,
        state: null);

    final ActivityModel secondActivityModel = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
              accessLevel: null,
              id: null,
              imageHash: null,
              imageUrl: null,
              lastEdit: null,
              title: 'test123')
        ],
        id: 2,
        isChoiceBoard: null,
        order: null,
        state: null);

    // Add marked activities to the list to prepare for the removal
    weekplanBloc.addMarkedActivity(firstActivityModel);
    weekplanBloc.addMarkedActivity(secondActivityModel);

    weekplanBloc.markedActivities
        .skip(1)
        .listen((List<ActivityModel> markedActivitiesList) {
      expect(markedActivitiesList.length, 1);
      done();
    });

    // Delete a marked activity
    weekplanBloc.removeMarkedActivity(secondActivityModel);
  }));

  test('Clears list of marked activities', async((DoneFn done) {
    //Creates an markedactivity and addes it to a list with a listener.
    //The listener fires the expect function, expecting the lenght = 0.
    //Uses the clearMarkedactivities() function to remove activities.
    // TODO actually add the activity to the list, including more than one act
    weekplanBloc.addMarkedActivity(ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
            accessLevel: null,
            id: null,
            imageHash: null,
            imageUrl: null,
            lastEdit: null,
            title: 'test')
        ],
        id: 123,
        isChoiceBoard: null,
        order: null,
        state: null));

    weekplanBloc.markedActivities
        .skip(1)
        .listen((List<ActivityModel> markedActivitiesList) {
      expect(markedActivitiesList.length, 0);
      done();
    });

    weekplanBloc.clearMarkedActivities();
  }));

  test('Checks if the activity is in the list of marked activities',
      async((DoneFn done) {
        //Checks if an activity is added to a list of marked activities.
    final ActivityModel activity = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
              accessLevel: null,
              id: null,
              imageHash: null,
              imageUrl: null,
              lastEdit: null,
              title: 'test123')
        ],
        id: 2,
        isChoiceBoard: null,
        order: null,
        state: null);

    weekplanBloc.markedActivities
        .skip(1)
        .listen((List<ActivityModel> markedActivitiesList) {
      expect(weekplanBloc.isActivityMarked(activity), true);
      done();
    });

    weekplanBloc.addMarkedActivity(activity);
  }));

  test('Checks if the edit mode toggles from false', async((DoneFn done) {
    //Checks if the edit mode can be toggled from false to true.
    /// Editmode stream initial value is false.
    weekplanBloc.editMode.skip(1).listen((bool toggle) {
      expect(toggle, true);
      done();
    });

    weekplanBloc.toggleEditMode();
  }));

  test('Checks if marked activities are deleted from a users weekplan',
      async((DoneFn done) {
        //Test if the api.week.update function get called
        //This test should propperly ensure that the activities are deleted
        //though an expect, instead of just making sure that the function
        //is called
        // TODO:Add expect to ensure that the list is empty
    final DisplayNameModel user = DisplayNameModel(
      role: Role.Citizen.toString(),
      displayName: 'User',
      id: '1'
    );

    final ActivityModel activity = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
              accessLevel: null,
              id: null,
              imageHash: null,
              imageUrl: null,
              lastEdit: null,
              title: 'test123')
        ],
        id: 2,
        isChoiceBoard: null,
        order: null,
        state: null);
    week.days[0].activities.add(activity);
    weekplanBloc.getWeek(week, user).whenComplete(() {
          weekplanBloc.setDaysToDisplay(1, 0);
          weekplanBloc.addWeekdayStream();
          weekplanBloc.addMarkedActivity(activity);
          weekplanBloc.deleteMarkedActivities();
          verify(api.week.updateDay(any, any, any, any));
          done();
        }
    );
  }));

  test('Checks if marked activities are copied to a new day',
      async((DoneFn done) {
        // Creates a user
    final DisplayNameModel user = DisplayNameModel(
      role: Role.Citizen.toString(),
      displayName: 'User',
      id: '1'
    );
    // Creates an activity
    final ActivityModel activity = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
              accessLevel: null,
              id: null,
              imageHash: null,
              imageUrl: null,
              lastEdit: null,
              title: 'test123')
        ],
        id: 2,
        isChoiceBoard: null,
        order: null,
        state: null);
    // Creates a Weekmodel called week
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(
              activities: <ActivityModel>[activity], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Wednesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Thursday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Friday),
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);
    // Add the days and displaies them in the weekblock,
    // then copies that weekblock and verify that it is updated
    //Lastly it picks the fourth weekday and creates a listener for it.
    //When fired, it ensures that the length of its activities are = 1
    weekplanBloc.getWeek(week, user).whenComplete((){
      weekplanBloc.setDaysToDisplay(5, 0);
      for(int i = 0; i < 5; i++) {
        weekplanBloc.addWeekdayStream();
      }
      weekplanBloc.addMarkedActivity(activity);
      weekplanBloc.copyMarkedActivities(
          <bool>[false, false, false, false, true, false, false]);
      verify(api.week.updateDay(any, any, any, any));
      weekplanBloc.getWeekdayStream(4).listen((WeekdayModel weekday) {
        expect(
            weekday.activities.length, 1);
      });
    });
    done();
  }));

  test('Checks if marked activities are marked as cancel', async((DoneFn done) {
    //Creates a user
    final DisplayNameModel user = DisplayNameModel(
      role: Role.Citizen.toString(),
      displayName: 'User',
      id: '1'
    );
    //Creates activity
    final ActivityModel activity = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
              accessLevel: null,
              id: null,
              imageHash: null,
              imageUrl: null,
              lastEdit: null,
              title: 'test123')
        ],
        id: 2,
        isChoiceBoard: null,
        order: null,
        state: ActivityState.Normal);
    //Creates week
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(
              activities: <ActivityModel>[activity], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Wednesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Thursday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Friday),
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);

    // Add the days and displaies them in the weekblock, marks the activities
    // Then cancel the marked activities, and verifies that they are updated.
    // Creates a listener for monday, listening for weekday
    // When fired it checks if the first activities state is Canceled
    weekplanBloc.getWeek(week, user).whenComplete((){
      weekplanBloc.setDaysToDisplay(5, 0);
      for(int i = 0; i < 5; i++) {
        weekplanBloc.addWeekdayStream();
      }
      weekplanBloc.addMarkedActivity(activity);
      weekplanBloc.cancelMarkedActivities();
      verify(api.week.updateDay(any, any, any, any));
      weekplanBloc.getWeekdayStream(0).listen((WeekdayModel weekday) {
        expect(weekday.activities.first.state, ActivityState.Canceled);
      });
    });
    done();

  }));

  test('Checks if marked activities are marked as resumed',
  async((DoneFn done) {
    //Creates a user
    final DisplayNameModel user = DisplayNameModel(
        role: Role.Citizen.toString(),
        displayName: 'User',
        id: '1'
    );
    //Creates a activity
    final ActivityModel activity = ActivityModel(
        pictograms: <PictogramModel>[
          PictogramModel(
              accessLevel: null,
              id: null,
              imageHash: null,
              imageUrl: null,
              lastEdit: null,
              title: 'test123')
        ],
        id: 2,
        isChoiceBoard: null,
        order: null,
        state: ActivityState.Canceled);

    // Creates a week
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(
              activities: <ActivityModel>[activity], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Wednesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Thursday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Friday),
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);

    // Add the days and displaies them in the weekblock,
    // Marks the activities and then unmarks them.
    // Creates a listener for monday, listening for weekday
    // When fired it checks if the first activities state is Active
    weekplanBloc.getWeek(week, user).whenComplete((){
      weekplanBloc.setDaysToDisplay(5, 0);
      for(int i = 0; i < 5; i++) {
        weekplanBloc.addWeekdayStream();
      }
      weekplanBloc.addMarkedActivity(activity);
      weekplanBloc.undoMarkedActivities();
      weekplanBloc.getWeekdayStream(0).listen((WeekdayModel weekday) {
        expect(weekday.activities.first.state, ActivityState.Active);
      });
      verify(api.week.updateDay(any, any, any, any));
    });
    done();
  }));


  test('Checks if the edit mode toggles from true', async((DoneFn done) {
    /// Edit mode stream initial value is false.
    // Checks that the edit mode untoggles when used twice.
    weekplanBloc.toggleEditMode();

    weekplanBloc.editMode.skip(1).listen((bool toggle) {
      expect(toggle, false);
      done();
    });

    weekplanBloc.toggleEditMode();
  }));

  test('Adds an activity to a given weekplan', async((DoneFn done) {
    // Creates a user
    final DisplayNameModel user = DisplayNameModel(
      role: Role.Guardian.toString(),
      displayName: 'User',
      id: '1'
    );
    //Creates a Activity
    final ActivityModel activity = ActivityModel(
        order: null,
        isChoiceBoard: null,
        state: null,
        id: null,
        pictograms: null,
        title: '');
    // Add the days and displaies them in the weekblock
    // Addes the activities and verify that they are updated
    // Creates a listener for monday, when fired it compares the activities
    // length and if it is the same activity as the one added
    weekplanBloc.getWeek(week, user).whenComplete((){
      weekplanBloc.setDaysToDisplay(2, 0);
      for(int i = 0; i < 2; i++) {
        weekplanBloc.addWeekdayStream();
      }
      weekplanBloc.addActivity(activity, 0).whenComplete((){
        verify(api.week.updateDay(any, any, any, any));
        weekplanBloc.getWeekdayStream(0).listen((WeekdayModel weekday) {
          expect(weekday.activities.length, 1);
          expect(weekday.activities.first, activity);
        });
      });
    });
    done();

  }));

  test('Reorder activity from monday to tuesday', async((DoneFn done) {
    //Creates a week
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday)
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);
    // Creates two activities and addes the to different days
    final ActivityModel modelToMove = ActivityModel(
        id: 1, pictograms: null, order: 0, state: null, isChoiceBoard: false);
    week.days[0].activities.add(modelToMove);
    week.days[1].activities.add(ActivityModel(
        id: 2, pictograms: null, order: 0, state: null, isChoiceBoard: false));

    // Creates a weekplanBlock and displaies the days with activities on them.
    // Uses the reorderActivities method, switching monday to tuesday.
    // Creates a listener for tuesday which fires on weekdays
    // When fired, it checks that the activities where all reordered to tuesday
    weekplanBloc.getWeek(week, user).whenComplete(() {
      weekplanBloc.setDaysToDisplay(2, 0);
      for(int i = 0; i < 2; i++) {
        weekplanBloc.addWeekdayStream();
      }
      weekplanBloc.reorderActivities(
          modelToMove, Weekday.Monday, Weekday.Tuesday, 1).whenComplete(() {
         weekplanBloc.getWeekdayStream(1).listen((WeekdayModel weekday) {

           expect(weekday.activities[0].id, 2);
           expect(weekday.activities[1].id, modelToMove.id);
           expect(weekday.activities.length, 2);
         });
         weekplanBloc.getWeekdayStream(0).listen((WeekdayModel weekday) {
           expect(weekday.activities.length, 0);
         });
         verify(api.week.updateDay(any, any, any, any));
      });
    });
    done();
  }));

  test('Reorder activity from monday to monday', async((DoneFn done) {
    //Creates week
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday)
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);
    //Creates three activities on monday
    final ActivityModel modelToMove = ActivityModel(
        id: 1, pictograms: null, order: 0, state: null, isChoiceBoard: false);

    week.days[0].activities.add(modelToMove);

    week.days[0].activities.add(ActivityModel(
        id: 2, pictograms: null, order: 1, state: null, isChoiceBoard: false));

    week.days[0].activities.add(ActivityModel(
        id: 3, pictograms: null, order: 2, state: null, isChoiceBoard: false));

    // Creates a weekplanBlock and displaies monday and tuesday.
    // Uses the reorderActivities method, switching monday to monday.
    // Creates a listener for monday which fires on weekdays
    // When fired, it checks that the activities where all reordered to monday
    weekplanBloc.getWeek(week, user).whenComplete(() {
      weekplanBloc.setDaysToDisplay(2, 0);
      for (int i = 0; i < 2; i++) {
        weekplanBloc.addWeekdayStream();
      }
      weekplanBloc.reorderActivities(
          modelToMove, Weekday.Monday, Weekday.Monday, 2).whenComplete((){
         weekplanBloc.getWeekdayStream(0).listen((WeekdayModel weekday) {
           expect(weekday.activities[0].id, 2);
           expect(weekday.activities[0].order, 0);
           expect(weekday.activities[1].id, 3);
           expect(weekday.activities[1].order, 1);
           expect(weekday.activities[2].id, 1);
           expect(weekday.activities[2].order, 2);
         });
         verify(api.week.updateDay(any, any, any, any));
      });
    });
    done();
  }));

  test('Testing atLeastOneActivityMarked returns false when '
      'no activities are marked', async((DoneFn done) {

    // Listening to the atLeastOneActivityMarked stream to check it is empty
    weekplanBloc.atLeastOneActivityMarked.listen((bool result){
       expect(result, isFalse);
       done();
    });
  }));

  test('Testing atLeastOneActivityMarked returns true when an activity is '
      'marked', async((DoneFn done) {

    // Creating the activity that will be added
    final ActivityModel testActivity = ActivityModel(
        id: 1, pictograms: null, order: 0, state: null, isChoiceBoard: false);

    weekplanBloc.addMarkedActivity(testActivity);

    // Listening to the atLeastOneActivityMarked stream to check it is filled
    weekplanBloc.atLeastOneActivityMarked.listen((bool result){
      expect(result, isTrue);
      done();
    });
  }));

}
