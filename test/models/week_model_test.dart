import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/week_base_model.dart';
import 'package:weekplanner/models/week_model.dart';

void main(){
  Map<String, dynamic> response1 = {
    "name": "Jacobs Plan II",
    "weekYear": 2019,
    "weekNumber": 10
  };

  Map<String, dynamic> response2 = {
    "weekYear": 2019,
    "weekNumber": 10,
    "thumbnail": {
      "id": 2,
      "lastEdit": "2014-05-14T06:20:18.000",
      "title": "alfabet",
      "accessLevel": 1,
      "imageUrl": "/v1/pictogram/2/image/raw",
      "imageHash": "iLRm28Hp/amc2847ALSk0g=="
    },
    "name": "Jacobs Plan II",
    "days": [
      {
        "day": 1,
        "activities": []
      },
      {
        "day": 2,
        "activities": [
          {
            "pictogram": {
              "id": 1246,
              "lastEdit": "2014-05-14T06:29:07.000",
              "title": "pade",
              "accessLevel": 1,
              "imageUrl": "/v1/pictogram/1246/image/raw",
              "imageHash": "tHJWezktGh8FUxQH3Bp/0Q=="
            },
            "order": 0,
            "state": 1,
            "id": 1238,
            "isChoiceBoard": false
          }
        ]
      },
      {
        "day": 3,
        "activities": [
          {
            "pictogram": {
              "id": 5974,
              "lastEdit": "2014-05-14T07:03:37.000",
              "title": "tegning",
              "accessLevel": 1,
              "imageUrl": "/v1/pictogram/5974/image/raw",
              "imageHash": "bWTcndsk24PK8ov19Q+J/A=="
            },
            "order": 0,
            "state": 4,
            "id": 1239,
            "isChoiceBoard": false
          },
          {
            "pictogram": {
              "id": 1199,
              "lastEdit": "2014-05-14T06:28:46.000",
              "title": "målmand",
              "accessLevel": 1,
              "imageUrl": "/v1/pictogram/1199/image/raw",
              "imageHash": "OH9cCXWS4lj/n/F2asnwKA=="
            },
            "order": 1,
            "state": 1,
            "id": 1240,
            "isChoiceBoard": false
          },
          {
            "pictogram": {
              "id": 2512,
              "lastEdit": "2014-05-14T06:38:19.000",
              "title": "buskort",
              "accessLevel": 1,
              "imageUrl": "/v1/pictogram/2512/image/raw",
              "imageHash": "/YFdskOccdy3wRFEf4rmhA=="
            },
            "order": 2,
            "state": 1,
            "id": 1241,
            "isChoiceBoard": false
          }
        ]
      },
      {
        "day": 4,
        "activities": []
      },
      {
        "day": 5,
        "activities": []
      },
      {
        "day": 6,
        "activities": []
      },
      {
        "day": 7,
        "activities": []
      }
    ]
  };

  test('Should be able to instantiate from JSON', (){
    WeekModel wm1 = WeekModel.fromJson(response1);
    WeekModel wm2 = WeekModel.fromJson(response2);

    expect(wm1.weekYear, response1['weekYear']);
    expect(wm1.weekNumber, response1['weekNumber']);

    expect(wm2.weekYear, response2['weekYear']);
    expect(wm2.weekNumber, response2['weekNumber']);

    weekBaseTest(wm1, response1);
    weekBaseTest(wm2, response2);
  });

  test("Should throw exception when JSOn is null", (){
    expect(() => WeekModel.fromJson(null), throwsFormatException);
  });

  test("Should be able to serialize to JSON", (){
    WeekModel wm1 = WeekModel.fromJson(response1);
    WeekModel wm2 = WeekModel.fromJson(response2);

    expect(wm1.toJson(), response1);
    expect(wm2.toJson(), response2);
  });

}

void weekBaseTest(WeekBaseModel wb, Map<String, dynamic> response){

  expect(wb.name, response['name']);

  if(wb.thumbnail != null){
    expect(wb.thumbnail.toJson(), response['thumbnail']);
  }else{
    expect(wb.thumbnail, isNull);
  }

  if(wb.days != null){
    expect(wb.days.length, 7);
    expect(wb.days[0].toJson(), response["days"][0]);
    expect(wb.days[1].toJson(), response["days"][1]);
    expect(wb.days[2].toJson(), response["days"][2]);
    expect(wb.days[3].toJson(), response["days"][3]);
    expect(wb.days[4].toJson(), response["days"][4]);
    expect(wb.days[5].toJson(), response["days"][5]);
    expect(wb.days[6].toJson(), response["days"][6]);
  }else{
    expect(wb.days, isNull);
  }

}