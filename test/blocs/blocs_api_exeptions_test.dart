import 'package:async_test/async_test.dart';
import 'package:weekplanner/blocs/blocs_api_exeptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  const String comparestring1 = 'test';
  String comparestring2;

  test("A string is printed",
      async((DoneFn done) {
        final BlocsApiExeptions testblocsApiExeptions =
        BlocsApiExeptions('test');
        comparestring2 = testblocsApiExeptions.toString();
        assert(comparestring1 == comparestring2);
    })
  );
}