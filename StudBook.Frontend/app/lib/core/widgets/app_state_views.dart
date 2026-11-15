import 'package:flutter/material.dart';

import '../theme/extensions/status_colors.dart';
import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';
import 'app_button.dart';
import 'app_surfaces.dart';

abstract final class StateViewStrings {
  static const retry = 'Try again';
  static const errorTitle = 'Something went wrong';
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.s48),
        child: SizedBox.square(
          dimension: AppSizes.progress,
          child: CircularProgressIndicator(strokeWidth: AppSizes.progressStroke),
        ),
      ),
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppBanner(
      tone: AppTone.error,
      title: StateViewStrings.errorTitle,
      message: message,
      action: onRetry == null
          ? null
          : AppButton.small(label: StateViewStrings.retry, onPressed: onRetry),
    );
  }
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s48),
      child: Column(
        spacing: AppSpacing.s12,
        children: [
          Icon(icon, size: AppSizes.iconHero, color: context.colors.outline),
          Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
          if (message != null)
            Text(
              message!,
              style: context.text.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          if (action != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: action,
            ),
        ],
      ),
    );
  }
}
