import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// Contains the functionality of the toolbar.
class ToolbarBloc extends BlocBase{

  /// The current visibility of the edit-button.
  Stream<bool> get editVisible => _editVisible.stream;

  final BehaviorSubject<bool> _editVisible =
      BehaviorSubject<bool>.seeded(false);


  /// Used to change the visiblity of the edit button.
  void setEditVisible(bool visibility){
    _editVisible.add(visibility);
  }

  @override
  void dispose(){
    _editVisible.close();
  }
}