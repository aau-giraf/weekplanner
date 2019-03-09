import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/week_template_name_model.dart';

void main(){
  Map<String, dynamic> response = {
    "name": "SkabelonUge",
    "templateId": 1
  };

  test("Should be able to instantiate from JSON", (){
    WeekTemplateNameModel wtn = WeekTemplateNameModel.fromJson(response);

    expect(wtn.name, response['name']);
    expect(wtn.templateId, response['templateId']);
  });

  test("Should throw exception if JSON is null", (){
    expect(() => WeekTemplateNameModel.fromJson(null), throwsFormatException);
  });

  test("Should be able to serialize to JSON", (){
    WeekTemplateNameModel wtn = WeekTemplateNameModel.fromJson(response);

    expect(wtn.toJson(), response);
  });
}