import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/client.dart';
import '../repositories/client_repository.dart';

class GetClientsUseCase implements UseCase<List<Client>, NoParams> {
  const GetClientsUseCase(this._repository);

  final ClientRepository _repository;

  @override
  Future<Result<List<Client>>> call(NoParams params) => _repository.getClients();
}
