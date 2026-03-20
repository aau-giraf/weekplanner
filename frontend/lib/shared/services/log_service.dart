import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

/// Configures the root logger to print to console and persist to a log file.
///
/// Log file is written to the app's documents directory as `weekplanner.log`.
/// On web (where dart:io is unavailable) only console output is used.
Future<void> setupLogging() async {
  Logger.root.level = Level.ALL;

  IOSink? fileSink;
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/weekplanner.log');
    fileSink = file.openWrite(mode: FileMode.append);
  }

  Logger.root.onRecord.listen((record) {
    final line = StringBuffer()
      ..write('${record.level.name}: ${record.time}: ')
      ..write('${record.loggerName}: ${record.message}');
    if (record.error != null) {
      line.write('\n  Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      line.write('\n  ${record.stackTrace}');
    }

    final message = line.toString();

    // Always print to debug console
    debugPrint(message);

    // Append to log file on native platforms
    fileSink?.writeln(message);
  });
}
