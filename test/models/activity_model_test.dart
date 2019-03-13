import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/pictogram_model.dart';

void main() {
  test("Throws on JSON is null", () {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => ActivityModel.fromJson(json), throwsFormatException);
  });

  test("Can create from JSON map", () {
    Map<String, dynamic> userJson = {
      "id": 39,
      "lastEdit": "2018-05-17T10:58:41.241292",
      "title": "cat4",
      "accessLevel": 1,
      "imageUrl": "/v1/pictogram/39/image/raw",
      "imageHash": "RijAegW2HQR9zaAn8CIUHw=="
    };

    Map<String, dynamic> json = {
      "pictogram": userJson,
      "order": 0,
      "state": 1,
      "id": 1044,
      "isChoiceBoard": false
    };

    ActivityModel model = ActivityModel.fromJson(json);
    expect(model.id, json["id"]);
    expect(model.order, json["order"]);
    expect(model.isChoiceBoard, json["isChoiceBoard"]);
    expect(model.state, ActivityState.Normal);
    expect(
        model.pictogram.toJson(), PictogramModel.fromJson(userJson).toJson());
  });

  test("Can convert to JSON map", () {
    Map<String, dynamic> userJson = {
      "id": 39,
      "lastEdit": "2018-05-17T10:58:41.241292",
      "title": "cat4",
      "accessLevel": 1,
      "imageUrl": "/v1/pictogram/39/image/raw",
      "imageHash": "RijAegW2HQR9zaAn8CIUHw=="
    };

    Map<String, dynamic> json = {
      "pictogram": userJson,
      "order": 0,
      "state": 1,
      "id": 1044,
      "isChoiceBoard": false
    };

    ActivityModel model = ActivityModel.fromJson(json);

    expect(model.toJson(), json);
  });
}
