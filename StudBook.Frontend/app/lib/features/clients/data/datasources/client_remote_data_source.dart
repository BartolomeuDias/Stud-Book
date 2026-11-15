import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/client.dart';
import '../models/client_model.dart';

class ClientRemoteDataSource {
  const ClientRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<Client>> getClients() async {
    final json = await _client.get(ApiPaths.clients) as List<dynamic>;
    return [for (final item in json) ClientModel.fromJson(item as Map<String, dynamic>)];
  }
}
