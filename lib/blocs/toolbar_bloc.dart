import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

class ToolbarBloc extends BlocBase{

  Stream<bool> get editVisible => _editVisible.stream;

  BehaviorSubject<bool> _editVisible = new BehaviorSubject();


  void setEditVisible(bool visibility){
    _editVisible.add(visibility);
  }

  @override
  void dispose(){
    _editVisible.close();
  }
}