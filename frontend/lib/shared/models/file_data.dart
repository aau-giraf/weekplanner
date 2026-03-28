import 'dart:typed_data';

/// Domain-safe file representation, decoupled from any file-picker package.
///
/// Presentation-layer code maps platform-specific file types (e.g.
/// `PlatformFile` from `file_picker`) to this record before passing
/// data into cubits or repositories.
typedef FileData = ({String name, int size, Uint8List? bytes, String? path});
