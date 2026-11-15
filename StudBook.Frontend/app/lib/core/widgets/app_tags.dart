import 'package:flutter/material.dart';

import '../theme/extensions/status_colors.dart';
import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';

class AppTag extends StatelessWidget {
  const AppTag({super.key, required this.label, required this.tone});

  final String label;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = context.tags;
    final colors = context.status.of(tone);
    return Container(
      height: theme.tagHeight,
      padding: theme.tagPadding,
      decoration: BoxDecoration(color: colors.container, borderRadius: theme.tagRadius),
      child: Align(
        widthFactor: 1,
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: theme.tagTextStyle.copyWith(color: colors.onContainer),
        ),
      ),
    );
  }
}

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = context.tags;
    final colors = context.status.of(tone);
    return Container(
      height: theme.badgeHeight,
      padding: theme.badgePadding,
      decoration: BoxDecoration(
        color: colors.container,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.dotGap,
        children: [
          Container(
            width: theme.dotSize,
            height: theme.dotSize,
            decoration: BoxDecoration(color: colors.onContainer, shape: BoxShape.circle),
          ),
          Text(label, style: theme.badgeTextStyle.copyWith(color: colors.onContainer)),
        ],
      ),
    );
  }
}

class AppCountPill extends StatelessWidget {
  const AppCountPill({super.key, required this.count, this.selected = false});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = context.tags;
    final colors = context.status.of(selected ? AppTone.primary : AppTone.neutral);
    return Container(
      padding: theme.countPadding,
      decoration: BoxDecoration(
        color: colors.container,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text('$count', style: theme.countTextStyle.copyWith(color: colors.onContainer)),
    );
  }
}
