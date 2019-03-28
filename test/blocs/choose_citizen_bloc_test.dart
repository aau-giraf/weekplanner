import 'dart:convert';

import 'package:async_test/async_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/api/user_api.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable.just(GirafUserModel(id: "1", username: "test"));
  }

  @override
  Observable<List<UsernameModel>> getCitizens(String id) {
    List<UsernameModel> Output = List<UsernameModel>();
    Output.add(UsernameModel(name: "test1", role: "test1", id: id));

    return Observable.just(Output);
  }
}

void main() {
  ChooseCitizenBloc bloc;
  Api api;

  setUp(() {
    api = Api("any");
    api.user = MockUserApi();
    bloc = ChooseCitizenBloc(api);
  });

  test("Should be able to get UsernameModel from API", async((DoneFn done) {
    bloc.citizen.listen((List<UsernameModel> response) {
      if (response.length == 1) {
        var rsp = response[0];
        if (rsp.name == "test1" && rsp.role == "test1" && rsp.id == "1") {
          done();
        }
      }
    });
  }));

  test("Should dispose stream", async((DoneFn done) async {
    await bloc.citizen.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
