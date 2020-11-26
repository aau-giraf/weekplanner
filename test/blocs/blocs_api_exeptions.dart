import 'package:weekplanner/blocs/blocs_api_exeptions.dart';

void main() {

  const String comparestring1 = 'test';
  String comparestring2;

  final BlocsApiExeptions testblocsApiExeptions = BlocsApiExeptions('test');

  comparestring2 = testblocsApiExeptions.toString();

  assert(comparestring1 == comparestring2);

}