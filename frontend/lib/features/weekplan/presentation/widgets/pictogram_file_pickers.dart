import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:weekplanner/shared/models/file_data.dart';

/// Opens the platform file picker for an image file.
Future<FileData?> pickImageFileFromDevice() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );
  return _toFileData(result);
}

/// Opens the platform file picker for a sound file.
Future<FileData?> pickSoundFileFromDevice() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp3', 'wav', 'ogg'],
    withData: true,
  );
  return _toFileData(result);
}

FileData? _toFileData(FilePickerResult? result) {
  final file = result?.files.single;
  if (file == null) return null;
  return (
    name: file.name,
    size: file.size,
    bytes: file.bytes,
    // PlatformFile.path throws on web — skip it there.
    path: kIsWeb ? null : file.path,
  );
}
