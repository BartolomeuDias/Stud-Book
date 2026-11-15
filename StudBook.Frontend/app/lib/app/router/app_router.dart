import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/bloc/session_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/client_home/presentation/pages/client_home_page.dart';
import '../../features/compatibility_rules/presentation/bloc/rules_bloc.dart';
import '../../features/compatibility_rules/presentation/pages/rules_page.dart';
import '../../features/horses/presentation/details/bloc/horse_details_bloc.dart';
import '../../features/horses/presentation/details/pages/horse_details_page.dart';
import '../../features/horses/presentation/form/bloc/horse_form_bloc.dart';
import '../../features/horses/presentation/form/pages/horse_form_page.dart';
import '../../features/horses/presentation/registry/bloc/registry_bloc.dart';
import '../../features/horses/presentation/registry/pages/registry_page.dart';
import '../di/injector.dart';
import '../shell/app_shell.dart';
import '../shell/navigation_destinations.dart';
import 'app_page_transition.dart';
import 'app_routes.dart';

GoRouter createRouter(SessionBloc session) {
  const staffPrefixes = [AppRoutes.registry, AppRoutes.rules];

  return GoRouter(
    initialLocation: AppRoutes.root,
    refreshListenable: _StreamListenable(session.stream),
    redirect: (context, state) {
      final location = state.uri.path;
      final atLogin = location == AppRoutes.login;
      final user = session.state.user;
      if (user == null) return atLogin ? null : AppRoutes.login;
      final home = NavigationDestinations.homeFor(user.role);
      if (atLogin) return home;
      final staffOnly = staffPrefixes.any(location.startsWith);
      if (user.role == UserRole.client && staffOnly) return home;
      if (user.role == UserRole.ranchStaff && location.startsWith(AppRoutes.client)) return home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => AppTransitionPage(state: state, child: const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.root,
        redirect: (context, state) {
          final user = session.state.user;
          return user == null ? AppRoutes.login : NavigationDestinations.homeFor(user.role);
        },
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => AppTransitionPage(
          state: state,
          child: AppShell(child: child),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.registry,
            pageBuilder: (context, state) {
              final category = AppRoutes.parseCategory(
                state.uri.queryParameters[AppRoutes.categoryQuery],
              );
              return AppTransitionPage(
                state: state,
                child: BlocProvider(
                  create: (_) => sl<RegistryBloc>(param1: category)..add(const RegistryRequested()),
                  child: const RegistryPage(),
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.horseNew,
            pageBuilder: (context, state) => AppTransitionPage(
              state: state,
              child: BlocProvider(
                create: (_) => sl<HorseFormBloc>()..add(const HorseFormStarted()),
                child: const HorseFormPage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.horsePattern,
            pageBuilder: (context, state) => AppTransitionPage(
              state: state,
              child: BlocProvider(
                create: (_) =>
                    sl<HorseDetailsBloc>(param1: _horseId(state))
                      ..add(const HorseDetailsRequested()),
                child: const HorseDetailsPage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.horseEditPattern,
            pageBuilder: (context, state) => AppTransitionPage(
              state: state,
              child: BlocProvider(
                create: (_) =>
                    sl<HorseFormBloc>(param1: _horseId(state))..add(const HorseFormStarted()),
                child: const HorseFormPage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.rules,
            pageBuilder: (context, state) => AppTransitionPage(
              state: state,
              child: BlocProvider(
                create: (_) => sl<RulesBloc>()..add(const RulesRequested()),
                child: const RulesPage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.client,
            pageBuilder: (context, state) =>
                AppTransitionPage(state: state, child: const ClientHomePage()),
          ),
        ],
      ),
    ],
  );
}

int _horseId(GoRouterState state) =>
    int.tryParse(state.pathParameters[AppRoutes.horseIdParam] ?? '') ?? 0;

class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
