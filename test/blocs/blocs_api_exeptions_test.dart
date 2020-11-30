import 'package:async_test/async_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/blocs_api_exeptions.dart';
import 'package:flutter_test/flutter_test.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('test'),
        ),
        body: const Center(
          child: Text('test'),
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {

  const String comparestring1 = 'opps noget gik galt';

  setUp((){
    runApp(MyApp());

  });


  test('A string is printed',
      async((DoneFn done) {
        final BlocsApiExeptions testblocsApiExeptions =
        BlocsApiExeptions('A string is printed');
        print(testblocsApiExeptions.toString());
        print(comparestring1);
        assert(testblocsApiExeptions.toString() == comparestring1);
        done();
    })
  );
}