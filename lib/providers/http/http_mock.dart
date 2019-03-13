import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/providers/http/http.dart';

enum Method { get, post, put, delete, patch }

class Call {
  final Method method;
  final String url;
  PublishSubject<dynamic> flush; // ignore: close_sinks

  Call(this.method, this.url) {
    flush = PublishSubject<dynamic>();
  }
}

class Flusher {
  Call _call;

  Flusher(this._call);

  /// Flush a body to our listener
  ///
  /// [response] The response to flush
  void flush(dynamic response) {
    _call.flush.add(response);
  }

  /// Send an exception to our listener
  ///
  /// [exception] The exception to send
  void throwError(Exception exception) {
    _call.flush.add(exception);
  }
}

class HttpMock implements Http {
  List<Call> calls = List();

  /// Ensure that there are no requests that are not already expected
  void verify() {
    if (calls.length > 0) {
      throw Exception("Expected no requests, found: \n" +
          calls.map((call) => "[${call.method}] ${call.url}").join("\n"));
    }
  }

  /// Expect a request with the given method and url.
  ///
  /// [method] One of delete, get, patch, post, or put.
  /// [url] The url that is expected
  Flusher expectOne({Method method, @required String url}) {
    int index = calls.indexWhere(
        (call) => call.url == url && (method == null || method == call.method));

    if (index == -1) {
      throw Exception("Expected [$method] $url, found none");
    }

    Call call = calls[index];
    calls.removeAt(index);
    return Flusher(call);
  }

  /// Ensure that no request with the given method and url is send
  ///
  /// [method] One of delete, get, patch, post, or put.
  /// [url] The url that not expected
  void expectNone({Method method, @required String url}) {
    for (Call call in calls) {
      if (call.url == url && (method == null || method == call.method)) {
        throw Exception("Found [$method] $url, expected none");
      }
    }
  }

  @override
  Observable<Response> delete(String url, {bool raw: false}) {
    return _reqToRes(Method.delete, url);
  }

  @override
  Observable<Response> get(String url, {bool raw: false}) {
    return _reqToRes(Method.get, url);
  }

  @override
  Observable<Response> patch(String url, Map<String, dynamic> body,
      {bool raw: false}) {
    return _reqToRes(Method.patch, url);
  }

  @override
  Observable<Response> post(String url, Map<String, dynamic> body,
      {bool raw: false}) {
    return _reqToRes(Method.post, url);
  }

  @override
  Observable<Response> put(String url, Map<String, dynamic> body,
      {bool raw: false}) {
    return _reqToRes(Method.put, url);
  }

  Observable<Response> _reqToRes(Method method, String url) {
    Call call = Call(method, url);
    calls.add(call);

    return call.flush.map((dynamic response) {
      if (response is Exception) {
        throw response;
      }

      return Response(null, response);
    });
  }
}
