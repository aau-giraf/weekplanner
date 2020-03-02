import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// All about settings.
///
/// Set settings, and listen for changes in them.
class SettingsBloc extends BlocBase {
  /// Default constructor
  SettingsBloc() {
    _themeList.add(GirafTheme.values);
  }

  /// Currently selected theme
  Stream<GirafTheme> get theme => _theme.stream;

  /// List of available themes
  Stream<List<GirafTheme>> get themeList => _themeList.stream;

  final BehaviorSubject<List<GirafTheme>> _themeList =
      BehaviorSubject<List<GirafTheme>>.seeded(<GirafTheme>[]);

  final BehaviorSubject<GirafTheme> _theme =
      BehaviorSubject<GirafTheme>.seeded(null);

  /// Set the theme to be used
  void setTheme(GirafTheme theme) {
    _theme.add(theme);
  }

  @override
  void dispose() {}
}
