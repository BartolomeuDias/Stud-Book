import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/extensions/app_field_theme.dart';
import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';
import '../utils/date_format.dart';

class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    super.key,
    required this.label,
    required this.child,
    this.helper,
    this.error,
    this.enabled = true,
  });

  final String label;
  final Widget child;
  final String? helper;
  final String? error;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final fields = context.fields;
    final message = error ?? helper;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: fields.labelGap,
      children: [
        Text(label, style: enabled ? fields.labelStyle : fields.disabledLabelStyle),
        child,
        if (message != null)
          Text(message, style: error != null ? fields.errorStyle : fields.helperStyle),
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.hint,
    this.helper,
    this.error,
    this.enabled = true,
    this.monospace = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.autofocus = false,
    this.focusNode,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final String? helper;
  final String? error;
  final bool enabled;
  final bool monospace;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return AppLabeledField(
      label: label,
      helper: helper,
      error: error,
      enabled: enabled,
      child: AppTextInput(
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        hint: hint,
        hasError: error != null,
        enabled: enabled,
        monospace: monospace,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        prefixIcon: prefixIcon,
        autofocus: autofocus,
        focusNode: focusNode,
        semanticLabel: label,
      ),
    );
  }
}

class AppTextInput extends StatelessWidget {
  const AppTextInput({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.hint,
    this.hasError = false,
    this.enabled = true,
    this.monospace = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.autofocus = false,
    this.semanticLabel,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final bool hasError;
  final bool enabled;
  final bool monospace;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fields = context.fields;
    final style = monospace ? context.textStyles.monoField : context.text.bodyMedium;
    final errorBorder = context.theme.inputDecorationTheme.errorBorder;
    return Semantics(
      label: semanticLabel,
      textField: true,
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        onChanged: onChanged,
        enabled: enabled,
        autofocus: autofocus,
        focusNode: focusNode,
        maxLines: maxLines,
        minLines: maxLines > 1 ? maxLines : null,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: style?.copyWith(
          color: enabled ? context.colors.onSurface : context.colors.onSurfaceVariant,
        ),
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, size: fields.iconSize, color: fields.iconColor),
          enabledBorder: hasError ? errorBorder : null,
          focusedBorder: hasError ? errorBorder : null,
        ),
      ),
    );
  }
}

class AppDropdownItem<T> {
  const AppDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.helper,
    this.error,
    this.enabled = true,
    this.focusNode,
  });

  final String label;
  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? helper;
  final String? error;
  final bool enabled;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return AppLabeledField(
      label: label,
      helper: helper,
      error: error,
      enabled: enabled,
      child: AppDropdownInput<T>(
        items: items,
        value: value,
        onChanged: onChanged,
        hint: hint,
        enabled: enabled,
        hasError: error != null,
        focusNode: focusNode,
      ),
    );
  }
}

