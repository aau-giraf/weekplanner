import 'package:quiver/time.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart'; //curently just used to alert
import 'package:tuple/tuple.dart';

///The UserInfoBloc is used to switch between Guardian and citizen mode
class UserInfoBloc extends BlocBase{

  /// Takes a [Clock] which is used to determine the current time. Mostly used
  /// to be able to Mock the time during testing.
  UserInfoBloc([Clock clock]) {
    if (clock != null){
      this.clock = clock;
    }
    else{
      this.clock = const Clock();
    }
  }

  /// Mainly used for testing, in order to simulate that it is different days.
  Clock clock;

  /// Indicates which mode we are in.
  bool isGuardian = true;

  /// Stream used to signal which mode we are in.
  Stream<String> get changeUserMode => _changeUserMode.stream;
  final BehaviorSubject<String> _changeUserMode =
      BehaviorSubject<String>.seeded('Guardian');

  /// Stream to signal both which day and mode we are in.
  /// Used for signaling which days to show and not to show.
  Stream<Tuple2<String, int>> get dayOfWeekAndUsermode =>
          _dayOfWeekAndUsermode.stream;
  final BehaviorSubject<Tuple2<String,int>> _dayOfWeekAndUsermode =
      BehaviorSubject<Tuple2<String,int>>.
      seeded(const Tuple2<String,int>('Guardian',0));

  /// Used for handling the logic of which mode to change to.
  void setUserMode(String isGuardian){
    if (isGuardian == 'Guardian'){
        _changeUserMode.add('Guardian');
        this.isGuardian = true;
        _dayOfWeekAndUsermode.add(Tuple2<String,int>('Guardian', getDate()));
      }
    else{
        _changeUserMode.add('Citizen');
        this.isGuardian = false;
        _dayOfWeekAndUsermode.add(Tuple2<String,int>('Citizen', getDate()));
    }
  }

  /// Gets the current day as an integer
  int getDate(){
    return clock.now().weekday;
  }


  @override
  void dispose() {
    _changeUserMode.close();
    _dayOfWeekAndUsermode.close();
  }




}