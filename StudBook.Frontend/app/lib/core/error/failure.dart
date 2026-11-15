import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Could not reach the server. Check that the API is running.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure(this.statusCode, [super.message = 'The server returned an error.']);

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The record was not found.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'This account could not sign in.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
