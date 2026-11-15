import '../error/result.dart';

abstract interface class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

final class NoParams {
  const NoParams();
}
