import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Prevent google_fonts from hitting the network in tests.
  // Without this, offline CI environments can timeout or flake.
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
