import 'dart:convert';

/// Creates a valid JWT with user_id=42, org_roles={'1': 'admin'}, expiring in 1 hour.
String createValidJwt() {
  final header = base64Url.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final payload = base64Url.encode(utf8.encode(json.encode({
    'user_id': '42',
    'org_roles': {'1': 'admin'},
    'exp':
        DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000,
  })));
  return '$header.$payload.sig';
}

/// Creates an expired JWT.
String createExpiredJwt() {
  final header = base64Url.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final payload = base64Url.encode(utf8.encode(json.encode({
    'user_id': '42',
    'org_roles': {},
    'exp': DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch ~/
        1000,
  })));
  return '$header.$payload.sig';
}
