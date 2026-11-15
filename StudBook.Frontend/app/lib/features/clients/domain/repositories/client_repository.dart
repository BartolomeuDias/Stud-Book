import '../../../../core/error/result.dart';
import '../entities/client.dart';

abstract interface class ClientRepository {
  Future<Result<List<Client>>> getClients();
}
