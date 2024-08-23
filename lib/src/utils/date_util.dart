import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Get the number of days offset for the first day in a month.
int getMonthFirstDayOffset(int year, int month, int firstDayOfWeekIndex) {
  // 0-based day of week for the month and year, with 0 representing Monday.
  final int weekdayFromMonday = DateTime(year, month).weekday - 1;

  // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
  // weekdayFromMonday.
  firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

  // Number of days between the first day of week appearing on the calendar,
  // and the day corresponding to the first of the month.
  return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
}

/// Get short month format for the given locale.
DateFormat getLocaleShortMonthFormat(Locale locale) {
  final String localeName = Intl.canonicalizedLocale(locale.toString());
  var monthFormat = DateFormat.MMM();
  if (DateFormat.localeExists(localeName)) {
    monthFormat = DateFormat.MMM(localeName);
  } else if (DateFormat.localeExists(locale.languageCode)) {
    monthFormat = DateFormat.MMM(locale.languageCode);
  }

  return monthFormat;
}

/// Get full month format for the given locale.
DateFormat getLocaleFullMonthFormat(Locale locale) {
  final String localeName = Intl.canonicalizedLocale(locale.toString());
  var monthFormat = DateFormat.MMMM();
  if (DateFormat.localeExists(localeName)) {
    monthFormat = DateFormat.MMMM(localeName);
  } else if (DateFormat.localeExists(locale.languageCode)) {
    monthFormat = DateFormat.MMMM(locale.languageCode);
  }

  return monthFormat;
}

/// Get the number of rows required to display all days in a month.
int getDayRowsCount(int year, int month, int firstDayOfWeekIndex) {
  final int monthFirstDayOffset =
      getMonthFirstDayOffset(year, month, firstDayOfWeekIndex);
  final int totalDays = DateUtils.getDaysInMonth(year, month);
  final int remainingDays = totalDays - (7 - monthFirstDayOffset);
  return (remainingDays / 7).ceil() + 1;
}
