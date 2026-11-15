import 'package:flutter/material.dart';

import '../theme/extensions/status_colors.dart';
import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaces;
    return Container(
      padding: padding ?? surfaces.cardPadding,
      decoration: BoxDecoration(
        color: surfaces.cardBackground,
        borderRadius: surfaces.cardRadius,
        border: Border.all(color: surfaces.cardBorderColor),
      ),
      child: child,
    );
  }
}

class AppLedgerRule extends StatelessWidget {
  const AppLedgerRule({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaces;
    final line = BorderSide(color: surfaces.ledgerRuleColor, width: AppStroke.hairline);
    return Container(
      height: surfaces.ledgerRuleWidth,
      decoration: BoxDecoration(
        border: Border(top: line, bottom: line),
      ),
    );
  }
}

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.overline,
    this.subtitle,
    this.subtitleMono = false,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String? overline;
  final String? subtitle;
  final bool subtitleMono;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = subtitleMono
        ? context.textStyles.mono
        : context.text.bodyLarge?.copyWith(color: context.colors.onSurfaceVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s24,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: AppSpacing.s24,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s8,
                children: [
                  ?leading,
                  if (overline != null)
                    Text(overline!.toUpperCase(), style: context.textStyles.overline),
                  Text(title, style: context.text.displaySmall),
                  if (subtitle != null) Text(subtitle!, style: subtitleStyle),
                ],
              ),
            ),
            if (actions.isNotEmpty)
              Wrap(spacing: AppSpacing.s12, runSpacing: AppSpacing.s12, children: actions),
          ],
        ),
        const AppLedgerRule(),
      ],
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({super.key, required this.title, this.mark, this.trailing});

  final String title;
  final String? mark;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: AppSpacing.s16,
        children: [
          if (mark != null) Text(mark!, style: context.textStyles.sectionMark),
          Expanded(child: Text(title, style: context.text.titleLarge)),
          ?trailing,
        ],
      ),
    );
  }
}

class AppBanner extends StatelessWidget {
  const AppBanner({super.key, required this.tone, required this.title, this.message, this.action});

  final AppTone tone;
  final String title;
  final String? message;
  final Widget? action;

  IconData get _icon => switch (tone) {
    AppTone.error => Icons.error_outline,
    AppTone.warning => Icons.warning_amber_outlined,
    AppTone.success => Icons.check_circle_outline,
    _ => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaces;
    final colors = context.status.of(tone);
    final text = context.text.bodyMedium?.copyWith(color: colors.onContainer);
    return Container(
      padding: surfaces.bannerPadding,
      decoration: BoxDecoration(
        color: colors.container,
        borderRadius: surfaces.bannerRadius,
        border: tone == AppTone.error ? Border.all(color: colors.strong) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s12,
        children: [
          Icon(_icon, size: surfaces.bannerIconSize, color: colors.onContainer),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s4,
              children: [
                Text(title, style: text?.copyWith(fontWeight: FontWeight.w600)),
                if (message != null) Text(message!, style: text),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class AppKeyValue extends StatelessWidget {
  const AppKeyValue({super.key, required this.label, required this.value, this.mono = false});

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s4,
      children: [
        Text(label, style: context.text.bodySmall),
        Text(value, style: mono ? context.textStyles.monoField : context.text.bodyMedium),
      ],
    );
  }
}

class AppBreadcrumb {
  const AppBreadcrumb({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class AppBreadcrumbs extends StatelessWidget {
  const AppBreadcrumbs({super.key, required this.items});

  final List<AppBreadcrumb> items;

  @override
  Widget build(BuildContext context) {
    final base = context.text.bodyMedium;
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;
      if (i > 0) {
        children.add(Text('/', style: base?.copyWith(color: context.colors.outline)));
      }
      children.add(
        isLast || item.onTap == null
            ? Text(item.label, style: base?.copyWith(fontWeight: FontWeight.w600))
            : MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: item.onTap,
                  child: Text(item.label, style: base?.copyWith(color: context.colors.primary)),
                ),
              ),
      );
    }
    return Wrap(
      spacing: AppSpacing.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
