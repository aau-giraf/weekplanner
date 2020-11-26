import 'package:weekplanner/blocs/blocs_api_exeptions.dart';

void main() {

  String comparestring1 = 'test';
  String comparestring2;

  BlocsApiExeptions testblocs_api_exeptions = BlocsApiExeptions('test');

  comparestring2 = testblocs_api_exeptions.toString();

  assert(comparestring1 == comparestring2);

}