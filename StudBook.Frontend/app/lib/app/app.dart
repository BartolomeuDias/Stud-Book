import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/desktop_only_gate.dart';
import '../features/auth/presentation/auth_strings.dart';
import '../features/auth/presentation/bloc/session_bloc.dart';
import 'di/injector.dart';
import 'router/app_router.dart';

class StudBookApp extends StatefulWidget {
  const StudBookApp({super.key, required this.theme});

  final ThemeData theme;

  @override
  State<StudBookApp> createState() => _StudBookAppState();
}

class _StudBookAppState extends State<StudBookApp> {
  late final SessionBloc _session = sl<SessionBloc>();
  late final GoRouter _router = createRouter(_session);
  bool _firstFrameLaidOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _firstFrameLaidOut = true));
  }

  @override
  void dispose() {
    _router.dispose();
    _session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      excluding: !_firstFrameLaidOut,
      child: BlocProvider.value(
        value: _session,
        child: MaterialApp.router(
          title: AuthStrings.brand,
          debugShowCheckedModeBanner: false,
          theme: widget.theme,
          routerConfig: _router,
          builder: (context, child) => DesktopOnlyGate(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
