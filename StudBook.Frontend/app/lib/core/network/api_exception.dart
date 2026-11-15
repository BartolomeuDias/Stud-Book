sealed class AppException implements Exception {
  const AppException(this.message);

  final String? message;
}

final class ApiException extends AppException {
  const ApiException(this.statusCode, super.message);

  final int? statusCode;
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}
