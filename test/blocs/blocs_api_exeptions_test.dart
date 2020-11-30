import 'package:async_test/async_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/blocs_api_exeptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/bootstrap.dart';

void main() {

  const String comparestring1 = 'opps noget gik galt';

  Bootstrap.register();
  WidgetsFlutterBinding.ensureInitialized();

  setUp((){

  });


  test('A string is printed',
      async((DoneFn done) {
        final BlocsApiExeptions testblocsApiExeptions =
        BlocsApiExeptions('A string is printed');
        expect(testblocsApiExeptions.toString(), comparestring1);
        done();
      })
  );
}