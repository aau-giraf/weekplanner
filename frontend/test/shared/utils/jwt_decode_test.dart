import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/shared/utils/jwt_decode.dart';

String _createJwt(Map<String, dynamic> payload) {
  final header = base64Url.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final body = base64Url.encode(utf8.encode(json.encode(payload)));
  return '$header.$body.fake_signature';
}

void main() {
  group('JwtDecode', () {
    test('getUserId extracts user_id claim', () {
      final token = _createJwt({'user_id': '42'});
      expect(JwtDecode.getUserId(token), '42');
    });

    test('getUserId returns empty string when claim is missing', () {
      final token = _createJwt({'sub': 'something'});
      expect(JwtDecode.getUserId(token), '');
    });

    test('getOrgRoles extracts org_roles map', () {
      final token = _createJwt({
        'org_roles': {'1': 'admin', '2': 'member'},
      });
      final roles = JwtDecode.getOrgRoles(token);
      expect(roles, {'1': 'admin', '2': 'member'});
    });

    test('getOrgRoles returns empty map when claim is missing', () {
      final token = _createJwt({});
      expect(JwtDecode.getOrgRoles(token), isEmpty);
    });

    test('isExpired returns true when token is expired', () {
      final pastExp = DateTime.now().subtract(const Duration(hours: 1));
      final token = _createJwt({
        'exp': pastExp.millisecondsSinceEpoch ~/ 1000,
      });
      expect(JwtDecode.isExpired(token), true);
    });

    test('isExpired returns false when token is still valid', () {
      final futureExp = DateTime.now().add(const Duration(hours: 1));
      final token = _createJwt({
        'exp': futureExp.millisecondsSinceEpoch ~/ 1000,
      });
      expect(JwtDecode.isExpired(token), false);
    });

    test('isExpired returns true when exp claim is missing', () {
      final token = _createJwt({});
      expect(JwtDecode.isExpired(token), true);
    });

    test('throws FormatException for invalid token', () {
      expect(() => JwtDecode.getUserId('not.a.valid'), throwsFormatException);
    });

    test('handles numeric user_id', () {
      final token = _createJwt({'user_id': 123});
      expect(JwtDecode.getUserId(token), '123');
    });
  });
}
