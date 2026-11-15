import '../../../../core/error/result.dart';
import '../entities/compatibility_rule.dart';

abstract interface class CompatibilityRuleRepository {
  Future<Result<List<CompatibilityRule>>> getRules();

  Future<Result<CompatibilityRule>> updateRule(CompatibilityRule rule, RuleChange change);
}
