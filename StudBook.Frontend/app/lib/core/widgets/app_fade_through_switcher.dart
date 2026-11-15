import 'package:flutter/material.dart';

import '../theme/tokens/app_dimens.dart';

class AppFadeThroughSwitcher extends StatelessWidget {
  const AppFadeThroughSwitcher({super.key, required this.child});

  final Widget child;

  static final _opacity = CurveTween(
    curve: const Interval(AppMotion.fadeThroughSplit, 1, curve: AppMotion.enter),
  );

  static final _offset = Tween<Offset>(
    begin: const Offset(0, AppMotion.pageSlideFraction),
    end: Offset.zero,
  ).chain(CurveTween(curve: const Interval(AppMotion.fadeThroughSplit, 1, curve: AppMotion.enter)));

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.pageEnter,
      reverseDuration: AppDurations.pageExit,
      layoutBuilder: (current, previous) =>
          Stack(alignment: Alignment.topCenter, children: [...previous, ?current]),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation.drive(_opacity),
        child: SlideTransition(position: animation.drive(_offset), child: child),
      ),
      child: child,
    );
  }
}
