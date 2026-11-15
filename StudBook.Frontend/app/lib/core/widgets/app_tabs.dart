import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';
import 'app_tags.dart';

class AppTabItem {
  const AppTabItem({required this.label, this.count});

  final String label;
  final int? count;
}

class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Wrap(
        spacing: nav.tabSpacing,
        children: [
          for (var i = 0; i < tabs.length; i++)
            _Tab(item: tabs[i], selected: i == selectedIndex, onTap: () => onSelected(i)),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final AppTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.tabIndicator,
          curve: AppMotion.enter,
          height: nav.tabHeight,
          padding: nav.tabPadding,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? nav.tabIndicatorColor : Colors.transparent,
                width: nav.tabIndicatorWidth,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: context.tags.dotGap,
            children: [
              Text(item.label, style: selected ? nav.tabSelectedTextStyle : nav.tabTextStyle),
              if (item.count != null) AppCountPill(count: item.count!, selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}
