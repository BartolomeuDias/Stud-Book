import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme_context.dart';
import '../../core/theme/tokens/app_dimens.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/brand_mark.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/auth_strings.dart';
import '../../features/auth/presentation/bloc/session_bloc.dart';
import '../router/app_routes.dart';
import 'navigation_destinations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final user = context.select((SessionBloc bloc) => bloc.state.user);
    final location = GoRouterState.of(context).uri.path;
    final destinations = NavigationDestinations.forRole(user?.role ?? UserRole.client);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SideNavigation(user: user, destinations: destinations, location: location),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({required this.user, required this.destinations, required this.location});

  final User? user;
  final List<NavDestination> destinations;
  final String location;

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    final available = destinations.where((item) => item.path != null).toList();
    final upcoming = destinations.where((item) => item.path == null).toList();
    return Container(
      width: nav.width,
      padding: nav.padding,
      decoration: BoxDecoration(
        color: nav.background,
        border: Border(right: BorderSide(color: nav.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: nav.itemSpacing,
        children: [
          Padding(
            padding: nav.brandPadding,
            child: Row(
              spacing: AppSpacing.s10,
              children: [
                const BrandMark(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AuthStrings.brand, style: nav.brandTitleStyle),
                    Text(AuthStrings.ranch, style: nav.brandSubtitleStyle),
                  ],
                ),
              ],
            ),
          ),
          for (final item in available)
            _NavItem(
              destination: item,
              selected: location.startsWith(item.path!),
              onTap: () => context.go(item.path!),
            ),
          if (upcoming.isNotEmpty) ...[
            Padding(
              padding: nav.sectionLabelPadding,
              child: Text(
                NavigationDestinations.upcomingLabel.toUpperCase(),
                style: nav.sectionLabelStyle,
              ),
            ),
            for (final item in upcoming) _NavItem(destination: item, selected: false),
          ],
          const Spacer(),
          if (user != null) _UserFooter(user: user!),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected, this.onTap});

  final NavDestination destination;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    final enabled = onTap != null;
    final foreground = selected
        ? nav.itemSelectedForeground
        : enabled
        ? nav.itemForeground
        : nav.itemDisabledForeground;
    final style = (selected ? nav.itemSelectedTextStyle : nav.itemTextStyle).copyWith(
      color: foreground,
    );
    return Semantics(
      selected: selected,
      button: enabled,
      child: Material(
        color: selected ? nav.itemSelectedBackground : Colors.transparent,
        borderRadius: nav.itemRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: nav.itemRadius,
          hoverColor: nav.itemHoverBackground,
          mouseCursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Container(
            height: nav.itemHeight,
            padding: nav.itemPadding,
            child: Row(
              spacing: nav.itemIconGap,
              children: [
                Icon(destination.icon, size: AppSizes.icon, color: foreground),
                Expanded(child: Text(destination.label, style: style)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserFooter extends StatelessWidget {
  const _UserFooter({required this.user});

  static final _letter = RegExp(r'\p{L}', unicode: true);

  final User user;

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    final avatarColors = context.colors;
    final initials = user.displayName
        .split(' ')
        .where((part) => part.isNotEmpty && _letter.hasMatch(part[0]))
        .take(NavigationDestinations.initialsCount)
        .map((part) => part[0].toUpperCase())
        .join();
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.s16, left: AppSpacing.s8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: nav.borderColor)),
      ),
      child: Row(
        spacing: AppSpacing.s10,
        children: [
          CircleAvatar(
            radius: AppSizes.avatar / 2,
            backgroundColor: avatarColors.secondary,
            foregroundColor: avatarColors.onSecondary,
            child: Text(
              initials,
              style: context.text.labelLarge?.copyWith(color: avatarColors.onSecondary),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: context.text.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(AuthStrings.roleLabel(user.role), style: nav.brandSubtitleStyle),
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.logout,
            tooltip: AuthStrings.signOut,
            onPressed: () {
              context.read<SessionBloc>().add(const SessionLogoutRequested());
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
