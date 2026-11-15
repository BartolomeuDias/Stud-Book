import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';
import 'brand_mark.dart';

abstract final class DesktopOnlyStrings {
  static const title = 'Mobile isn’t supported yet';
  static const message =
      'Stud Book currently works on desktop screens. Open it on a computer, or widen the browser window.';
  static const brand = 'Stud Book';
}

class DesktopOnlyGate extends StatelessWidget {
  const DesktopOnlyGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.minSupportedWidth) return child;
    return const _MobilePlaceholder();
  }
}

class _MobilePlaceholder extends StatelessWidget {
  const _MobilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSizes.loginCardWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.s16,
                children: [
                  const BrandMark(size: AppSizes.iconHero),
                  Text(DesktopOnlyStrings.brand.toUpperCase(), style: context.textStyles.overline),
                  Text(
                    DesktopOnlyStrings.title,
                    style: context.text.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    DesktopOnlyStrings.message,
                    style: context.text.bodyLarge?.copyWith(color: context.colors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
