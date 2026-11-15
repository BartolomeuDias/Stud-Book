import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/load_status.dart';
import '../../domain/entities/compatibility_rule.dart';
import '../../domain/usecases/rule_usecases.dart';

sealed class RulesEvent extends Equatable {
  const RulesEvent();

  @override
  List<Object?> get props => [];
}

final class RulesRequested extends RulesEvent {
  const RulesRequested();
}

final class RuleEdited extends RulesEvent {
  const RuleEdited(this.ruleId, this.change);

  final int ruleId;
  final RuleChange change;

  @override
  List<Object?> get props => [ruleId, change];
}

final class RuleSaveRequested extends RulesEvent {
  const RuleSaveRequested(this.ruleId);

  final int ruleId;

  @override
  List<Object?> get props => [ruleId];
}

class RulesNotice extends Equatable {
  const RulesNotice({required this.sequence, this.savedCode, this.failure});

  final int sequence;
  final String? savedCode;
  final Failure? failure;

  @override
  List<Object?> get props => [sequence, savedCode, failure];
}

class RulesState extends Equatable {
  const RulesState({
    this.status = LoadStatus.initial,
    this.rules = const [],
    this.changes = const {},
    this.saving = const {},
    this.failure,
    this.notice,
  });

  final LoadStatus status;
  final List<CompatibilityRule> rules;
  final Map<int, RuleChange> changes;
  final Set<int> saving;
  final Failure? failure;
  final RulesNotice? notice;

  RuleChange changeFor(CompatibilityRule rule) => changes[rule.id] ?? rule.asChange;

  bool isDirty(CompatibilityRule rule) => changeFor(rule) != rule.asChange;

  int get activeCount => rules.where((rule) => rule.isActive).length;

  RulesState copyWith({
    LoadStatus? status,
    List<CompatibilityRule>? rules,
    Map<int, RuleChange>? changes,
    Set<int>? saving,
    Failure? Function()? failure,
    RulesNotice? notice,
  }) => RulesState(
    status: status ?? this.status,
    rules: rules ?? this.rules,
    changes: changes ?? this.changes,
    saving: saving ?? this.saving,
    failure: failure == null ? this.failure : failure(),
    notice: notice ?? this.notice,
  );

  @override
  List<Object?> get props => [status, rules, changes, saving, failure, notice];
}

class RulesBloc extends Bloc<RulesEvent, RulesState> {
  RulesBloc({required GetRulesUseCase getRules, required UpdateRuleUseCase updateRule})
    : _getRules = getRules,
      _updateRule = updateRule,
      super(const RulesState()) {
    on<RulesRequested>(_onRequested);
    on<RuleEdited>(_onEdited);
    on<RuleSaveRequested>(_onSave);
  }

  final GetRulesUseCase _getRules;
  final UpdateRuleUseCase _updateRule;

  Future<void> _onRequested(RulesRequested event, Emitter<RulesState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: () => null));
    final result = await _getRules(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(status: LoadStatus.failure, failure: () => failure),
        (rules) => state.copyWith(status: LoadStatus.success, rules: rules, changes: const {}),
      ),
    );
  }

  void _onEdited(RuleEdited event, Emitter<RulesState> emit) =>
      emit(state.copyWith(changes: {...state.changes, event.ruleId: event.change}));

  Future<void> _onSave(RuleSaveRequested event, Emitter<RulesState> emit) async {
    final rule = state.rules.firstWhere((item) => item.id == event.ruleId);
    emit(state.copyWith(saving: {...state.saving, rule.id}));
    final result = await _updateRule(UpdateRuleParams(rule: rule, change: state.changeFor(rule)));
    final saving = {...state.saving}..remove(rule.id);
    final sequence = (state.notice?.sequence ?? 0) + 1;
    emit(
      result.fold(
        (failure) => state.copyWith(
          saving: saving,
          notice: RulesNotice(sequence: sequence, failure: failure),
        ),
        (updated) => state.copyWith(
          saving: saving,
          rules: [for (final item in state.rules) item.id == updated.id ? updated : item]
            ..sort((a, b) => a.priority.compareTo(b.priority)),
          changes: {...state.changes}..remove(updated.id),
          notice: RulesNotice(sequence: sequence, savedCode: updated.code),
        ),
      ),
    );
  }
}
