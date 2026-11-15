import 'package:equatable/equatable.dart';

enum RuleSource { teamDraft, customerConfirmed }

class CompatibilityRule extends Equatable {
  const CompatibilityRule({
    required this.id,
    required this.code,
    required this.description,
    required this.denialMessage,
    required this.isActive,
    required this.priority,
    required this.source,
    this.threshold,
    this.thresholdUnit,
  });

  final int id;
  final String code;
  final String description;
  final String denialMessage;
  final bool isActive;
  final int priority;
  final RuleSource source;
  final int? threshold;
  final String? thresholdUnit;

  bool get usesThreshold => thresholdUnit != null && thresholdUnit!.isNotEmpty;

  RuleChange get asChange =>
      RuleChange(isActive: isActive, priority: priority, threshold: threshold, source: source);

  @override
  List<Object?> get props => [
    id,
    code,
    description,
    denialMessage,
    isActive,
    priority,
    source,
    threshold,
    thresholdUnit,
  ];
}

class RuleChange extends Equatable {
  const RuleChange({
    required this.isActive,
    required this.priority,
    required this.source,
    this.threshold,
  });

  final bool isActive;
  final int priority;
  final RuleSource source;
  final int? threshold;

  RuleChange copyWith({
    bool? isActive,
    int? priority,
    RuleSource? source,
    int? Function()? threshold,
  }) => RuleChange(
    isActive: isActive ?? this.isActive,
    priority: priority ?? this.priority,
    source: source ?? this.source,
    threshold: threshold == null ? this.threshold : threshold(),
  );

  @override
  List<Object?> get props => [isActive, priority, source, threshold];
}
