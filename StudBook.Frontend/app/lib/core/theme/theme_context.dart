import 'package:flutter/material.dart';

import 'extensions/app_button_styles.dart';
import 'extensions/app_field_theme.dart';
import 'extensions/app_nav_theme.dart';
import 'extensions/app_surface_theme.dart';
import 'extensions/app_table_theme.dart';
import 'extensions/app_tag_theme.dart';
import 'extensions/app_text_styles.dart';
import 'extensions/status_colors.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
  AppTextStyles get textStyles => theme.extension<AppTextStyles>()!;
  StatusColors get status => theme.extension<StatusColors>()!;
  AppButtonStyles get buttons => theme.extension<AppButtonStyles>()!;
  AppFieldTheme get fields => theme.extension<AppFieldTheme>()!;
  AppTagTheme get tags => theme.extension<AppTagTheme>()!;
  AppTableTheme get table => theme.extension<AppTableTheme>()!;
  AppSurfaceTheme get surfaces => theme.extension<AppSurfaceTheme>()!;
  AppNavTheme get nav => theme.extension<AppNavTheme>()!;
}
