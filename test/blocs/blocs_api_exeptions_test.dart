import 'package:async_test/async_test.dart';
import 'package:weekplanner/blocs/blocs_api_exeptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  const String comparestring1 = 'test';

  test('A string is printed',
      async((DoneFn done) {
        final BlocsApiExeptions testblocsApiExeptions =
        BlocsApiExeptions('test');
        expect(testblocsApiExeptions.toString(), comparestring1);
    })
  );
}