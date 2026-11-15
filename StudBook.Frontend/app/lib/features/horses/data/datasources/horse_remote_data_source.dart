import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/horse.dart';
import '../models/horse_models.dart';

class HorseRemoteDataSource {
  const HorseRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<HorseSummary>> getRegistry() async {
    final json = await _client.get(ApiPaths.horses) as List<dynamic>;
    return [for (final item in json) HorseModels.summaryFromJson(item as Map<String, dynamic>)];
  }

  Future<HorseDetails> getHorse(int id) async =>
      HorseModels.detailsFromJson(await _client.get(ApiPaths.horse(id)) as Map<String, dynamic>);

  Future<HorseDetails> createHorse(HorseDraft draft) async => HorseModels.detailsFromJson(
    await _client.post(ApiPaths.horses, body: HorseModels.draftToJson(draft))
        as Map<String, dynamic>,
  );

  Future<HorseDetails> updateHorse(int id, HorseDraft draft) async => HorseModels.detailsFromJson(
    await _client.put(ApiPaths.horse(id), body: HorseModels.draftToJson(draft))
        as Map<String, dynamic>,
  );

  Future<void> removeFromRegistry(int id) => _client.delete(ApiPaths.horse(id));
}
