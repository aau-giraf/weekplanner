import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class Response {
  final http.Response response;
  final Map<String, dynamic> json;

  Response(this.response, this.json);
}

abstract class Http {
  Observable<Response> get(String url, {bool raw: false});
  Observable<Response> delete(String url, {bool raw: false});
  Observable<Response> post(String url, Map<String, dynamic> body, {bool raw: false});
  Observable<Response> put(String url, Map<String, dynamic> body, {bool raw: false});
  Observable<Response> patch(String url, Map<String, dynamic> body, {bool raw: false});
}
