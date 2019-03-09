import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/models/username_model.dart';

void main() {
  testWidgets("Throws on JSON is null", (WidgetTester tester) {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => UsernameModel.fromJson(json), throwsFormatException);
  });

  testWidgets("Can create from JSON map", (WidgetTester tester) {
    Map<String, dynamic> json = {
      "userName": "testUsername",
      "userRole": "testRole",
      "userId": "testID",
    };

    UsernameModel model = UsernameModel.fromJson(json);
    expect(model.id, json["userId"]);
    expect(model.role, json["userRole"]);
    expect(model.name, json["userName"]);
  });

  testWidgets("Can convert to JSON map", (WidgetTester tester) {
    Map<String, dynamic> json = {
      "userName": "testUsername",
      "userRole": "testRole",
      "userId": "testID",
    };

    UsernameModel model = UsernameModel.fromJson(json);

    expect(model.toJson(), json);
  });

  testWidgets("Has username property", (WidgetTester tester) {
    String username = "testUsername";
    UsernameModel model =
        UsernameModel(name: username, role: null, id: null);
    expect(model.name, username);
  });

  testWidgets("Has role property", (WidgetTester tester) {
    String role = "testRole";
    UsernameModel model = UsernameModel(name: null, role: role, id: null);
    expect(model.role, role);
  });

  testWidgets("Has id property", (WidgetTester tester) {
    String id = "testId";
    UsernameModel model = UsernameModel(name: null, role: null, id: id);
    expect(model.id, id);
  });
}
