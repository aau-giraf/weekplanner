class ApiConfig {
  static const String coreBaseUrl =
      String.fromEnvironment('CORE_BASE_URL', defaultValue: 'http://10.0.2.2:8000');
  static const String weekplannerBaseUrl =
      String.fromEnvironment('WEEKPLANNER_BASE_URL', defaultValue: 'http://10.0.2.2:5171');

}
