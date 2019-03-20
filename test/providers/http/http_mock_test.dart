import 'package:test_api/test_api.dart';
import 'package:weekplanner/providers/http/http.dart';
import 'package:weekplanner/providers/http/http_mock.dart';

void main() {
  HttpMock httpMock;

  setUp(() {
    httpMock = HttpMock();
  });

  test("Flusher should flush response", () {
    String message = "Hello World!";
    Call call = Call(Method.get, "http://");
    call.flush.listen(expectAsync1((dynamic res) {
      expect(res, message);
    }));
    Flusher(call).flush(message);
  });

  test("Flusher should flush exception", () {
    Exception exception = Exception("Hello World!");
    Call call = Call(Method.get, "http://");
    call.flush.listen(expectAsync1((dynamic res) {
      expect(res, exception);
    }));
    Flusher(call).throwError(exception);
  });

  test("Expect none throws if some sent", () {
    String url = "http://";
    httpMock.get(url);
    expect(() => httpMock.expectNone(url: url), throwsException);
  });

  test("Expect none throws if some sent with same method", () {
    String url = "http://";
    httpMock.get(url);
    expect(() => httpMock.expectNone(url: url, method: Method.get),
        throwsException);
  });

  test("Expect none does not throws if some sent with other method", () {
    String url = "http://";
    httpMock.delete(url);

    httpMock.expectNone(url: url, method: Method.get);
  });

  test("Expect one throws if no request found", () {
    String url = "http://";
    expect(() => httpMock.expectOne(url: url), throwsException);
  });

  test("Expect one throws if no request found with same method", () {
    String url = "http://";
    httpMock.get(url);
    expect(() => httpMock.expectOne(url: url, method: Method.delete),
        throwsException);
  });

  test("Expect one returns flusher", () {
    String url = "http://";
    httpMock.get(url);
    expect(httpMock.expectOne(url: url), TypeMatcher<Flusher>());
  });

  test("Expect one removes request from request list", () {
    String url = "http://";
    httpMock.get(url);

    httpMock.expectOne(url: url, method: Method.get);

    expect(() => httpMock.expectOne(url: url, method: Method.get),
        throwsException);
  });

  test("Verify does not throw if request list empty", () {
    httpMock.verify();
  });

  test("Verify throws if request list is not empty", () {
    httpMock.get("Http://");
    expect(() => httpMock.verify(), throwsException);
  });

  test("Expect one can flush to listener", () {
    String url = "http://";
    httpMock.get(url).listen(expectAsync1((Response res) {
      expect(res.json["message"], "Hello World");
    }));

    httpMock.expectOne(url: url).flush({"message": "Hello World"});
  });

  test("Can throw exception to listener", () {
    String url = "http://";
    httpMock.get(url).listen((Response res) {}).onError(
        expectAsync1((FormatException exception) {
          expect(exception.message, "Hello");
        }));

    httpMock.expectOne(url: url).throwError(FormatException("Hello"));
  });
}
