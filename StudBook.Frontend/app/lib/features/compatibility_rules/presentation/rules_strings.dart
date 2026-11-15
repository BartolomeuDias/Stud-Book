import '../domain/entities/compatibility_rule.dart';

abstract final class RulesStrings {
  static const title = 'Compatibility rules';
  static const overline = 'Pair check · Rule table';
  static const subtitle =
      'One table of pair rules agreed with the vet. Every pair check runs through these rules in priority order.';
  static const columnPriority = 'Priority';
  static const columnRule = 'Rule';
  static const columnDenial = 'Message when blocked';
  static const columnThreshold = 'Threshold';
  static const columnSource = 'Source';
  static const columnActive = 'Active';
  static const priorityLabel = 'Priority';
  static const thresholdLabel = 'Threshold';
  static const notUsed = 'Not used';
  static const save = 'Save';
  static const emptyTitle = 'No rules yet';
  static const emptyMessage = 'Rules appear here once they are added to the rule table.';
  static const draftBanner = 'Team draft rules still need vet confirmation';
  static const draftBannerMessage =
      'Switch a rule’s source to “Confirmed” once the vet has signed it off.';

  static String saved(String code) => 'Saved $code';

  static String summary(int active, int total) => '$active of $total rules active';

  static String source(RuleSource value) => switch (value) {
    RuleSource.teamDraft => 'Team draft',
    RuleSource.customerConfirmed => 'Confirmed',
  };
}
