import 'package:flutter/material.dart';

import '../../../../../core/theme/extensions/status_colors.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/tokens/app_dimens.dart';
import '../../../domain/entities/horse.dart';
import '../../horse_strings.dart';

class PedigreeChart extends StatelessWidget {
  const PedigreeChart({super.key, required this.horse, required this.onOpen});

  final HorseDetails horse;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final pedigree = horse.pedigree;
    return AppPedigreeFrame(
      columns: [
        _PedigreeColumn(
          title: HorseStrings.horseColumn,
          children: [
            _PedigreeCell(
              role: HorseStrings.category(horse.category),
              name: horse.name,
              meta: horse.registrationNumber,
              highlighted: true,
            ),
          ],
        ),
        _PedigreeColumn(
          title: HorseStrings.parentsColumn,
          children: [
            _node(HorseStrings.sire, pedigree.sire),
            _node(HorseStrings.dam, pedigree.dam),
          ],
        ),
        _PedigreeColumn(
          title: HorseStrings.grandparentsColumn,
          children: [
            _node(HorseStrings.paternalGrandsire, pedigree.paternalGrandsire),
            _node(HorseStrings.paternalGranddam, pedigree.paternalGranddam),
            _node(HorseStrings.maternalGrandsire, pedigree.maternalGrandsire),
            _node(HorseStrings.maternalGranddam, pedigree.maternalGranddam),
          ],
        ),
      ],
    );
  }

  Widget _node(String role, PedigreeNode? node) => _PedigreeCell(
    role: role,
    name: node?.name,
    meta: node?.registrationNumber,
    onTap: node == null ? null : () => onOpen(node.id),
  );
}

class AppPedigreeFrame extends StatelessWidget {
  const AppPedigreeFrame({super.key, required this.columns});

  final List<Widget> columns;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s24,
        children: [for (final column in columns) Expanded(child: column)],
      ),
    );
  }
}

class _PedigreeColumn extends StatelessWidget {
  const _PedigreeColumn({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s12,
      children: [
        Text(title.toUpperCase(), style: context.table.headerTextStyle),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s12,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _PedigreeCell extends StatelessWidget {
  const _PedigreeCell({
    required this.role,
    required this.name,
    this.meta,
    this.onTap,
    this.highlighted = false,
  });

  final String role;
  final String? name;
  final String? meta;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaces;
    final tone = context.status.of(AppTone.primary);
    final known = name != null;
    final foreground = highlighted ? tone.onContainer : null;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: AppSizes.pedigreeCellMinWidth),
      child: Material(
        color: highlighted ? tone.container : surfaces.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r6),
          side: BorderSide(
            color: highlighted ? tone.strong : surfaces.cardBorderColor,
            width: highlighted ? AppStroke.focus : AppStroke.hairline,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          hoverColor: context.colors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppStroke.focus,
                    children: [
                      Text(role, style: context.text.bodySmall?.copyWith(color: foreground)),
                      Text(
                        name ?? HorseStrings.unknown,
                        style: context.text.titleSmall?.copyWith(
                          color: known ? foreground : context.colors.onSurfaceVariant,
                        ),
                      ),
                      if (meta != null)
                        Text(
                          meta!,
                          style: context.textStyles.monoSmall.copyWith(color: foreground),
                        ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: AppSizes.iconSmall,
                    color: context.colors.outline,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
