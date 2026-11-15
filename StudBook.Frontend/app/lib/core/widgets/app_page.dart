import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens/app_dimens.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.children, this.maxWidth = AppSizes.contentMaxWidth});

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaces;
    return SingleChildScrollView(
      padding: surfaces.pagePadding,
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: surfaces.sectionGap,
            children: children,
          ),
        ),
      ),
    );
  }
}
