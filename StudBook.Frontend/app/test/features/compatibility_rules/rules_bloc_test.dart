import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studbook_app/core/error/result.dart';
import 'package:studbook_app/core/usecase/usecase.dart';
import 'package:studbook_app/features/compatibility_rules/domain/entities/compatibility_rule.dart';
import 'package:studbook_app/features/compatibility_rules/domain/repositories/compatibility_rule_repository.dart';
import 'package:studbook_app/features/compatibility_rules/domain/usecases/rule_usecases.dart';
import 'package:studbook_app/features/compatibility_rules/presentation/bloc/rules_bloc.dart';

class _MockRepository extends Mock implements CompatibilityRuleRepository {}

const _kinship = CompatibilityRule(
  id: 1,
  code: 'KINSHIP_2GEN',
  description: 'No shared ancestors within two generations',
  denialMessage: 'Pair blocked: kinship',
  isActive: true,
  priority: 1,
  source: RuleSource.teamDraft,
);

const _rest = CompatibilityRule(
  id: 2,
  code: 'MARE_REST',
  description: 'Mare rests after foaling',
  denialMessage: 'Mare needs rest',
  isActive: true,
  priority: 2,
  source: RuleSource.teamDraft,
  threshold: 30,
  thresholdUnit: 'days',
);

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(_kinship);
    registerFallbackValue(_kinship.asChange);
  });

  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
    when(() => repository.getRules()).thenAnswer((_) async => const Success([_rest, _kinship]));
  });

  RulesBloc build() =>
      RulesBloc(getRules: GetRulesUseCase(repository), updateRule: UpdateRuleUseCase(repository));

  blocTest<RulesBloc, RulesState>(
    'orders rules by priority',
    build: build,
    act: (bloc) => bloc.add(const RulesRequested()),
    verify: (bloc) => expect(bloc.state.rules.map((rule) => rule.id), [1, 2]),
  );

  blocTest<RulesBloc, RulesState>(
    'tracks edits as dirty and clears them after saving',
    setUp: () => when(() => repository.updateRule(any(), any())).thenAnswer((invocation) async {
      final change = invocation.positionalArguments[1] as RuleChange;
      return Success(
        CompatibilityRule(
          id: _rest.id,
          code: _rest.code,
          description: _rest.description,
          denialMessage: _rest.denialMessage,
          isActive: change.isActive,
          priority: change.priority,
          source: change.source,
          threshold: change.threshold,
          thresholdUnit: _rest.thresholdUnit,
        ),
      );
    }),
    build: build,
    act: (bloc) async {
      bloc
        ..add(const RulesRequested())
        ..add(RuleEdited(_rest.id, _rest.asChange.copyWith(threshold: () => 45)));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.isDirty(bloc.state.rules.last), isTrue);
      bloc.add(RuleSaveRequested(_rest.id));
    },
    verify: (bloc) {
      final saved = bloc.state.rules.firstWhere((rule) => rule.id == _rest.id);
      expect(saved.threshold, 45);
      expect(bloc.state.isDirty(saved), isFalse);
      expect(bloc.state.notice?.savedCode, _rest.code);
    },
  );

  blocTest<RulesBloc, RulesState>(
    'rejects a priority below one without calling the API',
    build: build,
    act: (bloc) => bloc
      ..add(const RulesRequested())
      ..add(RuleEdited(_kinship.id, _kinship.asChange.copyWith(priority: 0)))
      ..add(RuleSaveRequested(_kinship.id)),
    verify: (bloc) {
      expect(bloc.state.notice?.failure?.message, UpdateRuleUseCase.priorityMessage);
      verifyNever(() => repository.updateRule(any(), any()));
    },
  );
}
