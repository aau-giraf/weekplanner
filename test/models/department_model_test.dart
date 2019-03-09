import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/department_model.dart';

void main() {
  test("Throws on JSON is null", () {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => DepartmentModel.fromJson(json), throwsFormatException);
  });

  test("Can create from JSON map", () {
    Map<String, dynamic> userJson = {
      "userName": "testUsername",
      "userRole": "testRole",
      "userId": "testID",
    };

    Map<String, dynamic> json = {
      "id": 1,
      "name": "testName",
      "members": [userJson],
      "resources": [1, 2, 3],
    };

    DepartmentModel model = DepartmentModel.fromJson(json);
    expect(model.id, json["id"]);
    expect(model.name, json["name"]);
    expect(model.members.map((val) => val.toJson()), [userJson]);
    expect(model.resources, json["resources"]);
  });

  test("Can convert to JSON map", () {
    Map<String, dynamic> userJson = {
      "userName": "testUsername",
      "userRole": "testRole",
      "userId": "testID",
    };

    Map<String, dynamic> json = {
      "id": 1,
      "name": "testName",
      "members": [userJson],
      "resources": [1, 2, 3],
    };

    DepartmentModel model = DepartmentModel.fromJson(json);

    expect(model.toJson(), json);
  });
}