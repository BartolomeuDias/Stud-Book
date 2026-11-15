import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'app/di/injector.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/tokens/app_dimens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _reportErrors();
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  final theme = AppTheme.light();
  await Future.wait([configureDependencies(), _preloadFonts()]);
  runApp(StudBookApp(theme: theme));
}

void _reportErrors() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('StudBook error: ${details.exceptionAsString()}\n${details.stack}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('StudBook error: $error\n$stack');
    return true;
  };
}

Future<void> _preloadFonts() async {
  try {
    await GoogleFonts.pendingFonts().timeout(AppDurations.fontPreloadTimeout);
  } on Object {
    return;
  }
}
