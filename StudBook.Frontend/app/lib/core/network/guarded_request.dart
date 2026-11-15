import '../error/failure.dart';
import '../error/result.dart';
import 'api_config.dart';
import 'api_exception.dart';

Future<Result<T>> guardedRequest<T>(Future<T> Function() request) async {
  try {
    return Success(await request());
  } on NetworkException {
    return const Failed(NetworkFailure());
  } on ApiException catch (error) {
    return Failed(_failureFor(error));
  } on FormatException catch (error) {
    return Failed(ServerFailure(null, error.message));
  }
}

Failure _failureFor(ApiException error) {
  final message = error.message;
  return switch (error.statusCode) {
    HttpStatusCode.notFound => const NotFoundFailure(),
    HttpStatusCode.unauthorized => const UnauthorizedFailure(),
    HttpStatusCode.badRequest when message != null => ValidationFailure(message),
    final code => message == null ? ServerFailure(code) : ServerFailure(code, message),
  };
}
