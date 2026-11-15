import 'package:flutter/material.dart';

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.mono,
    required this.monoSmall,
    required this.monoField,
    required this.overline,
    required this.sectionMark,
    required this.caption,
  });

  final TextStyle mono;

  final TextStyle monoSmall;

  final TextStyle monoField;

  final TextStyle overline;

  final TextStyle sectionMark;

  final TextStyle caption;

  @override
  AppTextStyles copyWith({
    TextStyle? mono,
    TextStyle? monoSmall,
    TextStyle? monoField,
    TextStyle? overline,
    TextStyle? sectionMark,
    TextStyle? caption,
  }) => AppTextStyles(
    mono: mono ?? this.mono,
    monoSmall: monoSmall ?? this.monoSmall,
    monoField: monoField ?? this.monoField,
    overline: overline ?? this.overline,
    sectionMark: sectionMark ?? this.sectionMark,
    caption: caption ?? this.caption,
  );

  @override
  AppTextStyles lerp(covariant AppTextStyles? other, double t) {
    if (other == null) return this;
    return AppTextStyles(
      mono: TextStyle.lerp(mono, other.mono, t)!,
      monoSmall: TextStyle.lerp(monoSmall, other.monoSmall, t)!,
      monoField: TextStyle.lerp(monoField, other.monoField, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      sectionMark: TextStyle.lerp(sectionMark, other.sectionMark, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}
