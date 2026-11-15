import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/tokens/app_dimens.dart';

class AppTransitionPage<T> extends CustomTransitionPage<T> {
  AppTransitionPage({required GoRouterState state, required Widget child})
    : super(
        key: state.pageKey,
        transitionDuration: AppDurations.pageEnter,
        reverseTransitionDuration: AppDurations.pageExit,
        child: _OpaquePage(child: child),
        transitionsBuilder: buildTransition,
      );

  static final _enterOpacity = CurveTween(
    curve: const Interval(AppMotion.fadeThroughSplit, 1, curve: AppMotion.enter),
  );
  static final _enterOffset = Tween<Offset>(
    begin: const Offset(0, AppMotion.pageSlideFraction),
    end: Offset.zero,
  ).chain(CurveTween(curve: const Interval(AppMotion.fadeThroughSplit, 1, curve: AppMotion.enter)));
  static final _coveredOpacity = Tween<double>(
    begin: 1,
    end: 0,
  ).chain(CurveTween(curve: const Interval(0, AppMotion.fadeThroughSplit, curve: AppMotion.exit)));

  static Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final exiting = animation.status == AnimationStatus.reverse;
    return FadeTransition(
      opacity: secondaryAnimation.drive(_coveredOpacity),
      child: exiting
          ? FadeTransition(opacity: animation, child: child)
          : FadeTransition(
              opacity: animation.drive(_enterOpacity),
              child: SlideTransition(position: animation.drive(_enterOffset), child: child),
            ),
    );
  }
}

class _OpaquePage extends StatelessWidget {
  const _OpaquePage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: Theme.of(context).colorScheme.surface, child: child);
}
