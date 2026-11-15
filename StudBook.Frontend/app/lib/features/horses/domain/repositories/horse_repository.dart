import '../../../../core/error/result.dart';
import '../entities/horse.dart';

abstract interface class HorseRepository {
  Future<Result<List<HorseSummary>>> getRegistry();

  Future<Result<HorseDetails>> getHorse(int id);

  Future<Result<HorseDetails>> createHorse(HorseDraft draft);

  Future<Result<HorseDetails>> updateHorse(int id, HorseDraft draft);

  Future<Result<void>> removeFromRegistry(int id);
}
