import '../../../../core/error/result.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Result<Session>> login(String email);

  Future<Session?> restoreSession();

  Future<void> logout();
}
