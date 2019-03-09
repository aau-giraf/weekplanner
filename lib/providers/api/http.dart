import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class Response {
  final http.Response response;
  final Map<String, dynamic> json;

  Response(this.response, this.json);
}

class Http {
  static String token;
  static Map<String, String> get _headers {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers["Authorization"] = "Bearer " + token;
    }
    return headers;
  }

  String baseUrl;

  Http(this.baseUrl);

  Observable<Response> get(String url) {
    return _parseJson(http.get(baseUrl + url));
  }

  Observable<Response> delete(String url) {
    return _parseJson(http.delete(baseUrl + url));
  }

  Observable<Response> post(String url, Map<String, dynamic> body) {
    return _parseJson(http.post(baseUrl + url, body: body, headers: _headers));
  }

  Observable<Response> put(String url, Map<String, dynamic> body) {
    return _parseJson(http.put(baseUrl + url, body: body, headers: _headers));
  }

  Observable<Response> patch(
      String url, Map<String, dynamic> body) {
    return _parseJson(http.patch(baseUrl + url, body: body, headers: _headers));
  }

  Observable<Response> _parseJson(Future<http.Response> res) {
    return Observable.fromFuture(res)
        .map((http.Response res) => Response(res, jsonDecode(res.body)));
  }
}
