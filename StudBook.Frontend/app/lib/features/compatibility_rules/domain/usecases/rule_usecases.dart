import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/compatibility_rule.dart';
import '../repositories/compatibility_rule_repository.dart';

class GetRulesUseCase implements UseCase<List<CompatibilityRule>, NoParams> {
  const GetRulesUseCase(this._repository);

  final CompatibilityRuleRepository _repository;

  @override
  Future<Result<List<CompatibilityRule>>> call(NoParams params) async {
    final result = await _repository.getRules();
    return result.fold(
      Failed.new,
      (rules) => Success([...rules]..sort((a, b) => a.priority.compareTo(b.priority))),
    );
  }
}

class UpdateRuleParams {
  const UpdateRuleParams({required this.rule, required this.change});

  final CompatibilityRule rule;
  final RuleChange change;
}

class UpdateRuleUseCase implements UseCase<CompatibilityRule, UpdateRuleParams> {
  const UpdateRuleUseCase(this._repository);

  static const minPriority = 1;
  static const minThreshold = 0;
  static const priorityMessage = 'Priority must be 1 or higher.';
  static const thresholdMessage = 'Threshold cannot be negative.';

  final CompatibilityRuleRepository _repository;

  @override
  Future<Result<CompatibilityRule>> call(UpdateRuleParams params) async {
    final change = params.change;
    if (change.priority < minPriority) return const Failed(ValidationFailure(priorityMessage));
    final threshold = change.threshold;
    if (threshold != null && threshold < minThreshold) {
      return const Failed(ValidationFailure(thresholdMessage));
    }
    return _repository.updateRule(params.rule, change);
  }
}
