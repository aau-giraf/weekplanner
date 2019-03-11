import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/providers/http/http.dart';
import 'package:weekplanner/providers/peristence/persistence.dart';
import 'package:http/http.dart' as http;

class HttpClient implements Http {
  Future<Map<String, String>> get _headers async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    String token = await _persist.getToken();

    if (token != null) {
      headers["Authorization"] = "Bearer " + token;
    }

    return headers;
  }

  final String baseUrl;
  final Persistence _persist;

  HttpClient(this.baseUrl, this._persist);

  @override
  Observable<Response> get(String url) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) =>
            _parseJson(http.get(baseUrl + url, headers: headers)));
  }

  @override
  Observable<Response> delete(String url) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) =>
            _parseJson(http.delete(baseUrl + url, headers: headers)));
  }

  @override
  Observable<Response> post(String url, Map<String, dynamic> body) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) => _parseJson(http.post(baseUrl + url,
            body: jsonEncode(body), headers: headers)));
  }

  @override
  Observable<Response> put(String url, Map<String, dynamic> body) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) => _parseJson(
            http.put(baseUrl + url, body: jsonEncode(body), headers: headers)));
  }

  @override
  Observable<Response> patch(String url, Map<String, dynamic> body) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) => _parseJson(http.patch(baseUrl + url,
            body: jsonEncode(body), headers: headers)));
  }

  Observable<Response> _parseJson(Future<http.Response> res) {
    return Observable.fromFuture(res).map((http.Response res) {
      Map<String, dynamic> json;
      // ensure all headers are in lowercase
      Map<String, String> headers =
          res.headers.map((h, v) => MapEntry(h.toLowerCase(), v));

      // only decode json if response says it's json
      if (headers.containsKey("content-type") &&
          headers["content-type"].toLowerCase().contains("application/json")) {
        json = jsonDecode(res.body);
      }

      return Response(res, json);
    });
  }
}
