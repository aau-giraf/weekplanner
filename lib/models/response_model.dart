import 'package:weekplanner/models/enums/error_key.dart';

class ResponseModel<T> {
  ResponseModel({this.data, this.success, this.errorKey, this.errorProperties});

  ResponseModel.fromJson(Map<String, dynamic> json, T data) {
    if (json == null) {
      throw const FormatException(
          '[ResponseModel]: Cannot instantiate from null');
    }

    data = data;
    success = json['success'];
    errorKey = ErrorKey.values.firstWhere(
            (f) => f.toString() == json['errorKey'],
        orElse: () => null);
    if (json['errorProperties'] is List) {
      errorProperties =
          (json['errorProperties']).toList();
    } else {
      // TODO(TobiasPalludan): Throw appropriate error.
    }

  }

  T data;
  bool success;
  ErrorKey errorKey;
  List<String> errorProperties;
}
