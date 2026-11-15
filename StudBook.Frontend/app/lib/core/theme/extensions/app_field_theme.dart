import 'package:flutter/material.dart';

@immutable
class AppFieldTheme extends ThemeExtension<AppFieldTheme> {
  const AppFieldTheme({
    required this.labelStyle,
    required this.disabledLabelStyle,
    required this.helperStyle,
    required this.errorStyle,
    required this.labelGap,
    required this.height,
    required this.iconColor,
    required this.iconSize,
    required this.menuBackground,
    required this.menuBorderColor,
    required this.menuBorderWidth,
    required this.menuShadow,
    required this.menuRadius,
    required this.menuGap,
    required this.menuPadding,
    required this.menuMaxHeight,
    required this.menuItemHeight,
    required this.menuItemPadding,
    required this.menuItemRadius,
    required this.menuItemHover,
    required this.menuItemSelectedBackground,
    required this.menuItemTextStyle,
    required this.menuItemSelectedTextStyle,
  });

  final TextStyle labelStyle;
  final TextStyle disabledLabelStyle;
  final TextStyle helperStyle;
  final TextStyle errorStyle;
  final double labelGap;
  final double height;
  final Color iconColor;
  final double iconSize;

  final Color menuBackground;
  final Color menuBorderColor;
  final double menuBorderWidth;
  final List<BoxShadow> menuShadow;
  final BorderRadius menuRadius;
  final double menuGap;
  final EdgeInsets menuPadding;
  final double menuMaxHeight;

  final double menuItemHeight;
  final EdgeInsets menuItemPadding;
  final BorderRadius menuItemRadius;
  final Color menuItemHover;
  final Color menuItemSelectedBackground;
  final TextStyle menuItemTextStyle;
  final TextStyle menuItemSelectedTextStyle;

  @override
  AppFieldTheme copyWith({
    TextStyle? labelStyle,
    TextStyle? disabledLabelStyle,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
    double? labelGap,
    double? height,
    Color? iconColor,
    double? iconSize,
    Color? menuBackground,
    Color? menuBorderColor,
    double? menuBorderWidth,
    List<BoxShadow>? menuShadow,
    BorderRadius? menuRadius,
    double? menuGap,
    EdgeInsets? menuPadding,
    double? menuMaxHeight,
    double? menuItemHeight,
    EdgeInsets? menuItemPadding,
    BorderRadius? menuItemRadius,
    Color? menuItemHover,
    Color? menuItemSelectedBackground,
    TextStyle? menuItemTextStyle,
    TextStyle? menuItemSelectedTextStyle,
  }) => AppFieldTheme(
    labelStyle: labelStyle ?? this.labelStyle,
    disabledLabelStyle: disabledLabelStyle ?? this.disabledLabelStyle,
    helperStyle: helperStyle ?? this.helperStyle,
    errorStyle: errorStyle ?? this.errorStyle,
    labelGap: labelGap ?? this.labelGap,
    height: height ?? this.height,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
    menuBackground: menuBackground ?? this.menuBackground,
    menuBorderColor: menuBorderColor ?? this.menuBorderColor,
    menuBorderWidth: menuBorderWidth ?? this.menuBorderWidth,
    menuShadow: menuShadow ?? this.menuShadow,
    menuRadius: menuRadius ?? this.menuRadius,
    menuGap: menuGap ?? this.menuGap,
    menuPadding: menuPadding ?? this.menuPadding,
    menuMaxHeight: menuMaxHeight ?? this.menuMaxHeight,
    menuItemHeight: menuItemHeight ?? this.menuItemHeight,
    menuItemPadding: menuItemPadding ?? this.menuItemPadding,
    menuItemRadius: menuItemRadius ?? this.menuItemRadius,
    menuItemHover: menuItemHover ?? this.menuItemHover,
    menuItemSelectedBackground: menuItemSelectedBackground ?? this.menuItemSelectedBackground,
    menuItemTextStyle: menuItemTextStyle ?? this.menuItemTextStyle,
    menuItemSelectedTextStyle: menuItemSelectedTextStyle ?? this.menuItemSelectedTextStyle,
  );

  @override
  AppFieldTheme lerp(covariant AppFieldTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
