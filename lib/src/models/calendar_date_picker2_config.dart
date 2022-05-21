import 'package:flutter/material.dart';

enum CalendarDatePicker2Type {
  /// single date
  single,

  /// multiple single dates
  multi,

  /// period consisting start and end dates
  range,
}

class CalendarDatePicker2Config {
  CalendarDatePicker2Config({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    this.weekdayLabels,
    this.weekdayLabelTextStyle,
    this.controlsHeight,
    this.controlsTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.selectedDayHighlightColor,
  })  : calendarType = calendarType ?? CalendarDatePicker2Type.single,
        firstDate = firstDate ?? DateTime(1970),
        lastDate = lastDate ?? DateTime(DateTime.now().year + 50),
        currentDate = currentDate ?? DateUtils.dateOnly(DateTime.now()),
        calendarViewMode = calendarViewMode ?? DatePickerMode.day;

  /// The enabled date picker mode
  final CalendarDatePicker2Type calendarType;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The initially displayed view of the calendar picker.
  final DatePickerMode calendarViewMode;

  /// The custom weekday label sunday's value is 0, by default S M T W T F S
  final List<String>? weekdayLabels;

  /// The custom text style for weekday labels
  final TextStyle? weekdayLabelTextStyle;

  /// The custom height for calendar control toggle's height
  final double? controlsHeight;

  /// The custom text style for calendar mode toggle control
  final TextStyle? controlsTextStyle;

  /// The custom text style for calendar day text
  final TextStyle? dayTextStyle;

  /// The custom text style for selected calendar day text
  final TextStyle? selectedDayTextStyle;

  /// The highlight color selected day
  final Color? selectedDayHighlightColor;

  CalendarDatePicker2Config copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    double? controlsHeight,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
  }) {
    return CalendarDatePicker2Config(
      calendarType: calendarType ?? this.calendarType,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
    );
  }
}
