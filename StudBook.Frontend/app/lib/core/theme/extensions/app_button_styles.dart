import 'package:flutter/material.dart';

@immutable
class AppButtonStyles extends ThemeExtension<AppButtonStyles> {
  const AppButtonStyles({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.destructive,
    required this.secondarySmall,
    required this.iconOutlined,
    required this.icon,
    required this.iconSize,
    required this.iconGap,
  });

  final ButtonStyle primary;

  final ButtonStyle secondary;

  final ButtonStyle tertiary;

  final ButtonStyle destructive;

  final ButtonStyle secondarySmall;

  final ButtonStyle iconOutlined;

  final ButtonStyle icon;

  final double iconSize;
  final double iconGap;

  @override
  AppButtonStyles copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? tertiary,
    ButtonStyle? destructive,
    ButtonStyle? secondarySmall,
    ButtonStyle? iconOutlined,
    ButtonStyle? icon,
    double? iconSize,
    double? iconGap,
  }) => AppButtonStyles(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    tertiary: tertiary ?? this.tertiary,
    destructive: destructive ?? this.destructive,
    secondarySmall: secondarySmall ?? this.secondarySmall,
    iconOutlined: iconOutlined ?? this.iconOutlined,
    icon: icon ?? this.icon,
    iconSize: iconSize ?? this.iconSize,
    iconGap: iconGap ?? this.iconGap,
  );

  @override
  AppButtonStyles lerp(covariant AppButtonStyles? other, double t) {
    if (other == null) return this;
    return AppButtonStyles(
      primary: ButtonStyle.lerp(primary, other.primary, t)!,
      secondary: ButtonStyle.lerp(secondary, other.secondary, t)!,
      tertiary: ButtonStyle.lerp(tertiary, other.tertiary, t)!,
      destructive: ButtonStyle.lerp(destructive, other.destructive, t)!,
      secondarySmall: ButtonStyle.lerp(secondarySmall, other.secondarySmall, t)!,
      iconOutlined: ButtonStyle.lerp(iconOutlined, other.iconOutlined, t)!,
      icon: ButtonStyle.lerp(icon, other.icon, t)!,
      iconSize: t < 0.5 ? iconSize : other.iconSize,
      iconGap: t < 0.5 ? iconGap : other.iconGap,
    );
  }
}
