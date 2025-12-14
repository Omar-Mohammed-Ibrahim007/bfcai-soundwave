class ApiController {
  static const String clientId = 'a29c161a';
  static const String baseUrl = 'https://api.jamendo.com/v3.0';

  static String buildUrl(String endpoint, Map<String, String> params) {
    final queryParams = {'client_id': clientId, 'format': 'json', ...params};
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }
}
