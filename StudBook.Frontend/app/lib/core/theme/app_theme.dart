import 'package:flutter/material.dart';

import 'extensions/app_button_styles.dart';
import 'extensions/app_field_theme.dart';
import 'extensions/app_nav_theme.dart';
import 'extensions/app_surface_theme.dart';
import 'extensions/app_table_theme.dart';
import 'extensions/app_tag_theme.dart';
import 'extensions/app_text_styles.dart';
import 'extensions/status_colors.dart';
import 'tokens/app_dimens.dart';
import 'tokens/app_palette.dart';
import 'tokens/app_typography.dart';

abstract final class AppTheme {
  static const _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.paddockGreen,
    onPrimary: AppPalette.white,
    primaryContainer: AppPalette.greenTint,
    onPrimaryContainer: AppPalette.onGreenTint,
    secondary: AppPalette.saddleLeather,
    onSecondary: AppPalette.white,
    secondaryContainer: AppPalette.leatherTint,
    onSecondaryContainer: AppPalette.onLeatherTint,
    tertiary: AppPalette.ledgerInk,
    onTertiary: AppPalette.white,
    tertiaryContainer: AppPalette.inkTint,
    onTertiaryContainer: AppPalette.onInkTint,
    error: AppPalette.error,
    onError: AppPalette.white,
    errorContainer: AppPalette.errorContainer,
    onErrorContainer: AppPalette.onErrorContainer,
    surface: AppPalette.paper,
    onSurface: AppPalette.ink,
    onSurfaceVariant: AppPalette.fadedInk,
    surfaceContainerLowest: AppPalette.pageWhite,
    surfaceContainerLow: AppPalette.pageWhite,
    surfaceContainer: AppPalette.vellum,
    surfaceContainerHigh: AppPalette.vellumDark,
    surfaceContainerHighest: AppPalette.vellumDark,
    outline: AppPalette.fieldBorder,
    outlineVariant: AppPalette.ledgerRule,
    inverseSurface: AppPalette.ink,
    onInverseSurface: AppPalette.paper,
    inversePrimary: AppPalette.inverseAction,
    shadow: AppPalette.shadow,
    surfaceTint: Colors.transparent,
  );

  static ThemeData light() {
    const scheme = _colorScheme;
    final textTheme = AppTypography.textTheme(scheme.onSurface, scheme.onSurfaceVariant);
    final buttons = _buttonStyles(scheme, textTheme);
    final fieldRadius = BorderRadius.circular(AppRadius.r6);

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: fieldRadius,
      borderSide: BorderSide(color: color, width: width),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      splashFactory: NoSplash.splashFactory,
      hoverColor: scheme.surfaceContainer,
      focusColor: scheme.primaryContainer,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppStroke.hairline,
        space: AppStroke.hairline,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface, size: AppSizes.icon),
      filledButtonTheme: FilledButtonThemeData(style: buttons.primary),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttons.secondary),
      textButtonTheme: TextButtonThemeData(style: buttons.tertiary),
      iconButtonTheme: IconButtonThemeData(style: buttons.icon),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? scheme.surfaceContainer
              : scheme.surfaceContainerLowest,
        ),
        isDense: true,
        constraints: const BoxConstraints(minHeight: AppSizes.control),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s12,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: border(scheme.outline, AppStroke.hairline),
        enabledBorder: border(scheme.outline, AppStroke.hairline),
        disabledBorder: border(scheme.outlineVariant, AppStroke.hairline),
        focusedBorder: border(scheme.primary, AppStroke.focus),
        errorBorder: border(scheme.error, AppStroke.focus),
        focusedErrorBorder: border(scheme.error, AppStroke.focus),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primary : null,
        ),
        checkColor: const WidgetStatePropertyAll(AppPalette.white),
        side: BorderSide(color: scheme.outline, width: AppStroke.focus),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppPalette.white : scheme.onSurfaceVariant,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerHigh,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primary : scheme.outline,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        width: AppSizes.dialogMaxWidth,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r6)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.level1OffsetY,
        shadowColor: scheme.shadow,
        textStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: scheme.primary,
        headerForegroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.r4),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
      ),
      extensions: [
        _statusColors(scheme),
        _textStyles(scheme),
        buttons,
        _fieldTheme(scheme, textTheme),
        _tagTheme(textTheme),
        _tableTheme(scheme, textTheme),
        _surfaceTheme(scheme),
        _navTheme(scheme, textTheme),
      ],
    );
  }

  static StatusColors _statusColors(ColorScheme scheme) => StatusColors(
    tones: {
      AppTone.neutral: ToneColors(
        container: scheme.surfaceContainer,
        onContainer: scheme.onSurfaceVariant,
        strong: scheme.onSurfaceVariant,
        onStrong: AppPalette.white,
      ),
      AppTone.primary: ToneColors(
        container: scheme.primaryContainer,
        onContainer: scheme.onPrimaryContainer,
        strong: scheme.primary,
        onStrong: scheme.onPrimary,
      ),
      AppTone.secondary: ToneColors(
        container: scheme.secondaryContainer,
        onContainer: scheme.onSecondaryContainer,
        strong: scheme.secondary,
        onStrong: scheme.onSecondary,
      ),
      AppTone.info: ToneColors(
        container: scheme.tertiaryContainer,
        onContainer: scheme.onTertiaryContainer,
        strong: scheme.tertiary,
        onStrong: scheme.onTertiary,
      ),
      AppTone.success: const ToneColors(
        container: AppPalette.successContainer,
        onContainer: AppPalette.onSuccessContainer,
        strong: AppPalette.success,
        onStrong: AppPalette.white,
      ),
      AppTone.warning: const ToneColors(
        container: AppPalette.warningContainer,
        onContainer: AppPalette.onWarningContainer,
        strong: AppPalette.warning,
        onStrong: AppPalette.white,
      ),
      AppTone.error: ToneColors(
        container: scheme.errorContainer,
        onContainer: scheme.onErrorContainer,
        strong: scheme.error,
        onStrong: scheme.onError,
      ),
    },
  );

  static AppTextStyles _textStyles(ColorScheme scheme) => AppTextStyles(
    mono: AppTypography.mono(scheme.onSurfaceVariant),
    monoSmall: AppTypography.monoSmall(scheme.onSurfaceVariant),
    monoField: AppTypography.monoField(scheme.onSurface),
    overline: AppTypography.overline(scheme.onSurfaceVariant),
    sectionMark: AppTypography.sectionMark(scheme.secondary),
    caption: AppTypography.caption(scheme.onSurfaceVariant),
  );

  static ButtonStyle _button({
    required TextStyle? textStyle,
    required Color background,
    required Color hover,
    required Color pressed,
    required Color foreground,
    required Color borderColor,
    required Color disabledBackground,
    required Color disabledForeground,
    required Color disabledBorder,
    required EdgeInsets padding,
    required double height,
    Size? fixedSize,
  }) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(textStyle),
      minimumSize: WidgetStatePropertyAll(fixedSize ?? Size(height, height)),
      fixedSize: fixedSize == null ? null : WidgetStatePropertyAll(fixedSize),
      padding: WidgetStatePropertyAll(padding),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      animationDuration: AppDurations.hover,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r6)),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledBackground;
        if (states.contains(WidgetState.pressed)) return pressed;
        if (states.contains(WidgetState.hovered)) return hover;
        return background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? disabledForeground : foreground,
      ),
      iconColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? disabledForeground : foreground,
      ),
      iconSize: const WidgetStatePropertyAll(AppSizes.iconSmall),
      side: WidgetStateProperty.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.disabled)
              ? disabledBorder
              : states.contains(WidgetState.focused)
              ? foreground
              : borderColor,
          width: states.contains(WidgetState.focused) ? AppStroke.focus : AppStroke.hairline,
        ),
      ),
      mouseCursor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
      ),
    );
  }

  static AppButtonStyles _buttonStyles(ColorScheme scheme, TextTheme textTheme) {
    const regularPadding = EdgeInsets.symmetric(horizontal: AppSpacing.s20);
    const quietPadding = EdgeInsets.symmetric(horizontal: AppSpacing.s12);
    final small = AppTypography.labelSmallButton(scheme.primary);

    return AppButtonStyles(
      primary: _button(
        textStyle: textTheme.labelLarge,
        background: scheme.primary,
        hover: AppPalette.paddockGreenHover,
        pressed: AppPalette.paddockGreenPressed,
        foreground: scheme.onPrimary,
        borderColor: scheme.primary,
        disabledBackground: scheme.surfaceContainerHigh,
        disabledForeground: scheme.outline,
        disabledBorder: scheme.surfaceContainerHigh,
        padding: regularPadding,
        height: AppSizes.control,
      ),
      secondary: _button(
        textStyle: textTheme.labelLarge,
        background: Colors.transparent,
        hover: scheme.surfaceContainer,
        pressed: scheme.surfaceContainerHigh,
        foreground: scheme.primary,
        borderColor: scheme.outline,
        disabledBackground: Colors.transparent,
        disabledForeground: AppPalette.mutedInk,
        disabledBorder: scheme.outlineVariant,
        padding: regularPadding,
        height: AppSizes.control,
      ),
      tertiary: _button(
        textStyle: textTheme.labelLarge,
        background: Colors.transparent,
        hover: scheme.surfaceContainer,
        pressed: scheme.surfaceContainerHigh,
        foreground: scheme.primary,
        borderColor: Colors.transparent,
        disabledBackground: Colors.transparent,
        disabledForeground: AppPalette.mutedInk,
        disabledBorder: Colors.transparent,
        padding: quietPadding,
        height: AppSizes.control,
      ),
      destructive: _button(
        textStyle: textTheme.labelLarge,
        background: scheme.error,
        hover: AppPalette.errorHover,
        pressed: AppPalette.errorPressed,
        foreground: scheme.onError,
        borderColor: scheme.error,
        disabledBackground: scheme.surfaceContainerHigh,
        disabledForeground: scheme.outline,
        disabledBorder: scheme.surfaceContainerHigh,
        padding: regularPadding,
        height: AppSizes.control,
      ),
      secondarySmall: _button(
        textStyle: small,
        background: Colors.transparent,
        hover: scheme.surfaceContainer,
        pressed: scheme.surfaceContainerHigh,
        foreground: scheme.primary,
        borderColor: scheme.outline,
        disabledBackground: Colors.transparent,
        disabledForeground: AppPalette.mutedInk,
        disabledBorder: scheme.outlineVariant,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        height: AppSizes.controlSmall,
      ),
      iconOutlined: _button(
        textStyle: textTheme.labelLarge,
        background: Colors.transparent,
        hover: scheme.surfaceContainer,
        pressed: scheme.surfaceContainerHigh,
        foreground: scheme.onSurface,
        borderColor: scheme.outline,
        disabledBackground: Colors.transparent,
        disabledForeground: AppPalette.mutedInk,
        disabledBorder: scheme.outlineVariant,
        padding: EdgeInsets.zero,
        height: AppSizes.control,
        fixedSize: const Size.square(AppSizes.control),
      ),
      icon: _button(
        textStyle: textTheme.labelLarge,
        background: Colors.transparent,
        hover: scheme.surfaceContainer,
        pressed: scheme.surfaceContainerHigh,
        foreground: scheme.onSurfaceVariant,
        borderColor: Colors.transparent,
        disabledBackground: Colors.transparent,
        disabledForeground: AppPalette.mutedInk,
        disabledBorder: Colors.transparent,
        padding: EdgeInsets.zero,
        height: AppSizes.control,
        fixedSize: const Size.square(AppSizes.control),
      ),
      iconSize: AppSizes.iconSmall,
      iconGap: AppSpacing.s8,
    );
  }

  static AppFieldTheme _fieldTheme(ColorScheme scheme, TextTheme textTheme) {
    final label = textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500);
    final item = textTheme.bodyMedium!.copyWith(color: scheme.onSurface);
    return AppFieldTheme(
      labelStyle: label,
      disabledLabelStyle: label.copyWith(color: AppPalette.disabledInk),
      helperStyle: textTheme.bodySmall!,
      errorStyle: textTheme.bodySmall!.copyWith(color: scheme.error),
      labelGap: AppSpacing.s6,
      height: AppSizes.control,
      iconColor: scheme.onSurfaceVariant,
      iconSize: AppSizes.icon,
      menuBackground: scheme.surfaceContainerLowest,
      menuBorderColor: scheme.outline,
      menuBorderWidth: AppStroke.hairline,
      menuShadow: [
        BoxShadow(
          color: scheme.shadow,
          blurRadius: AppElevation.level1Blur,
          offset: const Offset(0, AppElevation.level1OffsetY),
        ),
      ],
      menuRadius: BorderRadius.circular(AppRadius.r8),
      menuGap: AppSpacing.s4,
      menuPadding: const EdgeInsets.all(AppSpacing.s6),
      menuMaxHeight: AppSizes.menuMaxHeight,
      menuItemHeight: AppSizes.menuItem,
      menuItemPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10),
      menuItemRadius: BorderRadius.circular(AppRadius.r4),
      menuItemHover: scheme.surfaceContainer,
      menuItemSelectedBackground: scheme.primaryContainer,
      menuItemTextStyle: item,
      menuItemSelectedTextStyle: item.copyWith(
        color: scheme.onPrimaryContainer,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static AppTagTheme _tagTheme(TextTheme textTheme) {
    final tagText = textTheme.labelSmall!;
    return AppTagTheme(
      tagHeight: AppSizes.tag,
      tagPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
      tagRadius: BorderRadius.circular(AppRadius.r4),
      tagTextStyle: tagText,
      badgeHeight: AppSizes.badge,
      badgePadding: const EdgeInsets.only(left: AppSpacing.s8, right: AppSpacing.s10),
      badgeTextStyle: tagText,
      dotSize: AppSizes.badgeDot,
      dotGap: AppSpacing.s6,
      resultHeight: AppSizes.resultBadge,
      resultPadding: const EdgeInsets.only(left: AppSpacing.s8, right: AppSpacing.s12),
      resultTextStyle: AppTypography.resultBadge(AppPalette.ink),
      resultIconSize: AppSizes.iconSmall,
      countPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
      countTextStyle: AppTypography.monoSmall(AppPalette.ink),
    );
  }

  static AppTableTheme _tableTheme(ColorScheme scheme, TextTheme textTheme) => AppTableTheme(
    background: scheme.surfaceContainerLowest,
    borderColor: scheme.outlineVariant,
    radius: BorderRadius.circular(AppRadius.r8),
    headerHeight: AppSizes.tableHeader,
    headerBackground: scheme.surfaceContainer,
    headerTextStyle: textTheme.labelMedium!.copyWith(color: scheme.onSurfaceVariant),
    rowMinHeight: AppSizes.tableRow,
    rowHoverColor: scheme.surface,
    rowPadding: const EdgeInsets.only(left: AppSpacing.s24, right: AppSpacing.s16),
    cellGap: AppSpacing.s16,
    cellTextStyle: textTheme.bodyMedium!,
    footerPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
    footerTextStyle: AppTypography.monoSmall(scheme.onSurfaceVariant),
  );

  static AppSurfaceTheme _surfaceTheme(ColorScheme scheme) => AppSurfaceTheme(
    cardBackground: scheme.surfaceContainerLowest,
    cardBorderColor: scheme.outlineVariant,
    cardRadius: BorderRadius.circular(AppRadius.r8),
    cardPadding: const EdgeInsets.all(AppSpacing.s24),
    ledgerRuleColor: scheme.onSurface,
    ledgerRuleWidth: AppStroke.ledger,
    pagePadding: const EdgeInsets.fromLTRB(
      AppSpacing.s40,
      AppSpacing.s32,
      AppSpacing.s40,
      AppSpacing.s48,
    ),
    sectionGap: AppSpacing.s32,
    blockGap: AppSpacing.s24,
    bannerPadding: const EdgeInsets.all(AppSpacing.s16),
    bannerRadius: BorderRadius.circular(AppRadius.r8),
    bannerIconSize: AppSizes.icon,
    menuShadow: [
      BoxShadow(
        color: scheme.shadow,
        blurRadius: AppElevation.level1Blur,
        offset: const Offset(0, AppElevation.level1OffsetY),
      ),
    ],
  );

  static AppNavTheme _navTheme(ColorScheme scheme, TextTheme textTheme) {
    final item = textTheme.labelLarge!.copyWith(color: scheme.onSurface);
    return AppNavTheme(
      width: AppSizes.sideNavWidth,
      background: scheme.surfaceContainer,
      borderColor: scheme.outlineVariant,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s24),
      brandPadding: const EdgeInsets.only(
        left: AppSpacing.s8,
        right: AppSpacing.s8,
        bottom: AppSpacing.s24,
      ),
      brandTitleStyle: textTheme.titleLarge!,
      brandSubtitleStyle: textTheme.bodySmall!,
      itemHeight: AppSizes.control,
      itemRadius: BorderRadius.circular(AppRadius.r6),
      itemPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
      itemSpacing: AppStroke.focus,
      itemIconGap: AppSpacing.s12,
      itemForeground: scheme.onSurface,
      itemDisabledForeground: AppPalette.disabledInk,
      itemHoverBackground: scheme.surfaceContainerHigh,
      itemSelectedBackground: scheme.primaryContainer,
      itemSelectedForeground: scheme.onPrimaryContainer,
      itemTextStyle: item,
      itemSelectedTextStyle: item.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onPrimaryContainer,
      ),
      sectionLabelStyle: AppTypography.overline(scheme.onSurfaceVariant),
      sectionLabelPadding: const EdgeInsets.fromLTRB(
        AppSpacing.s12,
        AppSpacing.s24,
        AppSpacing.s12,
        AppSpacing.s8,
      ),
      tabHeight: AppSizes.control,
      tabPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
      tabSpacing: AppSpacing.s4,
      tabIndicatorWidth: AppStroke.focus,
      tabIndicatorColor: scheme.primary,
      tabTextStyle: item.copyWith(color: scheme.onSurfaceVariant),
      tabSelectedTextStyle: item.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
