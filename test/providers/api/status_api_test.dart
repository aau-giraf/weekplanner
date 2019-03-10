import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/role_enum.dart';
import 'package:weekplanner/providers/api/status_api.dart';
import 'package:weekplanner/providers/http/http_mock.dart';
import 'package:weekplanner/providers/peristence/persistence_mock.dart';

void main() {
  StatusApi statusApi;
  HttpMock httpMock;
  PersistenceMock persistenceMock;

  setUp(() {
    httpMock = HttpMock();
    persistenceMock = PersistenceMock();
    statusApi = StatusApi(httpMock, persistenceMock);
  });

  test("Should call status endpoint", () {
    statusApi
        .status()
        .listen(expectAsync1((bool test) {
          expect(test, true);
    }));

    httpMock
    .expectOne(url: "/", method: Method.get)
    .flush({
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError"
    });

  });
}
