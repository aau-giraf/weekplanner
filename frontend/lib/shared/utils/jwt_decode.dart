import 'dart:convert';

class JwtDecode {
  static Map<String, dynamic> _decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid JWT');
    }
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded) as Map<String, dynamic>;
  }

  static String getUserId(String token) {
    final payload = _decode(token);
    return payload['user_id']?.toString() ?? '';
  }

  static Map<String, String> getOrgRoles(String token) {
    final payload = _decode(token);
    final orgRoles = payload['org_roles'];
    if (orgRoles is Map) {
      return orgRoles.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }

  static bool isExpired(String token) {
    final payload = _decode(token);
    final exp = payload['exp'] as int?;
    if (exp == null) return true;
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiry);
  }
}
