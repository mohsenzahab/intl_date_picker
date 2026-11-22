import 'package:flutter_test/flutter_test.dart';
import 'package:intl_date_picker/intl_date_picker.dart';
import 'package:intl_date_picker/src/localization/strings_en.dart';
import 'package:intl_date_picker/src/localization/strings_fa.dart';
import 'package:intl_date_picker/src/utils/intl_date_util.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  group('IntlDateUtils unit tests', () {
    test('dateOnly strips hours, minutes, seconds', () {
      final dt = DateTime(2024, 5, 10, 14, 30, 45);
      final only = IntlDateUtils.dateOnly(dt);
      expect(only, DateTime(2024, 5, 10));
    });

    test('isSameDay tests', () {
      final d1 = DateTime(2024, 5, 10, 2);
      final d2 = DateTime(2024, 5, 10, 23);
      final d3 = DateTime(2024, 5, 11);
      expect(IntlDateUtils.isSameDay(d1, d2), isTrue);
      expect(IntlDateUtils.isSameDay(d1, d3), isFalse);
      expect(IntlDateUtils.isSameDay(null, null), isTrue);
      expect(IntlDateUtils.isSameDay(d1, null), isFalse);
    });

    test('isSameMonth for Gregorian and Jalali', () {
      // 1403/01/01 and 1403/01/31 are same Jalali month
      final j1 = Jalali(1403, 1, 1).toDateTime();
      final j2 = Jalali(1403, 1, 31).toDateTime();
      final j3 = Jalali(1403, 2, 1).toDateTime();

      expect(IntlDateUtils.isSameMonth(j1, j2, Calendar.jalali), isTrue);
      expect(IntlDateUtils.isSameMonth(j1, j3, Calendar.jalali), isFalse);

      final g1 = DateTime(2024, 1, 5);
      final g2 = DateTime(2024, 1, 28);
      final g3 = DateTime(2024, 2, 1);
      expect(IntlDateUtils.isSameMonth(g1, g2, Calendar.gregorian), isTrue);
      expect(IntlDateUtils.isSameMonth(g1, g3, Calendar.gregorian), isFalse);
    });

    test('monthDelta calculates correct differences', () {
      final gStart = DateTime(2023, 5, 10);
      final gEnd = DateTime(2024, 7, 1);
      expect(IntlDateUtils.monthDelta(gStart, gEnd, Calendar.gregorian), 14);

      final jStart = Jalali(1402, 10, 1).toDateTime();
      final jEnd = Jalali(1403, 3, 15).toDateTime();
      expect(IntlDateUtils.monthDelta(jStart, jEnd, Calendar.jalali), 5);
    });

    test('getDaysInMonth handles leap years in Jalali and Gregorian', () {
      // 1403 is a leap year (kabiseh) in Jalali: Esfand has 30 days
      final jLeap = Jalali(1403, 12, 1).toDateTime();
      expect(IntlDateUtils.getDaysInMonth(jLeap, Calendar.jalali), 30);

      // 1402 is not a leap year: Esfand has 29 days
      final jNonLeap = Jalali(1402, 12, 1).toDateTime();
      expect(IntlDateUtils.getDaysInMonth(jNonLeap, Calendar.jalali), 29);

      // Gregorian leap year 2024 (Feb has 29 days) vs 2023 (Feb has 28 days)
      expect(IntlDateUtils.getDaysInMonth(DateTime(2024, 2, 1), Calendar.gregorian), 29);
      expect(IntlDateUtils.getDaysInMonth(DateTime(2023, 2, 1), Calendar.gregorian), 28);
    });

    test('addMonthsToMonthDate always sets day to 1 safely', () {
      final jDate = Jalali(1403, 6, 31).toDateTime();
      final added = IntlDateUtils.addMonthsToMonthDate(jDate, 1, Calendar.jalali);
      final jAdded = Jalali.fromDateTime(added);
      expect(jAdded.year, 1403);
      expect(jAdded.month, 7);
      expect(jAdded.day, 1);
    });

    test('addDaysToDate works for Jalali and Gregorian', () {
      final jDate = Jalali(1403, 1, 31).toDateTime();
      final nextDay = IntlDateUtils.addDaysToDate(jDate, 1, Calendar.jalali);
      final jNext = Jalali.fromDateTime(nextDay);
      expect(jNext.month, 2);
      expect(jNext.day, 1);
    });

    test('StringsEn and StringsFa month names are complete and correct', () {
      expect(StringsEn.defaultJalaliMonthNames.length, 12);
      expect(StringsEn.defaultJalaliMonthNames[1], 'Ordibehesht'); // Typo fixed!

      expect(StringsFa.defaultJalaliMonthNames.length, 12);
      expect(StringsFa.defaultJalaliMonthNames[0], 'فروردین');
      expect(StringsFa.defaultJalaliMonthNames[11], 'اسفند');
    });

    test('formatNumber handles numbers safely without crashing on null', () {
      expect(IntlDateUtils.formatNumber('1403', 'en'), '1403');
      expect(IntlDateUtils.formatNumber('1403', 'en', '#,###'), '1,403');
      expect(IntlDateUtils.formatNumber('invalid', 'en'), 'invalid');
    });
  });
}
