import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc to keep track of which checkboxes are marked
class CopyActivitiesBloc extends BlocBase {
  /// Constructor that initializes bloc
  CopyActivitiesBloc();

  /// Stream of marked checkboxes
  Stream<List<bool>> get checkboxValues => _checkboxValues.stream;

  final rx_dart.BehaviorSubject<List<bool>> _checkboxValues =
      rx_dart.BehaviorSubject<List<bool>>.seeded(List<bool>.filled(7, false));

  /// Toggles the state of a checkbox field
  void toggleCheckboxState(int index) {
    final List<bool> tempCheckboxValues = _checkboxValues.value;
    tempCheckboxValues[index] = !tempCheckboxValues[index];
    _checkboxValues.add(tempCheckboxValues);
  }

  @override
  void dispose() {
    _checkboxValues.close();
  }
}
