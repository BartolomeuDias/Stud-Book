import 'package:flutter/material.dart';

enum AppTone { neutral, primary, secondary, info, success, warning, error }

@immutable
class ToneColors {
  const ToneColors({
    required this.container,
    required this.onContainer,
    required this.strong,
    required this.onStrong,
  });

  final Color container;

  final Color onContainer;

  final Color strong;

  final Color onStrong;

  static ToneColors lerp(ToneColors a, ToneColors b, double t) => ToneColors(
    container: Color.lerp(a.container, b.container, t)!,
    onContainer: Color.lerp(a.onContainer, b.onContainer, t)!,
    strong: Color.lerp(a.strong, b.strong, t)!,
    onStrong: Color.lerp(a.onStrong, b.onStrong, t)!,
  );
}

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({required this.tones});

  final Map<AppTone, ToneColors> tones;

  ToneColors of(AppTone tone) => tones[tone]!;

  @override
  StatusColors copyWith({Map<AppTone, ToneColors>? tones}) =>
      StatusColors(tones: tones ?? this.tones);

  @override
  StatusColors lerp(covariant StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      tones: {
        for (final tone in AppTone.values) tone: ToneColors.lerp(of(tone), other.of(tone), t),
      },
    );
  }
}
