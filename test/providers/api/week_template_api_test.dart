import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/enums/access_level_enum.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_template_model.dart';
import 'package:weekplanner/models/week_template_name_model.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/weekday_model.dart';
import 'package:weekplanner/providers/api/week_template_api.dart';
import 'package:weekplanner/providers/http/http_mock.dart';

void main() {
  WeekTemplateApi weekTemplateApi;
  HttpMock httpMock;

  WeekTemplateModel weekTemplateSample = WeekTemplateModel(
      name: "Week 1",
      id: 1234,
      days: [WeekdayModel(day: Weekday.Monday, activities: [])],
      departmentKey: 5,
      thumbnail: PictogramModel(
          id: 1,
          title: "Picto",
          lastEdit: DateTime.now(),
          imageUrl: "http://",
          imageHash: "#",
          accessLevel: AccessLevel.PUBLIC));

  setUp(() {
    httpMock = HttpMock();
    weekTemplateApi = WeekTemplateApi(httpMock);
  });

  test("Should get names", () {
    List<WeekTemplateNameModel> names = [
      WeekTemplateNameModel(id: 1, name: "Week 1"),
      WeekTemplateNameModel(id: 2, name: "Week 2"),
    ];

    weekTemplateApi
        .getNames()
        .listen(expectAsync1((List<WeekTemplateNameModel> templateNames) {
      expect(templateNames.length, 2);
      expect(templateNames[0].toJson(), names[0].toJson());
      expect(templateNames[1].toJson(), names[1].toJson());
    }));

    httpMock.expectOne(url: "/", method: Method.get).flush({
      "data": names.map((name) => name.toJson()).toList(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should be able to create week template", () {
    weekTemplateApi
        .create(weekTemplateSample)
        .listen(expectAsync1((WeekTemplateModel template) {
      expect(template.toJson(), weekTemplateSample.toJson());
    }));

    httpMock.expectOne(url: "/", method: Method.post).flush({
      "data": weekTemplateSample.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should be able to get week template", () {
    weekTemplateApi
        .get(weekTemplateSample.id)
        .listen(expectAsync1((WeekTemplateModel template) {
      expect(template.toJson(), weekTemplateSample.toJson());
    }));

    httpMock
        .expectOne(url: "/${weekTemplateSample.id}", method: Method.get)
        .flush({
      "data": weekTemplateSample.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should be able to update week template", () {
    weekTemplateApi
        .update(weekTemplateSample)
        .listen(expectAsync1((WeekTemplateModel template) {
      expect(template.toJson(), weekTemplateSample.toJson());
    }));

    httpMock
        .expectOne(url: "/${weekTemplateSample.id}", method: Method.put)
        .flush({
      "data": weekTemplateSample.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should be able to delete week template", () {
    weekTemplateApi
        .delete(weekTemplateSample.id)
        .listen(expectAsync1((bool success) {
      expect(success, isTrue);
    }));

    httpMock
        .expectOne(url: "/${weekTemplateSample.id}", method: Method.delete)
        .flush({
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  tearDown(() {
    httpMock.verify();
  });
}
