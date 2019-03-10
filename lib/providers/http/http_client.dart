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
  Observable<Response> get(String url, {bool raw: false}) {
    return _parseJson(http.get(baseUrl + url), raw);
  }

  @override
  Observable<Response> delete(String url, {bool raw: false}) {
    return _parseJson(http.delete(baseUrl + url), raw);
  }

  @override
  Observable<Response> post(String url, Map<String, dynamic> body,
      {bool raw: false}) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) => _parseJson(
            http.post(baseUrl + url, body: body, headers: headers), raw));
  }

  @override
  Observable<Response> put(String url, Map<String, dynamic> body,
      {bool raw: false}) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) => _parseJson(
            http.put(baseUrl + url, body: body, headers: headers), raw));
  }

  @override
  Observable<Response> patch(String url, Map<String, dynamic> body,
      {bool raw: false}) {
    return Observable.fromFuture(_headers).flatMap(
        (Map<String, String> headers) => _parseJson(
            http.patch(baseUrl + url, body: body, headers: headers), raw));
  }

  Observable<Response> _parseJson(Future<http.Response> res, bool raw) {
    return Observable.fromFuture(res).map((http.Response res) =>
        Response(res, raw ? null : jsonDecode(res.body)));
  }
}
