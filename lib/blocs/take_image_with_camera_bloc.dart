import 'dart:io';
import 'dart:typed_data';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:image/image.dart';

/// Bloc for retriving an image from a phones gallery,
/// and send it to the pictogram database
class TakePictureWithCameraBloc extends BlocBase {
  ///
  TakePictureWithCameraBloc(this._api);
  final Api _api;
  String _pictogramName;

  /// Publishes the image file, while it is nut null
  Stream<File> get file => _file.stream.where((File f) => f != null);

  /// Publishes true while waiting for the pictogram to be uploaded
  Stream<bool> get isUploading => _isUploading.stream;

  /// Publishes the accessLevel for the pictogram
  Stream<String> get accessLevel => _accessString.stream;

  /// Publishes if the input fields are filled
  Stream<bool> get isInputValid => _isInputValid.stream;

  final rx_dart.BehaviorSubject<bool> _isInputValid =
  rx_dart.BehaviorSubject<bool>.seeded(false);
  final rx_dart.BehaviorSubject<File> _file = rx_dart.BehaviorSubject<File>();
  final rx_dart.BehaviorSubject<String> _accessString =
  rx_dart.BehaviorSubject<String>.seeded('Institution');
  final rx_dart.BehaviorSubject<bool> _isUploading =
  rx_dart.BehaviorSubject<bool>.seeded(false);

  /// pushes an imagePicker screen, then sets the pictogram image,
  /// to the selected image from the gallery
  void takePictureWithCamera() {
    ImagePicker.pickImage(source: ImageSource.camera).then<dynamic>((File f) {
      if (f != null) {
        _publishImage(f);
        _checkInput();
      }
    });
  }

  /// Checks if the input fields are filled out
  void _checkInput() {
    if (_file.value != null && _pictogramName != null &&
        _pictogramName.isNotEmpty) {
      _isInputValid.add(true);
    } else {
      _isInputValid.add(false);
    }
  }

  /// sets the pictogram name
  void setPictogramName(String newName) {
    _pictogramName = newName;
    _checkInput();
  }

  void _publishImage(File file) {
    _file.add(file);
  }

  Uint8List _encodePng(File file) {
    return encodePng(copyResize(decodeImage(file.readAsBytesSync()),
        width: 512)); // 512 bytes chosen as a reasonable input size.
  }

  /// Creates a [PictogramModel]
  /// from the seleted [Image], [AccessLevel], and title
  Stream<PictogramModel> createPictogram() {
    _isUploading.add(true);
    return _api.pictogram
        .create(PictogramModel(
      accessLevel: AccessLevel.PRIVATE,
      title: _pictogramName,
    ))
        .flatMap((PictogramModel pictogram) {
      return _api.pictogram.updateImage(pictogram.id, _encodePng(_file.value));
    }).map((PictogramModel pictogram) {
      _isUploading.add(false);
      return pictogram;
    }).doOnError((Object error, StackTrace trace) {
      _isUploading.add(false);
    }).take(1);
  }

  @override
  void dispose() {
    _file.close();
    _accessString.close();
    _isInputValid.close();
    _isUploading.close();
  }
}
