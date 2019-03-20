import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvoironmentBloc extends BlocBase {
  T getVar<T>(String variableName) {
    var val = DotEnv().env[variableName];
    switch (T) {
      case bool:
        switch (val) {
          case "1":
          case "true":
            return true as T;
          case "0":
          case "false":
            return false as T;
        }
        throw FormatException("Read variable is not of type bool");
      case String:
        return val as T;
      case int:
        return int.tryParse(val) as T ?? null;
      case double:
        return double.tryParse(val) as T ?? null;
    }
    return null;
  }

  @override
  void dispose() {}
}
