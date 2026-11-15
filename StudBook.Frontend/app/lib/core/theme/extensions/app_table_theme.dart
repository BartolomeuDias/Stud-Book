import 'package:flutter/material.dart';

@immutable
class AppTableTheme extends ThemeExtension<AppTableTheme> {
  const AppTableTheme({
    required this.background,
    required this.borderColor,
    required this.radius,
    required this.headerHeight,
    required this.headerBackground,
    required this.headerTextStyle,
    required this.rowMinHeight,
    required this.rowHoverColor,
    required this.rowPadding,
    required this.cellGap,
    required this.cellTextStyle,
    required this.footerPadding,
    required this.footerTextStyle,
  });

  final Color background;
  final Color borderColor;
  final BorderRadius radius;

  final double headerHeight;
  final Color headerBackground;
  final TextStyle headerTextStyle;

  final double rowMinHeight;
  final Color rowHoverColor;

  final EdgeInsets rowPadding;

  final double cellGap;
  final TextStyle cellTextStyle;

  final EdgeInsets footerPadding;
  final TextStyle footerTextStyle;

  @override
  AppTableTheme copyWith({
    Color? background,
    Color? borderColor,
    BorderRadius? radius,
    double? headerHeight,
    Color? headerBackground,
    TextStyle? headerTextStyle,
    double? rowMinHeight,
    Color? rowHoverColor,
    EdgeInsets? rowPadding,
    double? cellGap,
    TextStyle? cellTextStyle,
    EdgeInsets? footerPadding,
    TextStyle? footerTextStyle,
  }) => AppTableTheme(
    background: background ?? this.background,
    borderColor: borderColor ?? this.borderColor,
    radius: radius ?? this.radius,
    headerHeight: headerHeight ?? this.headerHeight,
    headerBackground: headerBackground ?? this.headerBackground,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    rowMinHeight: rowMinHeight ?? this.rowMinHeight,
    rowHoverColor: rowHoverColor ?? this.rowHoverColor,
    rowPadding: rowPadding ?? this.rowPadding,
    cellGap: cellGap ?? this.cellGap,
    cellTextStyle: cellTextStyle ?? this.cellTextStyle,
    footerPadding: footerPadding ?? this.footerPadding,
    footerTextStyle: footerTextStyle ?? this.footerTextStyle,
  );

  @override
  AppTableTheme lerp(covariant AppTableTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
