import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../../core/utils/load_status.dart';
import '../../../domain/entities/horse.dart';
import '../../../domain/usecases/horse_usecases.dart';

sealed class RegistryEvent extends Equatable {
  const RegistryEvent();

  @override
  List<Object?> get props => [];
}

final class RegistryRequested extends RegistryEvent {
  const RegistryRequested();
}

final class RegistryCategorySelected extends RegistryEvent {
  const RegistryCategorySelected(this.category);

  final HorseCategory? category;

  @override
  List<Object?> get props => [category];
}

final class RegistrySearchChanged extends RegistryEvent {
  const RegistrySearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class RegistryState extends Equatable {
  const RegistryState({
    this.status = LoadStatus.initial,
    this.horses = const [],
    this.category,
    this.query = '',
    this.failure,
  });

  final LoadStatus status;
  final List<HorseSummary> horses;
  final HorseCategory? category;
  final String query;
  final Failure? failure;

  int countOf(HorseCategory? value) =>
      value == null ? horses.length : horses.where((horse) => horse.category == value).length;

  List<HorseSummary> get inCategory =>
      category == null ? horses : horses.where((horse) => horse.category == category).toList();

  List<HorseSummary> get visible {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return inCategory;
    bool matches(String? value) => value != null && value.toLowerCase().contains(needle);
    return inCategory
        .where(
          (horse) =>
              matches(horse.name) || matches(horse.registrationNumber) || matches(horse.ownerName),
        )
        .toList();
  }

  RegistryState copyWith({
    LoadStatus? status,
    List<HorseSummary>? horses,
    HorseCategory? Function()? category,
    String? query,
    Failure? Function()? failure,
  }) => RegistryState(
    status: status ?? this.status,
    horses: horses ?? this.horses,
    category: category == null ? this.category : category(),
    query: query ?? this.query,
    failure: failure == null ? this.failure : failure(),
  );

  @override
  List<Object?> get props => [status, horses, category, query, failure];
}

class RegistryBloc extends Bloc<RegistryEvent, RegistryState> {
  RegistryBloc(this._getRegistry, {HorseCategory? initialCategory})
    : super(RegistryState(category: initialCategory)) {
    on<RegistryRequested>(_onRequested);
    on<RegistryCategorySelected>(
      (event, emit) => emit(state.copyWith(category: () => event.category)),
    );
    on<RegistrySearchChanged>((event, emit) => emit(state.copyWith(query: event.query)));
  }

  final GetRegistryUseCase _getRegistry;

  Future<void> _onRequested(RegistryRequested event, Emitter<RegistryState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));
    final result = await _getRegistry(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(status: LoadStatus.failure, failure: () => failure),
        (horses) => state.copyWith(status: LoadStatus.success, horses: _sorted(horses)),
      ),
    );
  }

  List<HorseSummary> _sorted(List<HorseSummary> horses) => [...horses]
    ..sort((a, b) {
      final byCategory = a.category.index.compareTo(b.category.index);
      return byCategory != 0 ? byCategory : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
}
