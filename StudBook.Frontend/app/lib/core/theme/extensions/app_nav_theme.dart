import 'package:flutter/material.dart';

@immutable
class AppNavTheme extends ThemeExtension<AppNavTheme> {
  const AppNavTheme({
    required this.width,
    required this.background,
    required this.borderColor,
    required this.padding,
    required this.brandPadding,
    required this.brandTitleStyle,
    required this.brandSubtitleStyle,
    required this.itemHeight,
    required this.itemRadius,
    required this.itemPadding,
    required this.itemSpacing,
    required this.itemIconGap,
    required this.itemForeground,
    required this.itemDisabledForeground,
    required this.itemHoverBackground,
    required this.itemSelectedBackground,
    required this.itemSelectedForeground,
    required this.itemTextStyle,
    required this.itemSelectedTextStyle,
    required this.sectionLabelStyle,
    required this.sectionLabelPadding,
    required this.tabHeight,
    required this.tabPadding,
    required this.tabSpacing,
    required this.tabIndicatorWidth,
    required this.tabIndicatorColor,
    required this.tabTextStyle,
    required this.tabSelectedTextStyle,
  });

  final double width;
  final Color background;
  final Color borderColor;
  final EdgeInsets padding;

  final EdgeInsets brandPadding;
  final TextStyle brandTitleStyle;
  final TextStyle brandSubtitleStyle;

  final double itemHeight;
  final BorderRadius itemRadius;
  final EdgeInsets itemPadding;
  final double itemSpacing;
  final double itemIconGap;
  final Color itemForeground;
  final Color itemDisabledForeground;
  final Color itemHoverBackground;
  final Color itemSelectedBackground;
  final Color itemSelectedForeground;
  final TextStyle itemTextStyle;
  final TextStyle itemSelectedTextStyle;

  final TextStyle sectionLabelStyle;
  final EdgeInsets sectionLabelPadding;

  final double tabHeight;
  final EdgeInsets tabPadding;
  final double tabSpacing;
  final double tabIndicatorWidth;
  final Color tabIndicatorColor;
  final TextStyle tabTextStyle;
  final TextStyle tabSelectedTextStyle;

  @override
  AppNavTheme copyWith({
    double? width,
    Color? background,
    Color? borderColor,
    EdgeInsets? padding,
    EdgeInsets? brandPadding,
    TextStyle? brandTitleStyle,
    TextStyle? brandSubtitleStyle,
    double? itemHeight,
    BorderRadius? itemRadius,
    EdgeInsets? itemPadding,
    double? itemSpacing,
    double? itemIconGap,
    Color? itemForeground,
    Color? itemDisabledForeground,
    Color? itemHoverBackground,
    Color? itemSelectedBackground,
    Color? itemSelectedForeground,
    TextStyle? itemTextStyle,
    TextStyle? itemSelectedTextStyle,
    TextStyle? sectionLabelStyle,
    EdgeInsets? sectionLabelPadding,
    double? tabHeight,
    EdgeInsets? tabPadding,
    double? tabSpacing,
    double? tabIndicatorWidth,
    Color? tabIndicatorColor,
    TextStyle? tabTextStyle,
    TextStyle? tabSelectedTextStyle,
  }) => AppNavTheme(
    width: width ?? this.width,
    background: background ?? this.background,
    borderColor: borderColor ?? this.borderColor,
    padding: padding ?? this.padding,
    brandPadding: brandPadding ?? this.brandPadding,
    brandTitleStyle: brandTitleStyle ?? this.brandTitleStyle,
    brandSubtitleStyle: brandSubtitleStyle ?? this.brandSubtitleStyle,
    itemHeight: itemHeight ?? this.itemHeight,
    itemRadius: itemRadius ?? this.itemRadius,
    itemPadding: itemPadding ?? this.itemPadding,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    itemIconGap: itemIconGap ?? this.itemIconGap,
    itemForeground: itemForeground ?? this.itemForeground,
    itemDisabledForeground: itemDisabledForeground ?? this.itemDisabledForeground,
    itemHoverBackground: itemHoverBackground ?? this.itemHoverBackground,
    itemSelectedBackground: itemSelectedBackground ?? this.itemSelectedBackground,
    itemSelectedForeground: itemSelectedForeground ?? this.itemSelectedForeground,
    itemTextStyle: itemTextStyle ?? this.itemTextStyle,
    itemSelectedTextStyle: itemSelectedTextStyle ?? this.itemSelectedTextStyle,
    sectionLabelStyle: sectionLabelStyle ?? this.sectionLabelStyle,
    sectionLabelPadding: sectionLabelPadding ?? this.sectionLabelPadding,
    tabHeight: tabHeight ?? this.tabHeight,
    tabPadding: tabPadding ?? this.tabPadding,
    tabSpacing: tabSpacing ?? this.tabSpacing,
    tabIndicatorWidth: tabIndicatorWidth ?? this.tabIndicatorWidth,
    tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
    tabTextStyle: tabTextStyle ?? this.tabTextStyle,
    tabSelectedTextStyle: tabSelectedTextStyle ?? this.tabSelectedTextStyle,
  );

  @override
  AppNavTheme lerp(covariant AppNavTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
