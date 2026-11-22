# intl_date_picker

A versatile, internationalized Date and Date Range Picker for Flutter with native support for both **Jalali (Solar Hijri / شمسی)** and **Gregorian (میلادی)** calendars, alongside English and Persian localizations.

Designed as an upgraded drop-in alternative to Flutter's native date pickers, fully compatible with **Material 3** and modern Flutter standards.

---

## Features

- 📅 **Dual Calendar Support**: Switch smoothly between Jalali (`Calendar.jalali`) and Gregorian (`Calendar.gregorian`).
- 🌐 **Bilingual Localizations**: Fully tested with Persian (`fa`) and English (`en`) languages, including proper RTL/LTR layout transitions.
- 🎨 **Material 3 Ready**: Honors `ThemeData.datePickerTheme` (`DatePickerThemeData`) including header colors, shape, day styles, and year styling.
- 📆 **Multiple Modes**:
  - Dialog Single Date Picker (`showIntlDatePicker`)
  - Dialog Date Range Picker (`showIntlDateRangePicker`)
  - Standalone / Inline Calendar Widget (`IntlCalendarDatePicker`)
  - Year Selector (`IntlYearPicker`)
- ⌨️ **Input & Calendar Entry Modes**: Supports both visual calendar grid selection and direct keyboard date entry (`DatePickerEntryMode.input`).
- 🛡️ **Robust Arithmetic**: Handles leap years, differing month lengths, and month-end transitions reliably.

---

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl_date_picker: ^1.0.0
  flutter_localizations:
    sdk: flutter
```

Import the package:

```dart
import 'package:intl_date_picker/intl_date_picker.dart';
```

---

## Usage Examples

### 1. Showing a Jalali Date Picker Dialog

```dart
final DateTime? selectedDate = await showIntlDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  calendarMode: Calendar.jalali, // or Calendar.gregorian
  locale: const Locale('fa'),    // or const Locale('en')
);

if (selectedDate != null) {
  print('Selected: $selectedDate');
}
```

### 2. Showing a Date Range Picker Dialog

```dart
final DateTimeRange? selectedRange = await showIntlDateRangePicker(
  context: context,
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  ),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  calendarMode: Calendar.jalali,
  locale: const Locale('fa'),
);

if (selectedRange != null) {
  print('From ${selectedRange.start} to ${selectedRange.end}');
}
```

### 3. Using the Calendar Widget Inline

```dart
IntlCalendarDatePicker(
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  calendarMode: Calendar.jalali,
  onDateChanged: (DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  },
)
```

### 4. Customizing with Material 3 Theme

```dart
ThemeData(
  useMaterial3: true,
  datePickerTheme: DatePickerThemeData(
    headerBackgroundColor: Colors.teal,
    headerForegroundColor: Colors.white,
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.teal;
      }
      return null;
    }),
  ),
)
```

---

## Migration from Previous Versions

- `YearPicker` has been renamed to `IntlYearPicker` to avoid name collisions with Flutter Material's `YearPicker`. A deprecated `YearPicker` typedef remains available during migration.
- `showJalaliDatePicker` and `showJalaliDateRangePicker` are preserved as deprecated aliases pointing to `showIntlDatePicker` and `showIntlDateRangePicker` with `calendarMode: Calendar.jalali`.
