import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

class AppTableColumn {
  const AppTableColumn({required this.label, this.flex = 1, this.width});

  final String label;
  final int flex;
  final double? width;
}

class AppTableRow {
  const AppTableRow({required this.cells, this.onTap});

  final List<Widget> cells;
  final VoidCallback? onTap;
}

class AppTable extends StatelessWidget {
  const AppTable({super.key, required this.columns, required this.rows, this.footer});

  final List<AppTableColumn> columns;
  final List<AppTableRow> rows;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = context.table;
    final divider = BorderSide(color: theme.borderColor);
    return Container(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: theme.radius,
        border: Border.all(color: theme.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: theme.headerHeight,
            color: theme.headerBackground,
            padding: theme.rowPadding,
            child: _cellsRow(theme.cellGap, [
              for (final column in columns)
                Text(column.label.toUpperCase(), style: theme.headerTextStyle),
            ]),
          ),
          for (final row in rows)
            DecoratedBox(
              decoration: BoxDecoration(border: Border(top: divider)),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: row.onTap,
                  hoverColor: theme.rowHoverColor,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: theme.rowMinHeight),
                    child: Padding(
                      padding: theme.rowPadding,
                      child: DefaultTextStyle.merge(
                        style: theme.cellTextStyle,
                        child: _cellsRow(theme.cellGap, row.cells),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (footer != null)
            Container(
              padding: theme.footerPadding,
              decoration: BoxDecoration(border: Border(top: divider)),
              child: DefaultTextStyle.merge(style: theme.footerTextStyle, child: footer!),
            ),
        ],
      ),
    );
  }

  Widget _cellsRow(double gap, List<Widget> cells) {
    return Row(
      spacing: gap,
      children: [
        for (var i = 0; i < columns.length; i++)
          columns[i].width != null
              ? SizedBox(width: columns[i].width, child: _cell(cells, i))
              : Expanded(flex: columns[i].flex, child: _cell(cells, i)),
      ],
    );
  }

  Widget _cell(List<Widget> cells, int index) =>
      Align(alignment: Alignment.centerLeft, child: index < cells.length ? cells[index] : null);
}
