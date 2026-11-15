import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../../core/utils/load_status.dart';
import '../../../../clients/domain/entities/client.dart';
import '../../../../clients/domain/usecases/get_clients.dart';
import '../../../domain/entities/horse.dart';
import '../../../domain/usecases/horse_usecases.dart';

enum HorseFormField { name, breed, color, owner }

class ParentOption extends Equatable {
  const ParentOption({required this.id, required this.name, this.registrationNumber});

  final int id;
  final String name;
  final String? registrationNumber;

  @override
  List<Object?> get props => [id, name, registrationNumber];
}

sealed class HorseFormEvent extends Equatable {
  const HorseFormEvent();

  @override
  List<Object?> get props => [];
}

final class HorseFormStarted extends HorseFormEvent {
  const HorseFormStarted();
}

final class HorseFormChanged extends HorseFormEvent {
  const HorseFormChanged(this.draft);

  final HorseDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class HorseFormSubmitted extends HorseFormEvent {
  const HorseFormSubmitted();
}

class HorseFormState extends Equatable {
  const HorseFormState({
    this.horseId,
    this.status = LoadStatus.initial,
    this.draft = const HorseDraft(),
    this.originalName,
    this.clients = const [],
    this.sires = const [],
    this.dams = const [],
    this.showErrors = false,
    this.validationAttempt = 0,
    this.submit = SubmitStatus.idle,
    this.loadFailure,
    this.submitFailure,
    this.savedHorseId,
  });

  final int? horseId;
  final LoadStatus status;
  final HorseDraft draft;
  final String? originalName;
  final List<Client> clients;
  final List<ParentOption> sires;
  final List<ParentOption> dams;
  final bool showErrors;
  final int validationAttempt;
  final SubmitStatus submit;
  final Failure? loadFailure;
  final Failure? submitFailure;
  final int? savedHorseId;

  bool get isEdit => horseId != null;

  Set<HorseFormField> get invalidFields => {
    if (draft.name.trim().isEmpty) HorseFormField.name,
    if (draft.breed.trim().isEmpty) HorseFormField.breed,
    if (draft.color.trim().isEmpty) HorseFormField.color,
    if (draft.category.requiresOwner && draft.ownerClientId == null) HorseFormField.owner,
  };

  HorseFormField? get firstInvalid =>
      HorseFormField.values.where(invalidFields.contains).firstOrNull;

  bool hasError(HorseFormField field) => showErrors && invalidFields.contains(field);

  HorseFormState copyWith({
    LoadStatus? status,
    HorseDraft? draft,
    String? originalName,
    List<Client>? clients,
    List<ParentOption>? sires,
    List<ParentOption>? dams,
    bool? showErrors,
    int? validationAttempt,
    SubmitStatus? submit,
    Failure? Function()? loadFailure,
    Failure? Function()? submitFailure,
    int? savedHorseId,
  }) => HorseFormState(
    horseId: horseId,
    status: status ?? this.status,
    draft: draft ?? this.draft,
    originalName: originalName ?? this.originalName,
    clients: clients ?? this.clients,
    sires: sires ?? this.sires,
    dams: dams ?? this.dams,
    showErrors: showErrors ?? this.showErrors,
    validationAttempt: validationAttempt ?? this.validationAttempt,
    submit: submit ?? this.submit,
    loadFailure: loadFailure == null ? this.loadFailure : loadFailure(),
    submitFailure: submitFailure == null ? this.submitFailure : submitFailure(),
    savedHorseId: savedHorseId ?? this.savedHorseId,
  );

  @override
  List<Object?> get props => [
    horseId,
    status,
    draft,
    originalName,
    clients,
    sires,
    dams,
    showErrors,
    validationAttempt,
    submit,
    loadFailure,
    submitFailure,
    savedHorseId,
  ];
}

class HorseFormBloc extends Bloc<HorseFormEvent, HorseFormState> {
  HorseFormBloc({
    int? horseId,
    required GetHorseUseCase getHorse,
    required GetRegistryUseCase getRegistry,
    required GetClientsUseCase getClients,
    required SaveHorseUseCase saveHorse,
  }) : _getHorse = getHorse,
       _getRegistry = getRegistry,
       _getClients = getClients,
       _saveHorse = saveHorse,
       super(HorseFormState(horseId: horseId)) {
    on<HorseFormStarted>(_onStarted);
    on<HorseFormChanged>(
      (event, emit) => emit(state.copyWith(draft: event.draft, submit: SubmitStatus.idle)),
    );
    on<HorseFormSubmitted>(_onSubmitted);
  }

  final GetHorseUseCase _getHorse;
  final GetRegistryUseCase _getRegistry;
  final GetClientsUseCase _getClients;
  final SaveHorseUseCase _saveHorse;

  Future<void> _onStarted(HorseFormStarted event, Emitter<HorseFormState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, loadFailure: () => null));
    final id = state.horseId;
    final results = await (
      _getClients(const NoParams()),
      _getRegistry(const NoParams()),
      id == null ? Future<Result<HorseDetails>?>.value() : _getHorse(id),
    ).wait;
    final (clientsResult, registryResult, horseResult) = results;

    final failure = [
      clientsResult,
      registryResult,
      horseResult,
    ].whereType<Failed<Object?>>().map((result) => result.failure).firstOrNull;
    if (failure != null) {
      emit(state.copyWith(status: LoadStatus.failure, loadFailure: () => failure));
      return;
    }

    final clients = (clientsResult as Success<List<Client>>).value;
    final registry = (registryResult as Success<List<HorseSummary>>).value;
    final horse = horseResult is Success<HorseDetails> ? horseResult.value : null;

    emit(
      state.copyWith(
        status: LoadStatus.success,
        clients: [...clients]..sort((a, b) => a.name.compareTo(b.name)),
        sires: _parents(registry, HorseSex.stallion, horse, horse?.pedigree.sire),
        dams: _parents(registry, HorseSex.mare, horse, horse?.pedigree.dam),
        draft: horse == null ? null : HorseDraft.fromDetails(horse),
        originalName: horse?.name,
      ),
    );
  }

  List<ParentOption> _parents(
    List<HorseSummary> registry,
    HorseSex sex,
    HorseDetails? self,
    PedigreeNode? current,
  ) {
    final options = [
      for (final horse in registry)
        if (horse.sex == sex && horse.id != self?.id)
          ParentOption(
            id: horse.id,
            name: horse.name,
            registrationNumber: horse.registrationNumber,
          ),
    ];
    if (current != null && options.every((option) => option.id != current.id)) {
      options.add(
        ParentOption(
          id: current.id,
          name: current.name,
          registrationNumber: current.registrationNumber,
        ),
      );
    }
    return options..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> _onSubmitted(HorseFormSubmitted event, Emitter<HorseFormState> emit) async {
    if (state.invalidFields.isNotEmpty) {
      emit(state.copyWith(showErrors: true, validationAttempt: state.validationAttempt + 1));
      return;
    }
    emit(
      state.copyWith(showErrors: true, submit: SubmitStatus.submitting, submitFailure: () => null),
    );
    final result = await _saveHorse(SaveHorseParams(draft: state.draft, id: state.horseId));
    emit(
      result.fold(
        (failure) => state.copyWith(submit: SubmitStatus.failure, submitFailure: () => failure),
        (horse) => state.copyWith(submit: SubmitStatus.success, savedHorseId: horse.id),
      ),
    );
  }
}
