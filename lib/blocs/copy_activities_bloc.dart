import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc to keep track of which checkboxes are marked
class CopyActivitiesBloc extends BlocBase {
  /// Constructor that initializes bloc
  CopyActivitiesBloc();

  final BehaviorSubject<List<bool>> _checkboxValues =
      BehaviorSubject<List<bool>>.seeded(List<bool>.filled(7, false));

  /// Stream of marked checkboxes
  Stream<List<bool>> get checkboxValues => _checkboxValues.stream;

  /// Toggles the state of a checkbox field
  void toggleCheckboxState(int index) {
    final List<bool> tempCheckboxValues = _checkboxValues.value;
    tempCheckboxValues[index] = !tempCheckboxValues[index];
    _checkboxValues.add(tempCheckboxValues);
  }

  /// Returns the list of checkbox values
  List<bool> getCheckboxValues() {
    return _checkboxValues.value;
  }

  @override
  void dispose() {
    _checkboxValues.close();
  }
}
