import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:studbook_app/app/router/app_page_transition.dart';
import 'package:studbook_app/core/theme/tokens/app_dimens.dart';

double _opacity(WidgetTester tester, String text) {
  final finder = find.text(text);
  if (finder.evaluate().isEmpty) return 0;
  var value = 1.0;
  for (final fade in tester.widgetList<FadeTransition>(
    find.ancestor(of: finder, matching: find.byType(FadeTransition)),
  )) {
    value *= fade.opacity.value;
  }
  return value;
}

void main() {
  testWidgets('screens fade through without overlapping', (tester) async {
    final router = GoRouter(
      initialLocation: '/a',
      routes: [
        GoRoute(
          path: '/a',
          pageBuilder: (context, state) => AppTransitionPage(
            state: state,
            child: const Center(child: Text('Registry')),
          ),
        ),
        GoRoute(
          path: '/b',
          pageBuilder: (context, state) => AppTransitionPage(
            state: state,
            child: const Center(child: Text('Rules')),
          ),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    router.go('/b');
    await tester.pump();
    const step = Duration(milliseconds: 10);
    final frames = AppDurations.pageEnter.inMilliseconds ~/ step.inMilliseconds;
    const visible = 0.05;
    for (var i = 0; i < frames; i++) {
      await tester.pump(step);
      final both = _opacity(tester, 'Registry') > visible && _opacity(tester, 'Rules') > visible;
      expect(both, isFalse, reason: 'both screens visible at ${(i + 1) * 10} ms');
    }
    await tester.pumpAndSettle();
    expect(_opacity(tester, 'Rules'), 1);
  });
}
