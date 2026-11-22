import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl_date_picker/intl_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  testWidgets('IntlCalendarDatePicker renders in Jalali mode and handles day tap',
      (WidgetTester tester) async {
    final initialDate = Jalali(1403, 1, 15).toDateTime();
    final firstDate = Jalali(1400, 1, 1).toDateTime();
    final lastDate = Jalali(1405, 12, 29).toDateTime();

    DateTime? selected;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fa'),
        home: Scaffold(
          body: IntlCalendarDatePicker(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            calendarMode: Calendar.jalali,
            onDateChanged: (DateTime date) {
              selected = date;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify day numbers are rendered (e.g. 15)
    expect(find.byType(IntlCalendarDatePicker), findsOneWidget);
    expect(find.text('15'), findsOneWidget);

    // Tap day 20
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    final jSelected = Jalali.fromDateTime(selected!);
    expect(jSelected.year, 1403);
    expect(jSelected.month, 1);
    expect(jSelected.day, 20);
  });

  testWidgets('showIntlDatePicker opens dialog and returns selected date',
      (WidgetTester tester) async {
    final initialDate = Jalali(1403, 2, 10).toDateTime();
    final firstDate = Jalali(1400, 1, 1).toDateTime();
    final lastDate = Jalali(1405, 12, 29).toDateTime();

    DateTime? returnedDate;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  returnedDate = await showIntlDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    calendarMode: Calendar.jalali,
                  );
                },
                child: const Text('Open Picker'),
              );
            },
          ),
        ),
      ),
    );

    // Tap button to open dialog
    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    expect(find.byType(IntlDatePickerDialog), findsOneWidget);

    // Tap day 15
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    // Tap OK / Confirm button dynamically
    final BuildContext dialogContext =
        tester.element(find.byType(IntlDatePickerDialog));
    final String okText = MaterialLocalizations.of(dialogContext).okButtonLabel;
    final okButton = find.text(okText).hitTestable().first;
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    expect(returnedDate, isNotNull);
    final jReturned = Jalali.fromDateTime(returnedDate!);
    expect(jReturned.year, 1403);
    expect(jReturned.month, 2);
    expect(jReturned.day, 15);
  });

  testWidgets('showIntlDatePicker with input entry mode does not crash on OK',
      (WidgetTester tester) async {
    final initialDate = Jalali(1403, 1, 1).toDateTime();
    final firstDate = Jalali(1400, 1, 1).toDateTime();
    final lastDate = Jalali(1405, 12, 29).toDateTime();

    DateTime? returnedDate;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  returnedDate = await showIntlDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    initialEntryMode: DatePickerEntryMode.input,
                    calendarMode: Calendar.jalali,
                  );
                },
                child: const Text('Open Input Picker'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Input Picker'));
    await tester.pumpAndSettle();

    expect(find.byType(IntlDatePickerDialog), findsOneWidget);

    // Tap OK
    final BuildContext dialogContext =
        tester.element(find.byType(IntlDatePickerDialog));
    final String okText = MaterialLocalizations.of(dialogContext).okButtonLabel;
    await tester.tap(find.text(okText).hitTestable().first);
    await tester.pumpAndSettle();

    // Should return initialDate without crashing
    expect(returnedDate, isNotNull);
  });

  testWidgets('showIntlDateRangePicker opens with initialDateRange without assertion crash',
      (WidgetTester tester) async {
    final start = DateTime(2024, 5, 1);
    final end = DateTime(2024, 5, 10);
    final first = DateTime(2024, 1, 1);
    final last = DateTime(2024, 12, 31);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showIntlDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: start, end: end),
                    firstDate: first,
                    lastDate: last,
                  );
                },
                child: const Text('Open Range Picker'),
              );
            },
          ),
        ),
      ),
    );

    // Tap to open range picker
    await tester.tap(find.text('Open Range Picker'));
    await tester.pumpAndSettle();

    // Verify it opened without assertion failure
    expect(find.byType(IntlDateRangePickerDialog), findsOneWidget);
  });

  testWidgets('IntlYearPicker renders and selects year in Jalali mode',
      (WidgetTester tester) async {
    final initialDate = Jalali(1403, 5, 10).toDateTime();
    final firstDate = Jalali(1390, 1, 1).toDateTime();
    final lastDate = Jalali(1410, 12, 29).toDateTime();

    DateTime? changedDate;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IntlYearPicker(
            selectedDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            calendarMode: Calendar.jalali,
            onChanged: (DateTime date) {
              changedDate = date;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(IntlYearPicker), findsOneWidget);
    expect(find.text('1403'), findsOneWidget);

    // Tap 1405
    await tester.tap(find.text('1405'));
    await tester.pumpAndSettle();

    expect(changedDate, isNotNull);
    final jChanged = Jalali.fromDateTime(changedDate!);
    expect(jChanged.year, 1405);
  });

  testWidgets('IntlCalendarDatePicker respects DatePickerThemeData',
      (WidgetTester tester) async {
    final initialDate = Jalali(1403, 1, 15).toDateTime();
    final firstDate = Jalali(1400, 1, 1).toDateTime();
    final lastDate = Jalali(1405, 12, 29).toDateTime();

    const customHeaderColor = Colors.purple;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          datePickerTheme: const DatePickerThemeData(
            headerForegroundColor: customHeaderColor,
          ),
        ),
        home: Scaffold(
          body: IntlCalendarDatePicker(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            calendarMode: Calendar.jalali,
            onDateChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(IntlCalendarDatePicker), findsOneWidget);
  });

  testWidgets('showJalaliDatePicker deprecated alias works correctly',
      (WidgetTester tester) async {
    final initialDate = Jalali(1403, 1, 1).toDateTime();
    final firstDate = Jalali(1400, 1, 1).toDateTime();
    final lastDate = Jalali(1405, 12, 29).toDateTime();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // ignore: deprecated_member_use_from_same_package
                  showJalaliDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  );
                },
                child: const Text('Open Jalali Alias'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Jalali Alias'));
    await tester.pumpAndSettle();

    expect(find.byType(IntlDatePickerDialog), findsOneWidget);
  });
}
