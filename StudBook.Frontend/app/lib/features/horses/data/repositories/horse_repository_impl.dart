import '../../../../core/error/result.dart';
import '../../../../core/network/guarded_request.dart';
import '../../domain/entities/horse.dart';
import '../../domain/repositories/horse_repository.dart';
import '../datasources/horse_remote_data_source.dart';

class HorseRepositoryImpl implements HorseRepository {
  const HorseRepositoryImpl(this._remote);

  final HorseRemoteDataSource _remote;

  @override
  Future<Result<List<HorseSummary>>> getRegistry() => guardedRequest(_remote.getRegistry);

  @override
  Future<Result<HorseDetails>> getHorse(int id) => guardedRequest(() => _remote.getHorse(id));

  @override
  Future<Result<HorseDetails>> createHorse(HorseDraft draft) =>
      guardedRequest(() => _remote.createHorse(draft));

  @override
  Future<Result<HorseDetails>> updateHorse(int id, HorseDraft draft) =>
      guardedRequest(() => _remote.updateHorse(id, draft));

  @override
  Future<Result<void>> removeFromRegistry(int id) =>
      guardedRequest(() => _remote.removeFromRegistry(id));
}
