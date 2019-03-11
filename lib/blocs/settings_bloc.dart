import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/giraf_theme_enum.dart';

class SettingsBloc extends BlocBase{

  Stream<GirafTheme> get theme => _theme.stream;

  Stream<List<GirafTheme>> get themeList => _themeList.asBroadcastStream();

  BehaviorSubject<List<GirafTheme>> _themeList = BehaviorSubject();

  BehaviorSubject<GirafTheme> _theme = new BehaviorSubject();

  SettingsBloc(){
    _themeList.add(GirafTheme.values);
  }

  void setTheme(GirafTheme theme) {
    _theme.add(theme);
  }

  @override
  void dispose(){

  }

}