import '../../domain/entities/compatibility_rule.dart';

abstract final class CompatibilityRuleModel {
  static const _id = 'id';
  static const _code = 'code';
  static const _description = 'description';
  static const _denialMessage = 'denialMessage';
  static const _isActive = 'isActive';
  static const _priority = 'priority';
  static const _threshold = 'threshold';
  static const _thresholdUnit = 'thresholdUnit';
  static const _source = 'source';
  static const _sources = {
    'TeamDraft': RuleSource.teamDraft,
    'CustomerConfirmed': RuleSource.customerConfirmed,
  };

  static CompatibilityRule fromJson(Map<String, dynamic> json) => CompatibilityRule(
    id: json[_id] as int,
    code: json[_code] as String,
    description: json[_description] as String? ?? '',
    denialMessage: json[_denialMessage] as String? ?? '',
    isActive: json[_isActive] as bool,
    priority: json[_priority] as int,
    threshold: json[_threshold] as int?,
    thresholdUnit: json[_thresholdUnit] as String?,
    source:
        _sources[json[_source]] ?? (throw FormatException('Unknown rule source: ${json[_source]}')),
  );

  static Map<String, dynamic> changeToJson(CompatibilityRule rule, RuleChange change) => {
    _isActive: change.isActive,
    _priority: change.priority,
    _threshold: rule.usesThreshold ? change.threshold : null,
    _source: _sources.entries.firstWhere((entry) => entry.value == change.source).key,
  };
}
