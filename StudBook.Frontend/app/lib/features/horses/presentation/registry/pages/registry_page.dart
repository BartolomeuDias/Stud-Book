import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/tokens/app_dimens.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_fade_through_switcher.dart';
import '../../../../../core/widgets/app_field.dart';
import '../../../../../core/widgets/app_page.dart';
import '../../../../../core/widgets/app_state_views.dart';
import '../../../../../core/widgets/app_surfaces.dart';
import '../../../../../core/widgets/app_table.dart';
import '../../../../../core/widgets/app_tabs.dart';
import '../../../../../core/widgets/app_tags.dart';
import '../../../domain/entities/horse.dart';
import '../../horse_strings.dart';
import '../bloc/registry_bloc.dart';

class RegistryPage extends StatelessWidget {
  const RegistryPage({super.key});

  static const _tabs = <HorseCategory?>[null, ...HorseCategoryRules.registry];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistryBloc, RegistryState>(
      builder: (context, state) {
        final bloc = context.read<RegistryBloc>();
        return AppPage(
          children: [
            AppPageHeader(
              overline: HorseStrings.registryOverline,
              title: HorseStrings.registryTitle,
              subtitle: HorseStrings.registrySubtitle,
              actions: [
                AppButton(
                  label: HorseStrings.addHorse,
                  icon: Icons.add,
                  onPressed: () => _openForm(context),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: context.surfaces.blockGap,
              children: [
                AppTabs(
                  tabs: [
                    for (final category in _tabs)
                      AppTabItem(
                        label: category == null
                            ? HorseStrings.all
                            : HorseStrings.categoryPlural(category),
                        count: state.status.isSuccess ? state.countOf(category) : null,
                      ),
                  ],
                  selectedIndex: _tabs.indexOf(state.category),
                  onSelected: (index) => bloc.add(RegistryCategorySelected(_tabs[index])),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppSizes.searchFieldMaxWidth),
                    child: AppTextInput(
                      semanticLabel: HorseStrings.searchLabel,
                      hint: HorseStrings.searchHint,
                      prefixIcon: Icons.search,
                      onChanged: (value) => bloc.add(RegistrySearchChanged(value)),
                    ),
                  ),
                ),
                AppFadeThroughSwitcher(
                  child: _RegistryBody(
                    key: ValueKey((state.category, state.status)),
                    state: state,
                    onAdd: () => _openForm(context),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context) async {
    final bloc = context.read<RegistryBloc>();
    await context.push<void>(AppRoutes.horseNew);
    bloc.add(const RegistryRequested());
  }
}

class _RegistryBody extends StatelessWidget {
  const _RegistryBody({super.key, required this.state, required this.onAdd});

  final RegistryState state;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (state.status.isLoading) return const AppLoadingView();
    if (state.status.isFailure) {
      return AppErrorView(
        message: state.failure!.message,
        onRetry: () => context.read<RegistryBloc>().add(const RegistryRequested()),
      );
    }
    final visible = state.visible;
    if (state.inCategory.isEmpty) {
      return AppEmptyView(
        icon: Icons.menu_book_outlined,
        title: HorseStrings.emptyTitle,
        message: HorseStrings.emptyMessage,
        action: AppButton.secondary(
          label: HorseStrings.addHorse,
          icon: Icons.add,
          onPressed: onAdd,
        ),
      );
    }
    if (visible.isEmpty) {
      return const AppEmptyView(
        icon: Icons.search_off,
        title: HorseStrings.noMatchesTitle,
        message: HorseStrings.noMatchesMessage,
      );
    }
    return _RegistryTable(horses: visible, total: state.inCategory.length);
  }
}

class _RegistryTable extends StatelessWidget {
  const _RegistryTable({required this.horses, required this.total});

  static const _nameFlex = 5;
  static const _categoryFlex = 3;
  static const _breedFlex = 4;
  static const _ownerFlex = 4;
  static const _foaledFlex = 2;

  final List<HorseSummary> horses;
  final int total;

  @override
  Widget build(BuildContext context) {
    return AppTable(
      columns: const [
        AppTableColumn(label: HorseStrings.columnHorse, flex: _nameFlex),
        AppTableColumn(label: HorseStrings.columnCategory, flex: _categoryFlex),
        AppTableColumn(label: HorseStrings.columnBreed, flex: _breedFlex),
        AppTableColumn(label: HorseStrings.columnOwner, flex: _ownerFlex),
        AppTableColumn(label: HorseStrings.columnFoaled, flex: _foaledFlex),
        AppTableColumn(label: '', width: AppSizes.rowActionsWidth),
      ],
      rows: [
        for (final horse in horses)
          AppTableRow(
            onTap: () => _open(context, horse.id),
            cells: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(horse.name, style: context.text.titleSmall),
                  Text(
                    HorseStrings.meta(registration: horse.registrationNumber, sex: horse.sex),
                    style: context.textStyles.monoSmall,
                  ),
                ],
              ),
              AppTag(
                label: HorseStrings.category(horse.category),
                tone: HorseStrings.categoryTone(horse.category),
              ),
              Text(
                [horse.breed, horse.color].where((value) => value.isNotEmpty).join(' · '),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                horse.category == HorseCategory.ownStallion
                    ? HorseStrings.ranchOwner
                    : HorseStrings.orNone(horse.ownerName),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                horse.dateOfBirth == null
                    ? HorseStrings.none
                    : AppDateFormat.year(horse.dateOfBirth!),
                style: context.textStyles.mono,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: HorseStrings.edit,
                    onPressed: () => _edit(context, horse.id),
                  ),
                  AppIconButton(
                    icon: Icons.chevron_right,
                    tooltip: HorseStrings.open,
                    onPressed: () => _open(context, horse.id),
                  ),
                ],
              ),
            ],
          ),
      ],
      footer: Row(
        children: [
          const Expanded(child: Text(HorseStrings.sortedBy)),
          Text(HorseStrings.horsesCount(horses.length, total)),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context, int id) async {
    final bloc = context.read<RegistryBloc>();
    await context.push<void>(AppRoutes.horse(id));
    bloc.add(const RegistryRequested());
  }

  Future<void> _edit(BuildContext context, int id) async {
    final bloc = context.read<RegistryBloc>();
    await context.push<void>(AppRoutes.horseEdit(id));
    bloc.add(const RegistryRequested());
  }
}
