import 'dart:io';
import 'dart:typed_data';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:image/image.dart';

/// Bloc for retriving an image from a phones gallery,
/// and send it to the pictogram database
class UploadFromGalleryBloc extends BlocBase {
  ///
  UploadFromGalleryBloc(this._api);
  final Api _api;
  String _pictogramName;

  /// Publishes the image file, while it is nut null
  Observable<File> get file => _file.stream.where((File f) => f != null);

  /// Publishes true while waiting for the pictogram to be uploaded
  Observable<bool> get isUploading => _isUploading.stream;

  /// Publishes the accessLevel for the pictogram
  Observable<String> get accessLevel => _accessString.stream;

  /// Publishes if the input fields are filled
  Observable<bool> get isInputValid => _isInputValid.stream;
  final BehaviorSubject<bool> _isInputValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<File> _file = BehaviorSubject<File>();
  final BehaviorSubject<String> _accessString =
      BehaviorSubject<String>.seeded('Public');
  final BehaviorSubject<bool> _isUploading =
      BehaviorSubject<bool>.seeded(false);

  AccessLevel _accessLevel = AccessLevel.PUBLIC;

  /// pushes an imagePicker screen, then sets the pictogram image,
  /// to the selected image from the gallery
  void chooseImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((File f) {
      if (f != null) {
        _publishImage(f);
        _checkInput();
      }
    });
  }

  /// Checks if the input fieds are filled out
  void _checkInput() {
    if (_file.value != null && _pictogramName != '') {
      _isInputValid.add(true);
    } else {
      _isInputValid.add(false);
    }
  }

  /// set accessLevel for the pictogram
  void setAccessLevel(String access) {
    _accessString.add(access);
    switch (access) {
      case 'Protected':
        _accessLevel = AccessLevel.PROTECTED;
        break;
      case 'Private':
        _accessLevel = AccessLevel.PRIVATE;
        break;
      default:
        _accessLevel = AccessLevel.PUBLIC;
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
        512)); // 512 bytes chosen as a reasonable input size.
  }

  /// Creates a [PictogramModel]
  /// from the seleted [Image], [AccessLevel], and title
  void createPictogram() {
    _isUploading.add(true);
    _api.pictogram
        .create(PictogramModel(
      accessLevel: _accessLevel,
      title: _pictogramName,
    ))
        .flatMap((PictogramModel pictogram) {
      return _api.pictogram.updateImage(pictogram.id, _encodePng(_file.value));
    }).listen((PictogramModel pictogram) {
      // TODO(scarress):  add proper succeses handling, https://github.com/aau-giraf/weekplanner/issues/245
      _isUploading.add(false);
    }, onError: (Object error) {
      // TODO(scarress):  add error handling, https://github.com/aau-giraf/weekplanner/issues/245
      _isUploading.add(false);
    });
  }

  @override
  void dispose() {
    _file.close();
    _accessString.close();
    _isInputValid.close();
    _isUploading.close();
  }
}
