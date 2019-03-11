import 'package:weekplanner/models/error_key.dart';

class ResponseModel<T> {
  T data;
  bool success;
  ErrorKey errorKey;
  List<String> errorProperties;

  ResponseModel({this.data, this.success, this.errorKey, this.errorProperties});

  ResponseModel.fromJson(Map<String, dynamic> json, T data) {
    if (json == null) {
      throw new FormatException(
          "[ResponseModel]: Cannot instanciate from null");
    }

    this.data = data;
    success = json["success"];
    errorKey = ErrorKey.values.firstWhere(
        (f) => f.toString() == json["errorKey"],
        orElse: () => null);
    errorProperties =
        (json["errorProperties"] as List).map((val) => val as String).toList();
  }
}
