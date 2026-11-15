import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';

enum AppButtonVariant { primary, secondary, tertiary, destructive, small }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.tertiary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.tertiary;

  const AppButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.destructive;

  const AppButton.small({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.small;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final styles = context.buttons;
    final style = switch (variant) {
      AppButtonVariant.primary => styles.primary,
      AppButtonVariant.secondary => styles.secondary,
      AppButtonVariant.tertiary => styles.tertiary,
      AppButtonVariant.destructive => styles.destructive,
      AppButtonVariant.small => styles.secondarySmall,
    };
    final leading = isLoading
        ? SizedBox.square(
            dimension: styles.iconSize,
            child: Builder(
              builder: (context) => CircularProgressIndicator(
                strokeWidth: AppSizes.progressStroke,
                color: IconTheme.of(context).color,
              ),
            ),
          )
        : icon == null
        ? null
        : Icon(icon, size: styles.iconSize);

    return TextButton(
      style: style,
      onPressed: isLoading ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: styles.iconGap,
        children: [?leading, Text(label)],
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.outlined = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final styles = context.buttons;
    return Tooltip(
      message: tooltip,
      child: TextButton(
        style: outlined ? styles.iconOutlined : styles.icon,
        onPressed: onPressed,
        child: Icon(icon, size: AppSizes.icon, semanticLabel: tooltip),
      ),
    );
  }
}
