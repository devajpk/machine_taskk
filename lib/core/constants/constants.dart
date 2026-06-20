class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://jsonplaceholder.typicode.com');
  static const String apiToken = String.fromEnvironment('API_TOKEN', defaultValue: '');
}
