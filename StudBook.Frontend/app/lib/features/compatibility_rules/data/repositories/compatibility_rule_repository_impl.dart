import '../../../../core/error/result.dart';
import '../../../../core/network/guarded_request.dart';
import '../../domain/entities/compatibility_rule.dart';
import '../../domain/repositories/compatibility_rule_repository.dart';
import '../datasources/compatibility_rule_remote_data_source.dart';

class CompatibilityRuleRepositoryImpl implements CompatibilityRuleRepository {
  const CompatibilityRuleRepositoryImpl(this._remote);

  final CompatibilityRuleRemoteDataSource _remote;

  @override
  Future<Result<List<CompatibilityRule>>> getRules() => guardedRequest(_remote.getRules);

  @override
  Future<Result<CompatibilityRule>> updateRule(CompatibilityRule rule, RuleChange change) =>
      guardedRequest(() => _remote.updateRule(rule, change));
}
