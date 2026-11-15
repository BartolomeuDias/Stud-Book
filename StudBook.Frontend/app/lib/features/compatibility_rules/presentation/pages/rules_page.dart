import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/extensions/status_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/tokens/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../../../core/widgets/app_table.dart';
import '../../domain/entities/compatibility_rule.dart';
import '../bloc/rules_bloc.dart';
import '../rules_strings.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RulesBloc, RulesState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        showAppSnackBar(context, notice.failure?.message ?? RulesStrings.saved(notice.savedCode!));
      },
      builder: (context, state) {
        final hasDrafts = state.rules.any((rule) => rule.source == RuleSource.teamDraft);
        return AppPage(
          children: [
            const AppPageHeader(
              overline: RulesStrings.overline,
              title: RulesStrings.title,
              subtitle: RulesStrings.subtitle,
            ),
            if (state.status.isLoading)
              const AppLoadingView()
            else if (state.status.isFailure)
              AppErrorView(
                message: state.failure!.message,
                onRetry: () => context.read<RulesBloc>().add(const RulesRequested()),
              )
            else if (state.rules.isEmpty)
              const AppEmptyView(
                icon: Icons.rule_outlined,
                title: RulesStrings.emptyTitle,
                message: RulesStrings.emptyMessage,
              )
            else ...[
              if (hasDrafts)
                const AppBanner(
                  tone: AppTone.warning,
                  title: RulesStrings.draftBanner,
                  message: RulesStrings.draftBannerMessage,
                ),
              _RulesTable(state: state),
            ],
          ],
        );
      },
    );
  }
}

class _RulesTable extends StatelessWidget {
  const _RulesTable({required this.state});

  static const _ruleFlex = 5;
  static const _denialFlex = 4;
  static const _thresholdFlex = 2;

  final RulesState state;

  @override
  Widget build(BuildContext context) {
    return AppTable(
      columns: const [
        AppTableColumn(label: RulesStrings.columnPriority, width: AppSizes.numberFieldWidth),
        AppTableColumn(label: RulesStrings.columnRule, flex: _ruleFlex),
        AppTableColumn(label: RulesStrings.columnDenial, flex: _denialFlex),
        AppTableColumn(label: RulesStrings.columnThreshold, flex: _thresholdFlex),
        AppTableColumn(label: RulesStrings.columnSource, width: AppSizes.sourceFieldWidth),
        AppTableColumn(label: RulesStrings.columnActive, width: AppSizes.switchColumnWidth),
        AppTableColumn(label: '', width: AppSizes.rowActionsWidth),
      ],
      rows: [
        for (final rule in state.rules)
          AppTableRow(
            cells: _ruleCells(
              context,
              rule: rule,
              change: state.changeFor(rule),
              dirty: state.isDirty(rule),
              saving: state.saving.contains(rule.id),
            ),
          ),
      ],
      footer: Text(RulesStrings.summary(state.activeCount, state.rules.length)),
    );
  }
}

List<Widget> _ruleCells(
  BuildContext context, {
  required CompatibilityRule rule,
  required RuleChange change,
  required bool dirty,
  required bool saving,
}) {
  final bloc = context.read<RulesBloc>();
  void edit(RuleChange next) => bloc.add(RuleEdited(rule.id, next));
  final digits = [FilteringTextInputFormatter.digitsOnly];

  return [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: AppTextInput(
        key: ValueKey(('priority', rule)),
        semanticLabel: RulesStrings.priorityLabel,
        initialValue: '${change.priority}',
        monospace: true,
        keyboardType: TextInputType.number,
        inputFormatters: digits,
        onChanged: (value) {
          final parsed = int.tryParse(value);
          if (parsed != null) edit(change.copyWith(priority: parsed));
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s4,
        children: [
          Text(rule.code, style: context.textStyles.mono.copyWith(color: context.colors.onSurface)),
          Text(rule.description, style: context.text.bodyMedium),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
      child: Text(
        rule.denialMessage,
        style: context.text.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
      ),
    ),
    rule.usesThreshold
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s4,
            children: [
              SizedBox(
                width: AppSizes.numberFieldWidth,
                child: AppTextInput(
                  key: ValueKey(('threshold', rule)),
                  semanticLabel: RulesStrings.thresholdLabel,
                  initialValue: change.threshold?.toString() ?? '',
                  monospace: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: digits,
                  onChanged: (value) => edit(change.copyWith(threshold: () => int.tryParse(value))),
                ),
              ),
              Text(rule.thresholdUnit!, style: context.text.bodySmall),
            ],
          )
        : Text(RulesStrings.notUsed, style: context.text.bodySmall),
    AppDropdownInput<RuleSource>(
      value: change.source,
      items: [
        for (final source in RuleSource.values)
          AppDropdownItem(value: source, label: RulesStrings.source(source)),
      ],
      onChanged: (value) {
        if (value != null) edit(change.copyWith(source: value));
      },
    ),
    Switch(
      value: change.isActive,
      onChanged: (value) => edit(change.copyWith(isActive: value)),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: AppButton.small(
        label: RulesStrings.save,
        isLoading: saving,
        onPressed: dirty ? () => bloc.add(RuleSaveRequested(rule.id)) : null,
      ),
    ),
  ];
}
