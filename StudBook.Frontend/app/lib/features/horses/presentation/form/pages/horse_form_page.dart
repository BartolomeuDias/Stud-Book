import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/theme/extensions/status_colors.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/tokens/app_dimens.dart';
import '../../../../../core/utils/load_status.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_field.dart';
import '../../../../../core/widgets/app_page.dart';
import '../../../../../core/widgets/app_shake.dart';
import '../../../../../core/widgets/app_state_views.dart';
import '../../../../../core/widgets/app_surfaces.dart';
import '../../../domain/entities/horse.dart';
import '../../horse_strings.dart';
import '../bloc/horse_form_bloc.dart';

class HorseFormPage extends StatelessWidget {
  const HorseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HorseFormBloc, HorseFormState>(
      listenWhen: (previous, current) => previous.submit != current.submit,
      listener: (context, state) {
        if (state.submit == SubmitStatus.success) {
          showAppSnackBar(context, HorseStrings.saved);
          final id = state.savedHorseId!;
          if (state.isEdit && context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(AppRoutes.horse(id));
          }
        }
      },
      builder: (context, state) {
        final title = state.isEdit ? HorseStrings.editTitle : HorseStrings.addTitle;
        return AppPage(
          maxWidth: AppSizes.formMaxWidth,
          children: [
            AppPageHeader(
              leading: AppBreadcrumbs(
                items: [
                  AppBreadcrumb(
                    label: HorseStrings.registry,
                    onTap: () => context.go(AppRoutes.registry),
                  ),
                  if (state.isEdit && state.originalName != null)
                    AppBreadcrumb(label: state.originalName!, onTap: () => context.pop()),
                  AppBreadcrumb(label: title),
                ],
              ),
              title: state.isEdit ? state.originalName ?? title : title,
              subtitle: state.isEdit ? HorseStrings.editTitle : HorseStrings.addSubtitle,
            ),
            if (state.status.isFailure)
              AppErrorView(
                message: '${HorseStrings.optionsFailed}. ${state.loadFailure!.message}',
                onRetry: () => context.read<HorseFormBloc>().add(const HorseFormStarted()),
              )
            else if (state.status.isLoading)
              const AppLoadingView()
            else
              _HorseForm(state: state),
          ],
        );
      },
    );
  }
}

class _HorseForm extends StatefulWidget {
  const _HorseForm({required this.state});

  final HorseFormState state;

  @override
  State<_HorseForm> createState() => _HorseFormState();
}

class _HorseFormState extends State<_HorseForm> {
  final _keys = {for (final field in HorseFormField.values) field: GlobalKey()};
  final _focus = {for (final field in HorseFormField.values) field: FocusNode()};

  HorseFormState get state => widget.state;

