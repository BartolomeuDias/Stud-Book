import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/load_status.dart';
import '../../../domain/entities/horse.dart';
import '../../../domain/usecases/horse_usecases.dart';

sealed class HorseDetailsEvent extends Equatable {
  const HorseDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class HorseDetailsRequested extends HorseDetailsEvent {
  const HorseDetailsRequested();
}

final class HorseRemovalRequested extends HorseDetailsEvent {
  const HorseRemovalRequested();
}

class HorseDetailsState extends Equatable {
  const HorseDetailsState({
    required this.horseId,
    this.status = LoadStatus.initial,
    this.horse,
    this.failure,
    this.removal = SubmitStatus.idle,
    this.removalFailure,
  });

  final int horseId;
  final LoadStatus status;
  final HorseDetails? horse;
  final Failure? failure;
  final SubmitStatus removal;
  final Failure? removalFailure;

  HorseDetailsState copyWith({
    LoadStatus? status,
    HorseDetails? horse,
    Failure? Function()? failure,
    SubmitStatus? removal,
    Failure? Function()? removalFailure,
  }) => HorseDetailsState(
    horseId: horseId,
    status: status ?? this.status,
    horse: horse ?? this.horse,
    failure: failure == null ? this.failure : failure(),
    removal: removal ?? this.removal,
    removalFailure: removalFailure == null ? this.removalFailure : removalFailure(),
  );

  @override
  List<Object?> get props => [horseId, status, horse, failure, removal, removalFailure];
}

class HorseDetailsBloc extends Bloc<HorseDetailsEvent, HorseDetailsState> {
  HorseDetailsBloc({
    required int horseId,
    required GetHorseUseCase getHorse,
    required RemoveHorseUseCase removeHorse,
  }) : _getHorse = getHorse,
       _removeHorse = removeHorse,
       super(HorseDetailsState(horseId: horseId)) {
    on<HorseDetailsRequested>(_onRequested);
    on<HorseRemovalRequested>(_onRemoval);
  }

  final GetHorseUseCase _getHorse;
  final RemoveHorseUseCase _removeHorse;

  Future<void> _onRequested(HorseDetailsRequested event, Emitter<HorseDetailsState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));
    final result = await _getHorse(state.horseId);
    emit(
      result.fold(
        (failure) => state.copyWith(status: LoadStatus.failure, failure: () => failure),
        (horse) => state.copyWith(status: LoadStatus.success, horse: horse),
      ),
    );
  }

  Future<void> _onRemoval(HorseRemovalRequested event, Emitter<HorseDetailsState> emit) async {
    emit(state.copyWith(removal: SubmitStatus.submitting, removalFailure: () => null));
    final result = await _removeHorse(state.horseId);
    emit(
      result.fold(
        (failure) => state.copyWith(removal: SubmitStatus.failure, removalFailure: () => failure),
        (_) => state.copyWith(removal: SubmitStatus.success),
      ),
    );
  }
}
