import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_dimens.dart';

abstract final class AppTypography {
  static const _displaySmallSize = 44.0;
  static const _displaySmallHeight = 52.0;
  static const _headlineMediumSize = 30.0;
  static const _headlineMediumHeight = 38.0;
  static const _headlineSmallSize = 32.0;
  static const _headlineSmallHeight = 40.0;
  static const _titleLargeSize = 22.0;
  static const _titleLargeHeight = 28.0;
  static const _size16 = 16.0;
  static const _height24 = 24.0;
  static const _size14 = 14.0;
  static const _height20 = 20.0;
  static const _size13 = 13.0;
  static const _height18 = 18.0;
  static const _size12 = 12.0;
  static const _height16 = 16.0;
  static const _sectionMarkSize = 20.0;
  static const _sectionMarkHeight = 28.0;

  static TextStyle _caslon(double size, double lineHeight, {double? tracking}) =>
      GoogleFonts.libreCaslonText(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: FontWeight.w400,
        letterSpacing: tracking == null ? null : tracking * size,
      );

  static TextStyle _sans(
    double size,
    double lineHeight, {
    FontWeight weight = FontWeight.w400,
    double? tracking,
  }) => GoogleFonts.ibmPlexSans(
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: tracking == null ? null : tracking * size,
  );

  static TextStyle _mono(double size, double lineHeight, {FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.ibmPlexMono(fontSize: size, height: lineHeight / size, fontWeight: weight);

  static TextTheme textTheme(Color ink, Color fadedInk) {
    final base = TextTheme(
      displaySmall: _caslon(
        _displaySmallSize,
        _displaySmallHeight,
        tracking: AppLayout.displayTracking,
      ),
      headlineMedium: _caslon(_headlineMediumSize, _headlineMediumHeight),
      headlineSmall: _caslon(_headlineSmallSize, _headlineSmallHeight),
      titleLarge: _caslon(_titleLargeSize, _titleLargeHeight),
      titleMedium: _sans(_size16, _height24, weight: FontWeight.w600),
      titleSmall: _sans(_size14, _height20, weight: FontWeight.w600),
      bodyLarge: _sans(_size16, _height24),
      bodyMedium: _sans(_size14, _height20),
      bodySmall: _sans(_size12, _height16).copyWith(color: fadedInk),
      labelLarge: _sans(
        _size14,
        _height20,
        weight: FontWeight.w500,
        tracking: AppLayout.buttonTracking,
      ),
      labelMedium: _sans(
        _size12,
        _height16,
        weight: FontWeight.w500,
        tracking: AppLayout.capsTracking,
      ),
      labelSmall: _sans(_size12, _height16, weight: FontWeight.w500),
    );
    return base.apply(bodyColor: ink, displayColor: ink);
  }

  static TextStyle mono(Color color) =>
      _mono(_size13, _height18, weight: FontWeight.w500).copyWith(color: color);

  static TextStyle monoSmall(Color color) => _mono(_size12, _height16).copyWith(color: color);

  static TextStyle monoField(Color color) =>
      _mono(_size14, _height20, weight: FontWeight.w500).copyWith(color: color);

  static TextStyle overline(Color color) => _sans(
    _size12,
    _height16,
    weight: FontWeight.w500,
    tracking: AppLayout.overlineTracking,
  ).copyWith(color: color);

  static TextStyle sectionMark(Color color) => GoogleFonts.libreCaslonText(
    fontSize: _sectionMarkSize,
    height: _sectionMarkHeight / _sectionMarkSize,
    fontStyle: FontStyle.italic,
    color: color,
  );

  static TextStyle labelSmallButton(Color color) =>
      _sans(_size13, _height18, weight: FontWeight.w500).copyWith(color: color);

  static TextStyle resultBadge(Color color) =>
      _sans(_size13, _height18, weight: FontWeight.w600).copyWith(color: color);

  static TextStyle caption(Color color) => _sans(_size13, _height18).copyWith(color: color);
}
