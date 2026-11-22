import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl_date_picker/intl_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  runApp(const IntlDatePickerDemoApp());
}

class IntlDatePickerDemoApp extends StatefulWidget {
  const IntlDatePickerDemoApp({super.key});

  @override
  State<IntlDatePickerDemoApp> createState() => _IntlDatePickerDemoAppState();
}

class _IntlDatePickerDemoAppState extends State<IntlDatePickerDemoApp> {
  Locale _locale = const Locale('fa');
  Calendar _calendar = Calendar.jalali;
  ThemeMode _themeMode = ThemeMode.light;

  DateTime _inlineDate = DateTime.now();
  DateTime? _dialogDate;
  DateTimeRange? _rangeDate;

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    if (_calendar == Calendar.jalali) {
      final j = Jalali.fromDateTime(date);
      return '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')} (شمسی)';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} (Gregorian)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'intl_date_picker demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('fa'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text(_locale.languageCode == 'fa'
              ? 'پیش‌نمایش تقویم چندزبانه'
              : 'Intl Date Picker Demo'),
          actions: [
            IconButton(
              icon: Icon(_themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: () {
                setState(() {
                  _themeMode = _themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_locale.languageCode == 'fa' ? 'تقویم:' : 'Calendar:'),
                          SegmentedButton<Calendar>(
                            segments: const [
                              ButtonSegment(
                                value: Calendar.jalali,
                                label: Text('شمسی'),
                              ),
                              ButtonSegment(
                                value: Calendar.gregorian,
                                label: Text('میلادی'),
                              ),
                            ],
                            selected: {_calendar},
                            onSelectionChanged: (set) {
                              setState(() {
                                _calendar = set.first;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_locale.languageCode == 'fa' ? 'زبان:' : 'Language:'),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'fa', label: Text('فارسی')),
                              ButtonSegment(value: 'en', label: Text('English')),
                            ],
                            selected: {_locale.languageCode},
                            onSelectionChanged: (set) {
                              setState(() {
                                _locale = Locale(set.first);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(_locale.languageCode == 'fa'
                        ? 'انتخاب تاریخ (دیالوگ)'
                        : 'Pick Date Dialog'),
                    onPressed: () async {
                      final picked = await showIntlDatePicker(
                        context: context,
                        initialDate: _dialogDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2040),
                        calendarMode: _calendar,
                        locale: _locale,
                      );
                      if (picked != null) {
                        setState(() {
                          _dialogDate = picked;
                        });
                      }
                    },
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text(_locale.languageCode == 'fa'
                        ? 'انتخاب بازه تاریخ'
                        : 'Pick Date Range'),
                    onPressed: () async {
                      final pickedRange = await showIntlDateRangePicker(
                        context: context,
                        initialDateRange: _rangeDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2040),
                        locale: _locale,
                      );
                      if (pickedRange != null) {
                        setState(() {
                          _rangeDate = pickedRange;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locale.languageCode == 'fa'
                            ? 'تاریخ دیالوگ: ${_formatDate(_dialogDate)}'
                            : 'Dialog Date: ${_formatDate(_dialogDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _locale.languageCode == 'fa'
                            ? 'بازه انتخابی: ${_formatDate(_rangeDate?.start)} تا ${_formatDate(_rangeDate?.end)}'
                            : 'Range: ${_formatDate(_rangeDate?.start)} to ${_formatDate(_rangeDate?.end)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _locale.languageCode == 'fa'
                            ? 'تقویم درون‌صفحه‌ای: ${_formatDate(_inlineDate)}'
                            : 'Inline Calendar Date: ${_formatDate(_inlineDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _locale.languageCode == 'fa'
                    ? 'تقویم مستقیم روی صفحه:'
                    : 'Inline Calendar Widget:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntlCalendarDatePicker(
                    key: ValueKey('$_calendar-$_locale'),
                    initialDate: _inlineDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2040),
                    calendarMode: _calendar,
                    onDateChanged: (DateTime date) {
                      setState(() {
                        _inlineDate = date;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
