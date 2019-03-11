import 'package:test_api/test_api.dart';
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

  test("Should call database status endpoint", () {
    statusApi
        .databaseStatus()
        .listen(expectAsync1((bool test) {
      expect(test, true);
    }));

    httpMock
        .expectOne(url: "/database", method: Method.get)
        .flush({
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError"
    });
  });

  test("Should call version-info endpoint", () {
    String version = "v1";

    statusApi
        .versionInfo()
        .listen(expectAsync1((String test) {
      expect(test, version);
    }));

    httpMock
        .expectOne(url: "/database", method: Method.get)
        .flush({
      "data": version,
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError"
    });
  });

  tearDown(() {
    httpMock.verify();
  });
}
