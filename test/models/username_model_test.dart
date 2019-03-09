import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/username_model.dart';

void main() {
  test("Throws on JSON is null", () {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => UsernameModel.fromJson(json), throwsFormatException);
  });

  test("Can create from JSON map", () {
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

  test("Can convert to JSON map", () {
    Map<String, dynamic> json = {
      "userName": "testUsername",
      "userRole": "testRole",
      "userId": "testID",
    };

    UsernameModel model = UsernameModel.fromJson(json);

    expect(model.toJson(), json);
  });

  test("Has username property", () {
    String username = "testUsername";
    UsernameModel model =
        UsernameModel(name: username, role: null, id: null);
    expect(model.name, username);
  });

  test("Has role property", () {
    String role = "testRole";
    UsernameModel model = UsernameModel(name: null, role: role, id: null);
    expect(model.role, role);
  });

  test("Has id property", () {
    String id = "testId";
    UsernameModel model = UsernameModel(name: null, role: null, id: id);
    expect(model.id, id);
  });
}
