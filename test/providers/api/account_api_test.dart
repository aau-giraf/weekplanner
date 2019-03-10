import 'package:test_api/test_api.dart';
import 'package:weekplanner/providers/api/account_api.dart';
import 'package:weekplanner/providers/http/http_mock.dart';
import 'package:weekplanner/providers/peristence/persistence_mock.dart';

void main() {
  AccountApi accountApi;
  HttpMock httpMock;
  PersistenceMock persistenceMock;

  setUp(() {
    httpMock = HttpMock();
    persistenceMock = PersistenceMock();
    accountApi = AccountApi(httpMock, persistenceMock);
  });

  test("Should call login endpoint", () {
    accountApi
        .login("username", "password")
        .listen(expectAsync1((bool success) {
      expect(success, isTrue);
    }));

    httpMock.expectOne(url: "/Account/login", method: Method.post).flush({
      "data": "TestToken",
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should request reset password token", () {
    int id = 1234;
    String token = "TestToken";

    accountApi.resetPasswordToken(id).listen(expectAsync1((String test) {
      expect(test, token);
    }));

    httpMock
        .expectOne(
            url: "/User/$id/Account/password-reset-token", method: Method.get)
        .flush({
      "data": token,
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  tearDown(() {
    httpMock.verify();
  });
}
