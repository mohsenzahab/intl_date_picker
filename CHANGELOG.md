# 1.0.0

- Modernized codebase to Dart 3 and Flutter 3.16+.
- Added full support for both Jalali (Solar Hijri) and Gregorian calendars across all picker modes.
- Fixed Jalali month arithmetic boundary issue when transitioning from 31-day months to shorter months.
- Replaced standalone weekday symbols dependency to eliminate `LocaleDataException` without requiring manual intl locale initialization.
- Renamed `YearPicker` to `IntlYearPicker` to resolve export collisions with Flutter's `material.dart`. Deprecated `YearPicker` typedef preserved for backwards compatibility.
- Added Material 3 theming support via `DatePickerThemeData`.
- Fixed range picker crash when passing non-null `initialDateRange`.
- Added `showIntlDateRangePicker` and deprecated alias `showJalaliDateRangePicker`.
- Added deprecated alias `showJalaliDatePicker` for seamless migration.
- Modernized internal constructors to `super.key`, `textScaler`, and `withValues`.
- Added unit and widget test suite covering core date utilities, dialogs, year pickers, and theming.
