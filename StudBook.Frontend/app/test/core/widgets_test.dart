import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studbook_app/core/theme/app_theme.dart';
import 'package:studbook_app/core/theme/extensions/status_colors.dart';
import 'package:studbook_app/core/widgets/app_button.dart';
import 'package:studbook_app/core/widgets/app_field.dart';
import 'package:studbook_app/core/widgets/app_tags.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('shared controls build and open without assertion errors', (tester) async {
    int? picked;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Column(
            children: [
              AppButton(label: 'Save', onPressed: () {}),
              const AppTag(label: 'Own stallion', tone: AppTone.primary),
              const AppStatusBadge(label: 'In registry', tone: AppTone.success),
              AppDropdown<int>(
                label: 'Sex',
                value: 1,
                items: const [
                  AppDropdownItem(value: 1, label: 'Mare'),
                  AppDropdownItem(value: 2, label: 'Stallion'),
                ],
                onChanged: (value) => picked = value,
              ),
              const AppTextField(label: 'Horse name'),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mare'));
    await tester.pumpAndSettle();

    expect(find.text('Stallion'), findsOneWidget);

    await tester.tap(find.text('Stallion'));
    await tester.pump(const Duration(milliseconds: 60));
    expect(picked, 2);
    expect(find.text('Stallion'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Stallion'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
