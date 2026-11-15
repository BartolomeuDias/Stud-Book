import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/compatibility_rule.dart';
import '../models/compatibility_rule_model.dart';

class CompatibilityRuleRemoteDataSource {
  const CompatibilityRuleRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<CompatibilityRule>> getRules() async {
    final json = await _client.get(ApiPaths.compatibilityRules) as List<dynamic>;
    return [for (final item in json) CompatibilityRuleModel.fromJson(item as Map<String, dynamic>)];
  }

  Future<CompatibilityRule> updateRule(CompatibilityRule rule, RuleChange change) async {
    final json = await _client.patch(
      ApiPaths.compatibilityRule(rule.id),
      body: CompatibilityRuleModel.changeToJson(rule, change),
    );
    return CompatibilityRuleModel.fromJson(json as Map<String, dynamic>);
  }
}
