import '../../../../core/error/result.dart';
import '../../../../core/network/guarded_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<Session>> login(String email) => guardedRequest(() async {
    final session = await _remote.login(email);
    await _local.write(session);
    return session;
  });

  @override
  Future<Session?> restoreSession() async => _local.read();

  @override
  Future<void> logout() => _local.clear();
}
