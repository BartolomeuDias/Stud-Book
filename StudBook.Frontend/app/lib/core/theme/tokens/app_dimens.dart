import 'package:flutter/animation.dart';

abstract final class AppSpacing {
  static const double s4 = 4;

  static const double s6 = 6;

  static const double s8 = 8;
  static const double s10 = 10;

  static const double s12 = 12;

  static const double s16 = 16;
  static const double s20 = 20;

  static const double s24 = 24;

  static const double s32 = 32;
  static const double s40 = 40;

  static const double s48 = 48;

  static const double s64 = 64;
}

abstract final class AppRadius {
  static const double r4 = 4;

  static const double r6 = 6;

  static const double r8 = 8;

  static const double r12 = 12;

  static const double full = 999;
}

abstract final class AppStroke {
  static const double hairline = 1;

  static const double focus = 2;

  static const double ledger = 3;
}

abstract final class AppSizes {
  static const double control = 44;

  static const double controlSmall = 36;

  static const double menuItem = 40;
  static const double menuMaxHeight = 320;

  static const double icon = 20;
  static const double iconSmall = 18;
  static const double iconLarge = 28;
  static const double iconHero = 48;

  static const double tag = 24;
  static const double badge = 24;
  static const double resultBadge = 28;
  static const double badgeDot = 6;

  static const double avatar = 36;
  static const double ruleIcon = 32;

  static const double tableHeader = 44;
  static const double tableRow = 64;
  static const double rowActionsWidth = 88;
  static const double switchColumnWidth = 72;

  static const double sideNavWidth = 248;
  static const double contentMaxWidth = 1440;
  static const double formMaxWidth = 880;
  static const double loginCardWidth = 440;
  static const double dialogMaxWidth = 480;
  static const double pedigreeCellMinWidth = 200;
  static const double numberFieldWidth = 96;
  static const double sourceFieldWidth = 200;
  static const double searchFieldMaxWidth = 420;
  static const double progressStroke = 2;
  static const double progress = 20;
}

abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 1024;

  static const double minSupportedWidth = expanded;
}

abstract final class AppMotion {
  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;
  static const pageSlideFraction = 0.012;
  static const fadeThroughSplit = 0.4;
  static const menuScaleFrom = 0.94;
  static const menuDrop = 6.0;
  static const shakeCycles = 3;
  static const shakeAmplitude = 6.0;
  static const scrollAlignment = 0.25;
  static const scrollCurve = Curves.easeInOutCubic;
}

abstract final class AppDurations {
  static const hover = Duration(milliseconds: 120);
  static const snackBar = Duration(seconds: 4);
  static const fontPreloadTimeout = Duration(seconds: 4);
  static const pageEnter = Duration(milliseconds: 450);
  static const pageExit = Duration(milliseconds: 200);
  static const tabIndicator = Duration(milliseconds: 250);
  static const menuArrow = Duration(milliseconds: 180);
  static const menuOpen = Duration(milliseconds: 240);
  static const menuClose = Duration(milliseconds: 180);
  static const shake = Duration(milliseconds: 520);
  static const scrollToField = Duration(milliseconds: 550);
}

abstract final class AppElevation {
  static const double level1Blur = 16;
  static const double level1OffsetY = 4;
}

abstract final class AppLayout {
  static const int formColumns = 2;

  static const int detailColumns = 3;

  static const double capsTracking = 0.06;
  static const double overlineTracking = 0.08;
  static const double buttonTracking = 0.01;
  static const double displayTracking = -0.005;

  static const double disabledOpacity = 0.55;
}
