import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/extensions/status_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/tokens/app_dimens.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../../auth/presentation/bloc/session_bloc.dart';

abstract final class ClientHomeStrings {
  static const overline = 'Client account';
  static const subtitle = 'Book covers for your mares and follow every request from one place.';
  static const comingTitle = 'Breeding requests are on the way';
  static const comingMessage =
      'Requests, the queue and invoices arrive in the next iterations. Your account is ready for them.';
  static const nextTitle = 'What you will be able to do';
  static const steps = [
    (
      Icons.event_available_outlined,
      'Request a cover',
      'Pick a stallion and a date for your mare.',
    ),
    (Icons.fact_check_outlined, 'See the pair check', 'Know right away if the pair is allowed.'),
    (Icons.receipt_long_outlined, 'Pay invoices', 'Every service, priced and tracked.'),
  ];

  static String greeting(String name) => 'Welcome, $name';
}

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((SessionBloc bloc) => bloc.state.user);
    return AppPage(
      children: [
        AppPageHeader(
          overline: ClientHomeStrings.overline,
          title: ClientHomeStrings.greeting(user?.displayName ?? ''),
          subtitle: ClientHomeStrings.subtitle,
        ),
        const AppBanner(
          tone: AppTone.info,
          title: ClientHomeStrings.comingTitle,
          message: ClientHomeStrings.comingMessage,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.surfaces.blockGap,
          children: [
            const AppSectionHeader(mark: '§1', title: ClientHomeStrings.nextTitle),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.surfaces.blockGap,
              children: [
                for (final (icon, title, message) in ClientHomeStrings.steps)
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.s12,
                        children: [
                          Icon(icon, color: context.colors.primary, size: AppSizes.iconLarge),
                          Text(title, style: context.text.titleMedium),
                          Text(
                            message,
                            style: context.text.bodyMedium?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
