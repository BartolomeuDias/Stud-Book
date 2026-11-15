import 'package:flutter/material.dart';

@immutable
class AppTagTheme extends ThemeExtension<AppTagTheme> {
  const AppTagTheme({
    required this.tagHeight,
    required this.tagPadding,
    required this.tagRadius,
    required this.tagTextStyle,
    required this.badgeHeight,
    required this.badgePadding,
    required this.badgeTextStyle,
    required this.dotSize,
    required this.dotGap,
    required this.resultHeight,
    required this.resultPadding,
    required this.resultTextStyle,
    required this.resultIconSize,
    required this.countPadding,
    required this.countTextStyle,
  });

  final double tagHeight;
  final EdgeInsets tagPadding;
  final BorderRadius tagRadius;
  final TextStyle tagTextStyle;

  final double badgeHeight;
  final EdgeInsets badgePadding;
  final TextStyle badgeTextStyle;
  final double dotSize;
  final double dotGap;

  final double resultHeight;
  final EdgeInsets resultPadding;
  final TextStyle resultTextStyle;
  final double resultIconSize;

  final EdgeInsets countPadding;
  final TextStyle countTextStyle;

  @override
  AppTagTheme copyWith({
    double? tagHeight,
    EdgeInsets? tagPadding,
    BorderRadius? tagRadius,
    TextStyle? tagTextStyle,
    double? badgeHeight,
    EdgeInsets? badgePadding,
    TextStyle? badgeTextStyle,
    double? dotSize,
    double? dotGap,
    double? resultHeight,
    EdgeInsets? resultPadding,
    TextStyle? resultTextStyle,
    double? resultIconSize,
    EdgeInsets? countPadding,
    TextStyle? countTextStyle,
  }) => AppTagTheme(
    tagHeight: tagHeight ?? this.tagHeight,
    tagPadding: tagPadding ?? this.tagPadding,
    tagRadius: tagRadius ?? this.tagRadius,
    tagTextStyle: tagTextStyle ?? this.tagTextStyle,
    badgeHeight: badgeHeight ?? this.badgeHeight,
    badgePadding: badgePadding ?? this.badgePadding,
    badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
    dotSize: dotSize ?? this.dotSize,
    dotGap: dotGap ?? this.dotGap,
    resultHeight: resultHeight ?? this.resultHeight,
    resultPadding: resultPadding ?? this.resultPadding,
    resultTextStyle: resultTextStyle ?? this.resultTextStyle,
    resultIconSize: resultIconSize ?? this.resultIconSize,
    countPadding: countPadding ?? this.countPadding,
    countTextStyle: countTextStyle ?? this.countTextStyle,
  );

  @override
  AppTagTheme lerp(covariant AppTagTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
