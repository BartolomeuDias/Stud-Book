abstract final class ApiConfig {
  static const _baseUrlOverride = String.fromEnvironment('API_BASE_URL');
  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 20);

  static String get baseUrl => _baseUrlOverride.isNotEmpty ? _baseUrlOverride : Uri.base.origin;
}

abstract final class HttpStatusCode {
  static const badRequest = 400;
  static const unauthorized = 401;
  static const notFound = 404;
}

abstract final class ApiPaths {
  static const login = '/api/auth/login';
  static const horses = '/api/horses';
  static const clients = '/api/clients';
  static const compatibilityRules = '/api/compatibility-rules';

  static String horse(int id) => '$horses/$id';
  static String compatibilityRule(int id) => '$compatibilityRules/$id';
}
