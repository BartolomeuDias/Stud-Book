import 'package:flutter/material.dart';

@immutable
class AppSurfaceTheme extends ThemeExtension<AppSurfaceTheme> {
  const AppSurfaceTheme({
    required this.cardBackground,
    required this.cardBorderColor,
    required this.cardRadius,
    required this.cardPadding,
    required this.ledgerRuleColor,
    required this.ledgerRuleWidth,
    required this.pagePadding,
    required this.sectionGap,
    required this.blockGap,
    required this.bannerPadding,
    required this.bannerRadius,
    required this.bannerIconSize,
    required this.menuShadow,
  });

  final Color cardBackground;
  final Color cardBorderColor;
  final BorderRadius cardRadius;
  final EdgeInsets cardPadding;

  final Color ledgerRuleColor;
  final double ledgerRuleWidth;

  final EdgeInsets pagePadding;

  final double sectionGap;

  final double blockGap;

  final EdgeInsets bannerPadding;
  final BorderRadius bannerRadius;
  final double bannerIconSize;

  final List<BoxShadow> menuShadow;

  @override
  AppSurfaceTheme copyWith({
    Color? cardBackground,
    Color? cardBorderColor,
    BorderRadius? cardRadius,
    EdgeInsets? cardPadding,
    Color? ledgerRuleColor,
    double? ledgerRuleWidth,
    EdgeInsets? pagePadding,
    double? sectionGap,
    double? blockGap,
    EdgeInsets? bannerPadding,
    BorderRadius? bannerRadius,
    double? bannerIconSize,
    List<BoxShadow>? menuShadow,
  }) => AppSurfaceTheme(
    cardBackground: cardBackground ?? this.cardBackground,
    cardBorderColor: cardBorderColor ?? this.cardBorderColor,
    cardRadius: cardRadius ?? this.cardRadius,
    cardPadding: cardPadding ?? this.cardPadding,
    ledgerRuleColor: ledgerRuleColor ?? this.ledgerRuleColor,
    ledgerRuleWidth: ledgerRuleWidth ?? this.ledgerRuleWidth,
    pagePadding: pagePadding ?? this.pagePadding,
    sectionGap: sectionGap ?? this.sectionGap,
    blockGap: blockGap ?? this.blockGap,
    bannerPadding: bannerPadding ?? this.bannerPadding,
    bannerRadius: bannerRadius ?? this.bannerRadius,
    bannerIconSize: bannerIconSize ?? this.bannerIconSize,
    menuShadow: menuShadow ?? this.menuShadow,
  );

  @override
  AppSurfaceTheme lerp(covariant AppSurfaceTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