class AppDropdownInput<T> extends StatefulWidget {
  const AppDropdownInput({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.enabled = true,
    this.hasError = false,
    this.focusNode,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final bool enabled;
  final bool hasError;
  final FocusNode? focusNode;

  @override
  State<AppDropdownInput<T>> createState() => _AppDropdownInputState<T>();
}

class _AppDropdownInputState<T> extends State<AppDropdownInput<T>>
    with SingleTickerProviderStateMixin {
  static const _halfTurn = 0.5;

  final _link = LayerLink();
  final _portal = OverlayPortalController();
  final _tapGroup = Object();
  late final _controller = AnimationController(
    vsync: this,
    duration: AppDurations.menuOpen,
    reverseDuration: AppDurations.menuClose,
  )..addStatusListener(_onStatus);
  late final _reveal = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
    reverseCurve: AppMotion.exit,
  );
  bool _focused = false;
  double _width = 0;

  bool get _isOpen =>
      _controller.status == AnimationStatus.forward ||
      _controller.status == AnimationStatus.completed;

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) _portal.hide();
    setState(() {});
  }

  void _open() {
    _portal.show();
    _controller.forward();
  }

  void _close() {
    if (_isOpen) _controller.reverse();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _select(T value) {
    widget.onChanged(value);
    _close();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape && _isOpen) {
      _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _reveal.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = context.fields;
    final selected = widget.items.where((item) => item.value == widget.value).firstOrNull;
    final inputTheme = context.theme.inputDecorationTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return OverlayPortal(
          controller: _portal,
          overlayChildBuilder: (context) => _buildPanel(context, fields, selected),
          child: CompositedTransformTarget(
            link: _link,
            child: TapRegion(
              groupId: _tapGroup,
              child: Focus(
                canRequestFocus: false,
                skipTraversal: true,
                onKeyEvent: _onKey,
                child: InkWell(
                  focusNode: widget.focusNode,
                  onTap: widget.enabled ? _toggle : null,
                  onFocusChange: (focused) => setState(() => _focused = focused),
                  borderRadius: BorderRadius.circular(fields.menuRadius.bottomLeft.x),
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: InputDecorator(
                    isFocused: _focused,
                    isEmpty: selected == null,
                    decoration: InputDecoration(
                      enabled: widget.enabled,
                      hintText: widget.hint,
                      enabledBorder: widget.hasError ? inputTheme.errorBorder : null,
                      focusedBorder: widget.hasError ? inputTheme.errorBorder : null,
                      suffixIcon: AnimatedRotation(
                        turns: _isOpen ? _halfTurn : 0,
                        duration: AppDurations.menuArrow,
                        curve: AppMotion.enter,
                        child: Icon(
                          Icons.expand_more,
                          size: fields.iconSize,
                          color: fields.iconColor,
                        ),
                      ),
                    ),
                    child: selected == null
                        ? null
                        : Text(
                            selected.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodyMedium?.copyWith(
                              color: widget.enabled ? null : context.colors.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, AppFieldTheme fields, AppDropdownItem<T>? selected) {
    return CompositedTransformFollower(
      link: _link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      offset: Offset(0, fields.menuGap),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: _width,
          child: TapRegion(
            groupId: _tapGroup,
            onTapOutside: (_) => _close(),
            child: FadeTransition(
              opacity: _reveal,
              child: AnimatedBuilder(
                animation: _reveal,
                builder: (context, child) {
                  final t = _reveal.value;
                  final scale = AppMotion.menuScaleFrom + (1 - AppMotion.menuScaleFrom) * t;
                  return Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.translationValues(0, -AppMotion.menuDrop * (1 - t), 0)
                      ..multiply(Matrix4.diagonal3Values(1, scale, 1)),
                    child: child,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: fields.menuBackground,
                    borderRadius: fields.menuRadius,
                    border: Border.all(
                      color: fields.menuBorderColor,
                      width: fields.menuBorderWidth,
                    ),
                    boxShadow: fields.menuShadow,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: fields.menuMaxHeight),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Material(
                            type: MaterialType.transparency,
                            child: ListView(
                              shrinkWrap: true,
                              padding: fields.menuPadding,
                              children: [
                                for (final item in widget.items)
                                  _MenuItem(
                                    label: item.label,
                                    selected: item == selected,
                                    onTap: () => _select(item.value),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fields = context.fields;
    final style = selected ? fields.menuItemSelectedTextStyle : fields.menuItemTextStyle;
    return InkWell(
      onTap: onTap,
      borderRadius: fields.menuItemRadius,
      hoverColor: fields.menuItemHover,
      focusColor: fields.menuItemHover,
      child: Ink(
        height: fields.menuItemHeight,
        padding: fields.menuItemPadding,
        decoration: BoxDecoration(
          color: selected ? fields.menuItemSelectedBackground : null,
          borderRadius: fields.menuItemRadius,
        ),
        child: Row(
          spacing: AppSpacing.s8,
          children: [
            Expanded(
              child: Text(label, style: style, overflow: TextOverflow.ellipsis),
            ),
            if (selected) Icon(Icons.check, size: fields.iconSize, color: style.color),
          ],
        ),
      ),
    );
  }
}

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.hint,
    this.helper,
    this.clearTooltip,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? hint;
  final String? helper;
  final String? clearTooltip;

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final fields = context.fields;
    final current = value;
    return AppLabeledField(
      label: label,
      helper: helper,
      child: InkWell(
        onTap: () => _pick(context),
        borderRadius: fields.menuRadius,
        child: InputDecorator(
          isEmpty: current == null,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: current == null
                ? Icon(Icons.calendar_today_outlined, size: fields.iconSize)
                : IconButton(
                    tooltip: clearTooltip,
                    icon: Icon(Icons.close, size: fields.iconSize),
                    onPressed: () => onChanged(null),
                  ),
          ),
          child: current == null
              ? null
              : Text(AppDateFormat.display(current), style: context.text.bodyMedium),
        ),
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: context.fields.menuRadius,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: value, onChanged: (next) => onChanged(next ?? false)),
          Text(label, style: context.text.bodyMedium),
        ],
      ),
    );
  }
}
