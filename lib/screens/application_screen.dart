import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';


/// In order to encompass authentication and other potential middleware this
/// class was chosen as the solution. This class is not to be used anywhere but
/// in the [RouterBuilder] build method. It servers to wrap the given widget
/// with a functionality of the middleware (i.e. it can redirect to login page
/// in case the user is not logged in anymore).
class ApplicationScreen extends StatelessWidget{
  final Widget widget;

  ApplicationScreen(this.widget);

  @override
  Widget build(BuildContext context) {
    ApplicationBloc app = BlocProviderTree.of<ApplicationBloc>(context);
    app.checkLoggedIn(context);

    return StreamBuilder<bool>(
      stream: app.ready,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // TODO: Create loading widget.
        return snapshot.data ? widget : Text("Loading...");
      },
    );
  }

}