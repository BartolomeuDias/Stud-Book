import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/extensions/status_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/tokens/app_dimens.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../auth_strings.dart';
import '../bloc/session_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.loginCardWidth),
            child: BlocBuilder<SessionBloc, SessionState>(
              builder: (context, state) {
                final busy = state.status == SessionStatus.authenticating;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s24,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.s8,
                      children: [
                        Text(AuthStrings.title, style: context.text.displaySmall),
                        Text(
                          AuthStrings.subtitle,
                          style: context.text.bodyLarge?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const AppLedgerRule(),
                    if (state.failure != null)
                      AppBanner(
                        tone: AppTone.error,
                        title: AuthStrings.failedTitle,
                        message: state.failure!.message,
                      ),
                    _RoleOption(
                      icon: Icons.badge_outlined,
                      title: AuthStrings.staffTitle,
                      description: AuthStrings.staffDescription,
                      loading: busy && state.pendingEmail == AuthStrings.staffEmail,
                      onTap: busy ? null : () => _login(context, AuthStrings.staffEmail),
                    ),
                    _RoleOption(
                      icon: Icons.person_outline,
                      title: AuthStrings.clientTitle,
                      description: AuthStrings.clientDescription,
                      loading: busy && state.pendingEmail == AuthStrings.clientEmail,
                      onTap: busy ? null : () => _login(context, AuthStrings.clientEmail),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, String email) =>
      context.read<SessionBloc>().add(SessionLoginRequested(email));
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaces;
    final tone = context.status.of(AppTone.primary);
    return Material(
      color: surfaces.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: surfaces.cardRadius,
        side: BorderSide(color: surfaces.cardBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        hoverColor: context.colors.surface,
        child: Padding(
          padding: surfaces.cardPadding,
          child: Row(
            spacing: AppSpacing.s16,
            children: [
              Container(
                width: AppSizes.control,
                height: AppSizes.control,
                decoration: BoxDecoration(color: tone.container, shape: BoxShape.circle),
                child: Icon(icon, color: tone.onContainer),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s4,
                  children: [
                    Text(title, style: context.text.titleMedium),
                    Text(
                      description,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (loading)
                const SizedBox.square(
                  dimension: AppSizes.progress,
                  child: CircularProgressIndicator(strokeWidth: AppSizes.progressStroke),
                )
              else
                Icon(Icons.arrow_forward, color: context.colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
