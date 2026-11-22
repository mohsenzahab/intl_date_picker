---
name: intl-date-picker
description: >-
  Guides AI agents in discovering, configuring, and utilizing the `intl_date_picker`
  Flutter package for Jalali (Solar Hijri / Shamsi) and Gregorian date picking,
  date range selection, and inline internationalized calendars with Material 3 theming.
---

# intl_date_picker: Internationalized Date & Range Picker Skill

The `intl_date_picker` package provides an internationalized, Material 3 compatible date and date range picker for Flutter with native support for both **Jalali (Solar Hijri / شمسی)** and **Gregorian (میلادی)** calendars, complete with English and Persian localizations.

Use this Skill whenever implementing date pickers, date range pickers, or calendar widgets in Flutter projects requiring Persian/Jalali or bilingual date selection.

---

## 1. Discovery & Dependencies

Before implementing a date picker in a Flutter project:

1. **Check `pubspec.yaml`**: Confirm that `intl_date_picker` and `shamsi_date` are declared:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_localizations:
       sdk: flutter
     intl_date_picker: ^1.0.0
     shamsi_date: ^1.0.2
   ```
2. **Ensure Localization Setup**: Pickers require `MaterialLocalizations` in context. Ensure the app configures delegates:
   ```dart
   MaterialApp(
     localizationsDelegates: const [
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
     supportedLocales: const [
       Locale('fa'),
       Locale('en'),
     ],
     // ...
   )
   ```

---

## 2. Import Protocol

Import the main package library:

```dart
import 'package:intl_date_picker/intl_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart'; // when converting to/from Jalali
```

---

## 3. Core APIs & Usage Patterns

### A. Modal Single Date Picker (`showIntlDatePicker`)

Use to display a modal date picker dialog supporting Jalali or Gregorian calendars:

```dart
final DateTime? picked = await showIntlDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2040),
  calendarMode: Calendar.jalali, // Calendar.jalali or Calendar.gregorian
  locale: const Locale('fa'),    // Locale('fa') or Locale('en')
  initialDatePickerMode: DatePickerMode.day,
  initialEntryMode: DatePickerEntryMode.calendar, // or DatePickerEntryMode.input
);

if (picked != null) {
  // Convert to Jalali if needed:
  final Jalali jalaliDate = Jalali.fromDateTime(picked);
  print('Selected Jalali: ${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}');
}
```

### B. Modal Date Range Picker (`showIntlDateRangePicker`)

Use to display a modal date range picker dialog:

```dart
final DateTimeRange? range = await showIntlDateRangePicker(
  context: context,
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  ),
  firstDate: DateTime(2000),
  lastDate: DateTime(2040),
  locale: const Locale('fa'),
);

if (range != null) {
  print('Start: ${range.start}, End: ${range.end}');
}
```

### C. Inline Calendar Widget (`IntlCalendarDatePicker`)

Use to embed an interactive calendar grid directly into an existing screen or card:

```dart
IntlCalendarDatePicker(
  initialDate: _currentSelectedDate,
  firstDate: DateTime(2000),
  lastDate: DateTime(2040),
  calendarMode: Calendar.jalali, // or Calendar.gregorian
  onDateChanged: (DateTime newDate) {
    setState(() {
      _currentSelectedDate = newDate;
    });
  },
)
```

### D. Dedicated Year Picker (`IntlYearPicker`)

Use when only year selection is needed:

```dart
IntlYearPicker(
  selectedDate: _currentDate,
  firstDate: DateTime(2000),
  lastDate: DateTime(2040),
  calendarMode: Calendar.jalali,
  onChanged: (DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  },
)
```

---

## 4. Material 3 Theming Integration

`intl_date_picker` seamlessly integrates with Flutter's `DatePickerThemeData`:

```dart
ThemeData(
  useMaterial3: true,
  datePickerTheme: DatePickerThemeData(
    headerBackgroundColor: Colors.deepPurple,
    headerForegroundColor: Colors.white,
    backgroundColor: Colors.surface,
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      return null;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.deepPurple;
      return null;
    }),
  ),
)
```

---

## 5. Critical Agent Guidelines & Gotchas

1. **Jalali Date Conversion**: All Flutter pickers exchange native Dart `DateTime` instances. To display Jalali representations or read year/month/day, use `Jalali.fromDateTime(dateTime)`. To create a `DateTime` from Jalali year/month/day, use `Jalali(year, month, day).toDateTime()`.
2. **YearPicker Name Collision**: In versions >= 1.0.0, the widget is named `IntlYearPicker` to avoid colliding with `flutter/material.dart`'s `YearPicker`.
3. **Locale Requirement**: Always ensure `Locale('fa')` or `Locale('en')` is provided either via the picker's `locale` parameter or the surrounding `MaterialApp(locale: ...)` with `GlobalMaterialLocalizations`.
4. **Range Picker Assertion Safety**: In version >= 1.0.0, passing non-null `initialDateRange` is fully supported and will not crash.
