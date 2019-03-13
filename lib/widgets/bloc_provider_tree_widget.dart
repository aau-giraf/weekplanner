import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/providers/bloc_provider.dart';

class BlocProviderTree extends StatefulWidget{
  final List<BlocProvider> blocProviders;

  final Widget child;


  BlocProviderTree({Key key, @required this.blocProviders,@required this.child})
  : super(key: key);

  static T of <T extends BlocBase>(BuildContext context){
    BlocProviderTree blocTree = context.ancestorWidgetOfExactType(BlocProviderTree);
    Iterable<BlocProvider> bloc = blocTree.blocProviders.where((el) {
        return el.typeOf() == T;
    });
    return bloc.first.bloc;
  }

  @override
  State<StatefulWidget> createState() {
    return _BlocProviderTreeState();
  }

}

class _BlocProviderTreeState extends State<BlocProviderTree>{
  @override
  void dispose(){
    widget.blocProviders.map((e) => e.bloc.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}