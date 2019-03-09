import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/models/department_model.dart';

void main() {
  testWidgets("Throws on JSON is null", (WidgetTester tester) {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => DepartmentModel.fromJson(json), throwsFormatException);
  });

  testWidgets("Can create from JSON map", (WidgetTester tester) {
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

  testWidgets("Can convert to JSON map", (WidgetTester tester) {
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