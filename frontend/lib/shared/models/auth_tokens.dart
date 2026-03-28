class AuthTokens {
  final String access;
  final String refresh;
  final Map<String, String> orgRoles;

  const AuthTokens({
    required this.access,
    required this.refresh,
    required this.orgRoles,
  });
}
