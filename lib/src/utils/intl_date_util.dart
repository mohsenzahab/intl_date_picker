import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../enums/calendar_mode.dart';
import '../localization/strings_en.dart';

class IntlDateUtils {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  IntlDateUtils._();

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
        start: dateOnly(range.start), end: dateOnly(range.end));
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
    if (calendarMode == Calendar.gregorian) {
      return dateA?.year == dateB?.year && dateA?.month == dateB?.month;
    } else {
      Jalali? a;
      if (dateA != null) a = Jalali.fromDateTime(dateA);
      Jalali? b;
      if (dateB != null) b = Jalali.fromDateTime(dateB);
      return a?.year == b?.year && a?.month == b?.month;
    }
  }

  /// Determines the number of months between two [DateTime] objects.
  ///
  /// For example:
  /// ```
  /// DateTime date1 = DateTime(year: 2019, month: 6, day: 15);
  /// DateTime date2 = DateTime(year: 2020, month: 1, day: 15);
  /// int delta = monthDelta(date1, date2);
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
        Jalali s = Jalali.fromDateTime(startDate);
        Jalali e = Jalali.fromDateTime(endDate);
        return (e.year - s.year) * 12 + e.month - s.month;
    }
  }

  /// Returns a [DateTime] that is [monthDate] with the added number
  /// of months and the day set to 1 and time set to midnight.
  ///
  /// For example:
  /// ```
  /// DateTime date = DateTime(year: 2019, month: 1, day: 15);
  /// DateTime futureDate = DateUtils.addMonthsToMonthDate(date, 3);
  /// ```
  ///
  /// `date` would be January 15, 2019.
  /// `futureDate` would be April 1, 2019 since it adds 3 months.
  static DateTime addMonthsToMonthDate(
      DateTime monthDate, int monthsToAdd, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return DateTime(monthDate.year, monthDate.month + monthsToAdd);
      case Calendar.jalali:
        return Jalali.fromDateTime(monthDate)
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

  /// Computes the offset from the first day of the week that the first day of
  /// the [month] falls on.
  ///
  /// For example, September 1, 2017 falls on a Friday, which in the calendar
  /// localized for United States English appears as:
  ///
  /// ```
  /// S M T W T F S
  /// _ _ _ _ _ 1 2
  /// ```
  ///
  /// The offset for the first day of the months is the number of leading blanks
  /// in the calendar, i.e. 5.
  ///
  /// The same date localized for the Russian calendar has a different offset,
  /// because the first day of week is Monday rather than Sunday:
  ///
  /// ```
  /// M T W T F S S
  /// _ _ _ _ 1 2 3
  /// ```
  ///
  /// So the offset is 4, rather than 5.
  ///
  /// This code consolidates the following:
  ///
  /// - [DateTime.weekday] provides a 1-based index into days of week, with 1
  ///   falling on Monday.
  /// - [MaterialLocalizations.firstDayOfWeekIndex] provides a 0-based index
  ///   into the [MaterialLocalizations.narrowWeekdays] list.
  /// - [MaterialLocalizations.narrowWeekdays] list provides localized names of
  ///   days of week, always starting with Sunday and ending with Saturday.
  static int firstDayOffset(DateTime date, Calendar calendarMode,
      MaterialLocalizations localizations) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = date.monthStartDate(calendarMode).weekday - 1;
    // 0-based start of week depending on the locale, with 0 representing Sunday.
    int firstDayOfWeekIndex = firstDayOfWeek(calendarMode);

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
  }

  /// returns the first day of week for the input calendar.
  static int firstDayOfWeek(Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return 0;
      case Calendar.jalali:
        return 6;
    }
  }

  /// Returns the number of days in a month, according to the proleptic
  /// Gregorian calendar.
  ///
  /// This applies the leap year logic introduced by the Gregorian reforms of
  /// 1582. It will not give valid results for dates prior to that time.
  static int getDaysInMonth(DateTime date, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        if (date.month == DateTime.february) {
          final bool isLeapYear =
              (date.year % 4 == 0) && (date.year % 100 != 0) ||
                  (date.year % 400 == 0);
          return isLeapYear ? 29 : 28;
        }
        const List<int> daysInMonth = <int>[
          31,
          -1,
          31,
          30,
          31,
          30,
          31,
          31,
          30,
          31,
          30,
          31
        ];
        return daysInMonth[date.month - 1];
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
        Jalali d = Jalali.fromDateTime(date);
        year = d.year;
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
        Jalali d = Jalali.fromDateTime(date);
        switch (lang) {
          case 'fa':
            var f = d.formatter;
            final y = formatNumber(f.yyyy, lang);
            final m = f.mN;
            return '$y $m';
          case 'en':
            return '${StringsEn().jalaliMonthNames[d.month - 1]} ${d.year}';
        }
    }
    return '';
  }

  /// Returns the translations of the given number
  static String formatNumber(String number, String languageCode,
          [String pattern = '']) =>
      NumberFormat(pattern, languageCode).format(int.tryParse(number));

  /// Returns a detailed date containing day, month and week day.
  static String formatMediumDate(
      BuildContext context, DateTime date, Calendar calendarMode) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (calendarMode) {
      case Calendar.gregorian:
        return MaterialLocalizations.of(context).formatMediumDate(date);
      case Calendar.jalali:
        Jalali d = Jalali.fromDateTime(date);
        final format = DateFormat('', lang);
        final days = format.dateSymbols.STANDALONEWEEKDAYS;

        switch (lang) {
          case 'fa':
            var f = d.formatter;
            return '${days[date.weekday % 7]}، ${formatNumber(f.d, 'fa')} ${f.mN}';
          case 'en':
            return '${days[date.weekday % 7]}, ${StringsEn().jalaliMonthNames[d.month - 1]} ${d.day}';
        }
    }
    return '';
  }

  /// Returns a detailed date containing day, month and week day.
  static String formatDate(
      BuildContext context, DateTime date, Calendar calendarMode) {
    final lang = Localizations.localeOf(context).languageCode;
    final format = DateFormat('y/M/dd', lang);

    switch (calendarMode) {
      case Calendar.gregorian:
        return format.format(date);
      case Calendar.jalali:
        Jalali jalaliDate = Jalali.fromDateTime(date);
        var f = jalaliDate.formatter;

        switch (lang) {
          case 'fa':
            const lang = 'fa';
            const pattern = '00';
            final y = formatNumber(f.yyyy, lang, pattern);
            final m = formatNumber(f.mm, lang, pattern);
            final d = formatNumber(f.dd, lang, pattern);
            return '$y/$m/$d';
          case 'en':
            return '${f.yyyy}/${f.mm}/${f.dd}';
        }
    }
    return '';
  }

  /// Returns locale month name for provided month number and calendar.
  static String getMonthName(
      BuildContext context, int monthNumber, Calendar mode) {
    final locale = Localizations.localeOf(context);
    final format = DateFormat('', locale.languageCode);

    switch (mode) {
      case Calendar.gregorian:
        return format.dateSymbols.MONTHS[monthNumber - 1];
      case Calendar.jalali:
        switch (locale.languageCode) {
          case 'fa':
            // Note: we only need month name.
            final justADate = Jalali(Jalali.now().year, monthNumber);
            final f = JalaliFormatter(justADate);
            return f.mN;
          case 'en':
            return StringsEn().jalaliMonthNames[monthNumber - 1];
        }
    }
    return '';
  }

  /// Returns converted month number in locale language.
  static int getMonthNumber(DateTime date, Calendar calendar) {
    switch (calendar) {
      case Calendar.gregorian:
        return date.month;
      case Calendar.jalali:
        return Jalali.fromDateTime(date).month;
    }
  }

  /// Returns month date of provided calendar for the given month number of the
  /// calendar and in the given date year.
  static DateTime getMonthDate(
      DateTime date, int monthNumber, Calendar calendarMode) {
    switch (calendarMode) {
      case Calendar.gregorian:
        return DateTime(date.year, monthNumber);
      case Calendar.jalali:
        return Jalali.fromDateTime(date).withMonth(monthNumber).toDateTime();
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
      return DateTime(year, month + count, day, hour, minute, second);
    } else {
      return Jalali.fromDateTime(this).addMonths(count).toDateTime();
    }
  }
}
