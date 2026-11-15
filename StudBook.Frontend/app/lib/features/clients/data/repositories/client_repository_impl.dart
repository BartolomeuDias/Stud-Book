import '../../../../core/error/result.dart';
import '../../../../core/network/guarded_request.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_remote_data_source.dart';

class ClientRepositoryImpl implements ClientRepository {
  const ClientRepositoryImpl(this._remote);

  final ClientRemoteDataSource _remote;

  @override
  Future<Result<List<Client>>> getClients() => guardedRequest(_remote.getClients);
}
