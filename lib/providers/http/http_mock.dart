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

  void flush(dynamic response) {
    _call.flush.add(response);
  }

  void throws(Exception exception) {}
}

class HttpMock implements Http {
  List<Call> calls = List();

  void verify() {
    if (calls.length > 0) {
      throw Exception("Expected no requests, found: \n" +
          calls.map((call) => "[${call.method}] ${call.url}").join("\n"));
    }
  }

  Flusher expectOne({Method method, @required String url}) {
    int index = calls.indexWhere((call) => call.url == url);

    if (index == -1) {
      throw Exception("Expected [$method] $url, found none");
    }
    Call call = calls[index];
    calls.removeAt(index);
    return Flusher(call);
  }

  void expectNone({Method method, @required String url}) {
    calls.forEach((call) {
      if (call.url == url && method != null && call.method != method) {
        throw Exception("Found [$method] $url, expected none");
      }
    });
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
      return Response(null, response);
    });
  }
}