  @override
  void dispose() {
    for (final node in _focus.values) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _revealFirstInvalid(HorseFormState state) async {
    final field = state.firstInvalid;
    final target = field == null ? null : _keys[field]!.currentContext;
    if (field == null || target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: AppDurations.scrollToField,
      curve: AppMotion.scrollCurve,
      alignment: AppMotion.scrollAlignment,
    );
    _focus[field]!.requestFocus();
  }

  Widget _attention(HorseFormField field, Widget child) => KeyedSubtree(
    key: _keys[field],
    child: AppShake(trigger: state.hasError(field) ? state.validationAttempt : 0, child: child),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<HorseFormBloc, HorseFormState>(
      listenWhen: (previous, current) => previous.validationAttempt != current.validationAttempt,
      listener: (context, state) => _revealFirstInvalid(state),
      child: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    final bloc = context.read<HorseFormBloc>();
    final draft = state.draft;
    void update(HorseDraft next) => bloc.add(HorseFormChanged(next));
    String? error(HorseFormField field) => state.hasError(field) ? HorseStrings.required : null;
    final ownerEnabled = draft.category.requiresOwner;
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.surfaces.blockGap,
      children: [
        if (state.submit == SubmitStatus.failure)
          AppBanner(
            tone: AppTone.error,
            title: HorseStrings.saveFailed,
            message: state.submitFailure!.message,
          ),
        _FormSection(
          mark: '§1',
          title: HorseStrings.sectionIdentity,
          rows: [
            [
              _attention(
                HorseFormField.name,
                AppTextField(
                  label: HorseStrings.name,
                  focusNode: _focus[HorseFormField.name],
                  hint: HorseStrings.nameHint,
                  helper: HorseStrings.nameHelper,
                  initialValue: draft.name,
                  error: error(HorseFormField.name),
                  autofocus: !state.isEdit,
                  onChanged: (value) => update(draft.copyWith(name: value)),
                ),
              ),
              AppTextField(
                label: HorseStrings.registration,
                hint: HorseStrings.registrationHint,
                helper: HorseStrings.registrationHelper,
                initialValue: draft.registrationNumber,
                monospace: true,
                onChanged: (value) => update(draft.copyWith(registrationNumber: value)),
              ),
            ],
            [
              AppDropdown<HorseCategory>(
                label: HorseStrings.categoryField,
                value: draft.category,
                items: [
                  for (final category in HorseCategoryRules.registry)
                    AppDropdownItem(value: category, label: HorseStrings.category(category)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  update(
                    draft.copyWith(
                      category: value,
                      ownerClientId: value.requiresOwner ? null : () => null,
                    ),
                  );
                },
              ),
              AppDropdown<HorseSex>(
                label: HorseStrings.sex,
                value: draft.sex,
                items: [
                  for (final sex in HorseSex.values)
                    AppDropdownItem(value: sex, label: HorseStrings.sexLabel(sex)),
                ],
                onChanged: (value) {
                  if (value != null) update(draft.copyWith(sex: value));
                },
              ),
            ],
            [
              _attention(
                HorseFormField.breed,
                AppTextField(
                  label: HorseStrings.breed,
                  focusNode: _focus[HorseFormField.breed],
                  hint: HorseStrings.breedHint,
                  initialValue: draft.breed,
                  error: error(HorseFormField.breed),
                  onChanged: (value) => update(draft.copyWith(breed: value)),
                ),
              ),
              _attention(
                HorseFormField.color,
                AppTextField(
                  label: HorseStrings.color,
                  focusNode: _focus[HorseFormField.color],
                  hint: HorseStrings.colorHint,
                  initialValue: draft.color,
                  error: error(HorseFormField.color),
                  onChanged: (value) => update(draft.copyWith(color: value)),
                ),
              ),
            ],
            [
              AppDateField(
                label: HorseStrings.foaled,
                hint: HorseStrings.foaledHint,
                clearTooltip: HorseStrings.clearDate,
                value: draft.dateOfBirth,
                firstDate: DateTime(_firstFoalingYear),
                lastDate: today,
                onChanged: (value) => update(draft.copyWith(dateOfBirth: () => value)),
              ),
              const SizedBox.shrink(),
            ],
          ],
        ),
        _FormSection(
          mark: '§2',
          title: HorseStrings.sectionOwnership,
          rows: [
            [
              _attention(
                HorseFormField.owner,
                AppDropdown<int?>(
                  label: HorseStrings.owner,
                  enabled: ownerEnabled,
                  focusNode: _focus[HorseFormField.owner],
                  hint: ownerEnabled ? HorseStrings.ownerHint : HorseStrings.ranchOwner,
                  helper: ownerEnabled
                      ? HorseStrings.ownerHelperClient
                      : HorseStrings.ownerHelperOwn,
                  error: error(HorseFormField.owner),
                  value: draft.ownerClientId,
                  items: [
                    for (final client in state.clients)
                      AppDropdownItem(value: client.id, label: client.name),
                  ],
                  onChanged: (value) => update(draft.copyWith(ownerClientId: () => value)),
                ),
              ),
              const SizedBox.shrink(),
            ],
          ],
        ),
        _FormSection(
          mark: '§3',
          title: HorseStrings.sectionPedigree,
          rows: [
            [
              _ParentDropdown(
                label: HorseStrings.sire,
                helper: HorseStrings.sireHelper,
                options: state.sires,
                value: draft.sireId,
                onChanged: (value) => update(draft.copyWith(sireId: () => value)),
              ),
              _ParentDropdown(
                label: HorseStrings.dam,
                helper: HorseStrings.damHelper,
                options: state.dams,
                value: draft.damId,
                onChanged: (value) => update(draft.copyWith(damId: () => value)),
              ),
            ],
          ],
        ),
        _FormSection(
          mark: '§4',
          title: HorseStrings.sectionNotes,
          rows: [
            [
              AppTextField(
                label: HorseStrings.notes,
                hint: HorseStrings.notesHint,
                initialValue: draft.notes,
                maxLines: _notesLines,
                onChanged: (value) => update(draft.copyWith(notes: value)),
              ),
            ],
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: AppSpacing.s12,
          children: [
            AppButton.tertiary(
              label: HorseStrings.cancel,
              onPressed: state.submit.isSubmitting ? null : () => _cancel(context),
            ),
            AppButton(
              label: state.isEdit ? HorseStrings.saveChanges : HorseStrings.save,
              icon: Icons.check,
              isLoading: state.submit.isSubmitting,
              onPressed: () => bloc.add(const HorseFormSubmitted()),
            ),
          ],
        ),
      ],
    );
  }

  static const _firstFoalingYear = 1980;
  static const _notesLines = 4;

  void _cancel(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.registry);
    }
  }
}

class _ParentDropdown extends StatelessWidget {
  const _ParentDropdown({
    required this.label,
    required this.helper,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String helper;
  final List<ParentOption> options;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppDropdown<int?>(
      label: label,
      helper: helper,
      value: value,
      items: [
        const AppDropdownItem(value: null, label: HorseStrings.notSpecified),
        for (final option in options)
          AppDropdownItem(
            value: option.id,
            label: option.registrationNumber == null
                ? option.name
                : '${option.name} · ${option.registrationNumber}',
          ),
      ],
      onChanged: onChanged,
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.mark, required this.title, required this.rows});

  final String mark;
  final String title;
  final List<List<Widget>> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s24,
        children: [
          AppSectionHeader(mark: mark, title: title),
          for (final row in rows)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s24,
              children: [for (final field in row) Expanded(child: field)],
            ),
        ],
      ),
    );
  }
}
