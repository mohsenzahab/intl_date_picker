import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../enums/calendar_mode.dart';
import '../localization/strings_en.dart';
import '../localization/strings_fa.dart';

class IntlDateUtils {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  IntlDateUtils._();

  static const List<String> _standaloneWeekdaysFa = <String>[
    'یک‌شنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنج‌شنبه',
    'جمعه',
    'شنبه',
  ];

  static const List<String> _standaloneWeekdaysEn = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static const List<String> _gregorianMonthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Returns a [DateTime] with the date of the original, but time set to
  /// midnight.
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns a [DateTimeRange] with the dates of the original, but with times
  /// set to midnight.
  ///
  /// See also:
  ///  * [dateOnly], which does the same thing for a single date.
  static DateTimeRange datesOnly(DateTimeRange range) {
    return DateTimeRange(
      start: dateOnly(range.start),
      end: dateOnly(range.end),
    );
  }

  /// Returns true if the two [DateTime] objects have the same day, month, and
  /// year, or are both null.
  static bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  /// Returns true if the two [DateTime] objects have the same month and
  /// year, or are both null.
  static bool isSameMonth(
      DateTime? dateA, DateTime? dateB, Calendar calendarMode) {
    if (dateA == null || dateB == null) {
      return dateA == dateB;
    }
    if (calendarMode == Calendar.gregorian) {
      return dateA.year == dateB.year && dateA.month == dateB.month;
    } else {
      final a = Jalali.fromDateTime(dateA);
      final b = Jalali.fromDateTime(dateB);
      return a.year == b.year && a.month == b.month;
    }
  }

