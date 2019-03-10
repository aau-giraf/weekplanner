import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/screens/application_screen.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import 'package:weekplanner/providers/bloc_provider.dart';

class RouteBuilder {
  static WidgetBuilder build (Widget screen, List<BlocProvider> providers){
    return (BuildContext context) => BlocProviderTree(
      blocProviders: [
        BlocProvider<ApplicationBloc>(bloc: Globals.appBloc),
        BlocProvider<AuthBloc>(bloc: Globals.authBloc),
      ],
      child: ApplicationScreen(BlocProviderTree(
          blocProviders:providers,
          child: screen
      )),
    );
  }
}