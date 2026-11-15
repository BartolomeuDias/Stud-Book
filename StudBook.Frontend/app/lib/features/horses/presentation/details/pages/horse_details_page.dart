import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/theme/extensions/status_colors.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/tokens/app_dimens.dart';
import '../../../../../core/utils/date_format.dart';
import '../../../../../core/utils/load_status.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_page.dart';
import '../../../../../core/widgets/app_state_views.dart';
import '../../../../../core/widgets/app_surfaces.dart';
import '../../../../../core/widgets/app_tags.dart';
import '../../../domain/entities/horse.dart';
import '../../horse_strings.dart';
import '../bloc/horse_details_bloc.dart';
import '../widgets/pedigree_chart.dart';

class HorseDetailsPage extends StatelessWidget {
  const HorseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HorseDetailsBloc, HorseDetailsState>(
      listenWhen: (previous, current) => previous.removal != current.removal,
      listener: (context, state) {
        if (state.removal == SubmitStatus.success) {
          showAppSnackBar(context, HorseStrings.removed);
          context.go(AppRoutes.registry);
        } else if (state.removal == SubmitStatus.failure) {
          showAppSnackBar(context, state.removalFailure!.message);
        }
      },
      builder: (context, state) {
        final horse = state.horse;
        if (horse != null) return _HorseView(horse: horse, state: state);
        return AppPage(
          children: [
            const _Breadcrumbs(current: HorseStrings.details),
            if (state.status.isFailure)
              AppErrorView(
                message: state.failure is NotFoundFailure
                    ? HorseStrings.notFound
                    : state.failure!.message,
                onRetry: () => context.read<HorseDetailsBloc>().add(const HorseDetailsRequested()),
              )
            else
              const AppLoadingView(),
          ],
        );
      },
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.current, this.category});

  final String current;
  final HorseCategory? category;

  @override
  Widget build(BuildContext context) {
    return AppBreadcrumbs(
      items: [
        AppBreadcrumb(label: HorseStrings.registry, onTap: () => context.go(AppRoutes.registry)),
        if (category != null && category != HorseCategory.ancestor)
          AppBreadcrumb(
            label: HorseStrings.categoryPlural(category!),
            onTap: () => context.go(AppRoutes.registryCategory(category!)),
          ),
        AppBreadcrumb(label: current),
      ],
    );
  }
}

class _HorseView extends StatelessWidget {
  const _HorseView({required this.horse, required this.state});

  final HorseDetails horse;
  final HorseDetailsState state;

  @override
  Widget build(BuildContext context) {
    final removing = state.removal.isSubmitting;
    return AppPage(
      children: [
        AppPageHeader(
          leading: _Breadcrumbs(current: horse.name, category: horse.category),
          overline:
              '${HorseStrings.category(horse.category)} · ${HorseStrings.sexLabel(horse.sex)}',
          title: horse.name,
          subtitle: horse.registrationNumber,
          subtitleMono: true,
          actions: [
            if (horse.isActive)
              AppButton.tertiary(
                label: HorseStrings.remove,
                icon: Icons.archive_outlined,
                isLoading: removing,
                onPressed: () => _confirmRemoval(context),
              ),
            AppButton.secondary(
              label: HorseStrings.edit,
              icon: Icons.edit_outlined,
              onPressed: removing ? null : () => _edit(context),
            ),
          ],
        ),
        if (!horse.isActive) const AppBanner(tone: AppTone.warning, title: HorseStrings.inactive),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.surfaces.blockGap,
          children: [
            Expanded(
              flex: _summaryFlex,
              child: _SummaryCard(horse: horse),
            ),
            Expanded(
              flex: _notesFlex,
              child: _NotesCard(notes: horse.notes),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.surfaces.blockGap,
          children: [
            const AppSectionHeader(mark: '§1', title: HorseStrings.pedigree),
            PedigreeChart(horse: horse, onOpen: (id) => context.push(AppRoutes.horse(id))),
            Text(HorseStrings.pedigreeHint, style: context.text.bodySmall),
          ],
        ),
      ],
    );
  }

  static const _summaryFlex = 3;
  static const _notesFlex = 2;

  Future<void> _edit(BuildContext context) async {
    final bloc = context.read<HorseDetailsBloc>();
    await context.push<void>(AppRoutes.horseEdit(horse.id));
    bloc.add(const HorseDetailsRequested());
  }

  Future<void> _confirmRemoval(BuildContext context) async {
    final bloc = context.read<HorseDetailsBloc>();
    final confirmed = await showAppConfirmDialog(
      context,
      title: HorseStrings.removeTitle,
      message: HorseStrings.removeMessage,
      confirmLabel: HorseStrings.remove,
      cancelLabel: HorseStrings.cancel,
      destructive: true,
    );
    if (confirmed) bloc.add(const HorseRemovalRequested());
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.horse});

  final HorseDetails horse;

  @override
  Widget build(BuildContext context) {
    final owner = horse.category == HorseCategory.ownStallion
        ? HorseStrings.ranchOwner
        : HorseStrings.orNone(horse.ownerName);
    final entries = [
      AppKeyValue(label: HorseStrings.sex, value: HorseStrings.sexLabel(horse.sex)),
      AppKeyValue(label: HorseStrings.breed, value: HorseStrings.orNone(horse.breed)),
      AppKeyValue(label: HorseStrings.color, value: HorseStrings.orNone(horse.color)),
      AppKeyValue(
        label: HorseStrings.foaled,
        value: horse.dateOfBirth == null
            ? HorseStrings.none
            : AppDateFormat.display(horse.dateOfBirth!),
      ),
      AppKeyValue(
        label: HorseStrings.registration,
        value: HorseStrings.orNone(horse.registrationNumber),
        mono: true,
      ),
      AppKeyValue(label: HorseStrings.owner, value: owner),
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          Row(
            children: [
              Expanded(child: Text(HorseStrings.details, style: context.text.titleLarge)),
              AppTag(
                label: HorseStrings.category(horse.category),
                tone: HorseStrings.categoryTone(horse.category),
              ),
            ],
          ),
          const Divider(),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth - AppSpacing.s24 * (AppLayout.detailColumns - 1)) /
                  AppLayout.detailColumns;
              return Wrap(
                spacing: AppSpacing.s24,
                runSpacing: AppSpacing.s16,
                children: [for (final entry in entries) SizedBox(width: itemWidth, child: entry)],
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppStatusBadge(
              label: horse.isActive ? HorseStrings.active : HorseStrings.inactive,
              tone: horse.isActive ? AppTone.success : AppTone.neutral,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final empty = notes.trim().isEmpty;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          Text(HorseStrings.notes, style: context.text.titleLarge),
          const Divider(),
          Text(
            empty ? HorseStrings.noNotes : notes,
            style: context.text.bodyMedium?.copyWith(
              color: empty ? context.colors.onSurfaceVariant : null,
            ),
          ),
        ],
      ),
    );
  }
}
