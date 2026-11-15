import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/horse.dart';
import '../repositories/horse_repository.dart';

class GetRegistryUseCase implements UseCase<List<HorseSummary>, NoParams> {
  const GetRegistryUseCase(this._repository);

  final HorseRepository _repository;

  @override
  Future<Result<List<HorseSummary>>> call(NoParams params) => _repository.getRegistry();
}

class GetHorseUseCase implements UseCase<HorseDetails, int> {
  const GetHorseUseCase(this._repository);

  final HorseRepository _repository;

  @override
  Future<Result<HorseDetails>> call(int id) => _repository.getHorse(id);
}

class SaveHorseParams {
  const SaveHorseParams({required this.draft, this.id});

  final HorseDraft draft;
  final int? id;
}

class SaveHorseUseCase implements UseCase<HorseDetails, SaveHorseParams> {
  const SaveHorseUseCase(this._repository);

  final HorseRepository _repository;

  @override
  Future<Result<HorseDetails>> call(SaveHorseParams params) {
    final id = params.id;
    return id == null
        ? _repository.createHorse(params.draft)
        : _repository.updateHorse(id, params.draft);
  }
}

class RemoveHorseUseCase implements UseCase<void, int> {
  const RemoveHorseUseCase(this._repository);

  final HorseRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.removeFromRegistry(id);
}
