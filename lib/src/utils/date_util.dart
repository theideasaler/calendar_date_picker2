import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