  /// Determines the number of months between two [DateTime] objects.
  ///
  /// For example:
  /// ```
  /// DateTime date1 = DateTime(year: 2019, month: 6, day: 15);
  /// DateTime date2 = DateTime(year: 2020, month: 1, day: 15);
  /// int delta = monthDelta(date1, date2, Calendar.gregorian);
  /// ```
  ///
  /// The value for `delta` would be `7`.
  static int monthDelta(
      DateTime startDate, DateTime endDate, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return (endDate.year - startDate.year) * 12 +
            endDate.month -
            startDate.month;
      case Calendar.jalali:
        final s = Jalali.fromDateTime(startDate);
        final e = Jalali.fromDateTime(endDate);
        return (e.year - s.year) * 12 + e.month - s.month;
    }
  }

  /// Returns a [DateTime] that is [monthDate] with the added number
  /// of months and the day set to 1 and time set to midnight.
  static DateTime addMonthsToMonthDate(
      DateTime monthDate, int monthsToAdd, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return DateTime(monthDate.year, monthDate.month + monthsToAdd, 1);
      case Calendar.jalali:
        return Jalali.fromDateTime(monthDate)
            .copy(day: 1)
            .addMonths(monthsToAdd)
            .toDateTime();
    }
  }

  /// Returns a [DateTime] with the added number of days and time set to
  /// midnight.
  static DateTime addDaysToDate(
      DateTime date, int days, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return DateTime(date.year, date.month, date.day + days);
      case Calendar.jalali:
        return Jalali.fromDateTime(date).addDays(days).toDateTime();
    }
  }

  /// Returns the first day of week for the input calendar.
  /// Saturday is 6, Sunday is 0, Monday is 1, etc.
  static int firstDayOfWeek(Calendar calendarMode,
      [MaterialLocalizations? localizations]) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return localizations?.firstDayOfWeekIndex ?? 0;
      case Calendar.jalali:
        return 6;
    }
  }

  /// Computes the offset from the first day of the week that the first day of
  /// the [month] falls on.
  static int firstDayOffset(DateTime date, Calendar calendarMode,
      MaterialLocalizations localizations) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = date.monthStartDate(calendarMode).weekday - 1;
    // 0-based start of week depending on the locale, with 0 representing Sunday.
    int firstDayOfWeekIndex = firstDayOfWeek(calendarMode, localizations);

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
  }

  /// Returns the number of days in a month according to the chosen calendar.
  static int getDaysInMonth(DateTime date, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return DateUtils.getDaysInMonth(date.year, date.month);
      case Calendar.jalali:
        return Jalali.fromDateTime(date).monthLength;
    }
  }

  /// Returns the translated number of year.
  static String formatYear(
      BuildContext context, DateTime date, Calendar calendarMode) {
    final lang = Localizations.localeOf(context).languageCode;
    final int year;
    switch (calendarMode) {
      case Calendar.gregorian:
        year = date.year;
        break;
      case Calendar.jalali:
        year = Jalali.fromDateTime(date).year;
        break;
    }
    return formatNumber(year.toString(), lang);
  }

  /// Returns translated month and year.
  static String formatMonthYear(
      BuildContext context, DateTime date, Calendar calendarMode) {
    final lang = Localizations.localeOf(context).languageCode;

    switch (calendarMode) {
      case Calendar.gregorian:
        return MaterialLocalizations.of(context).formatMonthYear(date);
      case Calendar.jalali:
        final d = Jalali.fromDateTime(date);
        if (lang.startsWith('fa')) {
          final f = d.formatter;
          final y = formatNumber(f.yyyy, 'fa');
          final m = StringsFa.defaultJalaliMonthNames[d.month - 1];
          return '$m $y';
        } else {
          final m = StringsEn.defaultJalaliMonthNames[d.month - 1];
          return '$m ${d.year}';
        }
    }
  }

  /// Returns the translation of the given number. If parsing fails, returns original string.
  static String formatNumber(String number, String languageCode,
      [String pattern = '']) {
    final parsed = int.tryParse(number);
    if (parsed == null) return number;
    try {
      return NumberFormat(pattern, languageCode).format(parsed);
    } catch (_) {
      return number;
    }
  }

  /// Returns a detailed date containing day, month and week day.
  static String formatMediumDate(
      BuildContext context, DateTime date, Calendar calendarMode) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (calendarMode) {
      case Calendar.gregorian:
        return MaterialLocalizations.of(context).formatMediumDate(date);
      case Calendar.jalali:
        final d = Jalali.fromDateTime(date);
        final weekDayIndex = date.weekday % 7;

        if (lang.startsWith('fa')) {
          final weekDayName = _standaloneWeekdaysFa[weekDayIndex];
          final m = StringsFa.defaultJalaliMonthNames[d.month - 1];
          return '$weekDayName، ${formatNumber(d.day.toString(), 'fa')} $m';
        } else {
          final weekDayName = _standaloneWeekdaysEn[weekDayIndex];
          final m = StringsEn.defaultJalaliMonthNames[d.month - 1];
          return '$weekDayName, $m ${d.day}';
        }
    }
  }

  /// Returns a detailed date formatted in y/M/dd.
  static String formatDate(
      BuildContext context, DateTime date, Calendar calendarMode) {
    final lang = Localizations.localeOf(context).languageCode;

    switch (calendarMode) {
      case Calendar.gregorian:
        return MaterialLocalizations.of(context).formatCompactDate(date);
      case Calendar.jalali:
        final d = Jalali.fromDateTime(date);
        final f = d.formatter;

        if (lang.startsWith('fa')) {
          const pattern = '00';
          final y = formatNumber(f.yyyy, 'fa', pattern);
          final m = formatNumber(f.mm, 'fa', pattern);
          final day = formatNumber(f.dd, 'fa', pattern);
          return '$y/$m/$day';
        } else {
          return '${f.yyyy}/${f.mm}/${f.dd}';
        }
    }
  }

  /// Returns locale month name for provided month number (1-12) and calendar.
  static String getMonthName(
      BuildContext context, int monthNumber, Calendar mode) {
    if (monthNumber < 1 || monthNumber > 12) return '';
    final locale = Localizations.localeOf(context);

    switch (mode) {
      case Calendar.gregorian:
        try {
          final format = DateFormat('', locale.languageCode);
          return format.dateSymbols.MONTHS[monthNumber - 1];
        } catch (_) {
          return _gregorianMonthNames[monthNumber - 1];
        }
      case Calendar.jalali:
        if (locale.languageCode.startsWith('fa')) {
          return StringsFa.defaultJalaliMonthNames[monthNumber - 1];
        } else {
          return StringsEn.defaultJalaliMonthNames[monthNumber - 1];
        }
    }
  }

  /// Returns converted month number (1-12) in locale calendar.
  static int getMonthNumber(DateTime date, Calendar calendar) {
    switch (calendar) {
      case Calendar.gregorian:
        return date.month;
      case Calendar.jalali:
        return Jalali.fromDateTime(date).month;
    }
  }

  /// Returns month date of provided calendar for the given month number of the
  /// calendar and in the given date year, with day set to 1.
  static DateTime getMonthDate(
      DateTime date, int monthNumber, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return DateTime(date.year, monthNumber, 1);
      case Calendar.jalali:
        return Jalali.fromDateTime(date)
            .copy(month: monthNumber, day: 1)
            .toDateTime();
    }
  }
}

extension DateHelperExtension on DateTime {
  DateTime monthStartDate(Calendar calendarMode) {
    if (calendarMode == Calendar.gregorian) {
      return DateTime(year, month, 1);
    } else {
      return Jalali.fromDateTime(this).copy(day: 1).toDateTime();
    }
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime addMonth(int count, Calendar calendarMode) {
    if (calendarMode == Calendar.gregorian) {
      return DateTime(year, month + count, 1);
    } else {
      return Jalali.fromDateTime(this)
          .copy(day: 1)
          .addMonths(count)
          .toDateTime();
    }
  }
}
