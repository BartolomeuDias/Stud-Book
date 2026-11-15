import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/user.dart';
import '../router/app_routes.dart';

class NavDestination {
  const NavDestination({required this.label, required this.icon, this.path});

  final String label;
  final IconData icon;
  final String? path;
}

abstract final class NavigationDestinations {
  static const upcomingLabel = 'Coming next';
  static const initialsCount = 2;

  static const _staff = [
    NavDestination(label: 'Registry', icon: Icons.menu_book_outlined, path: AppRoutes.registry),
    NavDestination(label: 'Compatibility rules', icon: Icons.rule_outlined, path: AppRoutes.rules),
    NavDestination(label: 'Pair check', icon: Icons.join_inner),
    NavDestination(label: 'Movements', icon: Icons.swap_horiz),
    NavDestination(label: 'Queue & calendar', icon: Icons.calendar_month_outlined),
    NavDestination(label: 'Requests', icon: Icons.assignment_outlined),
    NavDestination(label: 'Invoices', icon: Icons.receipt_long_outlined),
    NavDestination(label: 'Reports', icon: Icons.bar_chart_outlined),
  ];

  static const _client = [
    NavDestination(label: 'Home', icon: Icons.home_outlined, path: AppRoutes.client),
    NavDestination(label: 'My requests', icon: Icons.assignment_outlined),
    NavDestination(label: 'Invoices', icon: Icons.receipt_long_outlined),
  ];

  static List<NavDestination> forRole(UserRole role) => switch (role) {
    UserRole.ranchStaff => _staff,
    UserRole.client => _client,
  };

  static String homeFor(UserRole role) => forRole(role).first.path!;
}
