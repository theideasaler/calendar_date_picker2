import 'package:flutter/material.dart';

enum CalendarDatePicker2Type { single, multi, range }

class CalendarDatePicker2Config {
  CalendarDatePicker2Config({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    this.weekdayLabels,
    this.weekdayLabelTextStyle,
    this.firstDayOfWeek,
    this.controlsHeight,
    this.lastMonthIcon,
    this.nextMonthIcon,
    this.controlsTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.selectedDayHighlightColor,
    this.disabledDayTextStyle,
    this.todayTextStyle,
    this.yearTextStyle,
    this.selectedYearTextStyle,
    this.dayBorderRadius,
    this.yearBorderRadius,
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

  /// Custom weekday labels for the current locale, MUST starts from Sunday
  /// Examples:
  ///
  /// - US English: S, M, T, W, T, F, S
  /// - Russian: вс, пн, вт, ср, чт, пт, сб - notice that the list begins with
  ///   вс (Sunday) even though the first day of week for Russian is Monday.
  final List<String>? weekdayLabels;

  /// Custom text style for weekday labels
  final TextStyle? weekdayLabelTextStyle;

  /// Index of the first day of week, where 0 points to Sunday, and 6 points to Saturday.
  final int? firstDayOfWeek;

  /// Custom height for calendar control toggle's height
  final double? controlsHeight;

  /// Custom icon for last month button control
  final Widget? lastMonthIcon;

  /// Custom icon for next month button control
  final Widget? nextMonthIcon;

  /// Custom text style for calendar mode toggle control
  final TextStyle? controlsTextStyle;

  /// Custom text style for calendar day text
  final TextStyle? dayTextStyle;

  /// Custom text style for selected calendar day(s)
  final TextStyle? selectedDayTextStyle;

  /// The highlight color for selected day
  final Color? selectedDayHighlightColor;

  /// Custom text style for disabled calendar day(s)
  final TextStyle? disabledDayTextStyle;

  /// Custom text style for the current day
  final TextStyle? todayTextStyle;

  // Custom text style for years list
  final TextStyle? yearTextStyle;

  // Custom text style for selected year
  final TextStyle? selectedYearTextStyle;

  /// Custom border radius for day indicator
  final BorderRadius? dayBorderRadius;

  /// Custom border radius for year indicator
  final BorderRadius? yearBorderRadius;

  CalendarDatePicker2Config copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
  }) {
    return CalendarDatePicker2Config(
      calendarType: calendarType ?? this.calendarType,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle: weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor: selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      selectedYearTextStyle: selectedYearTextStyle ?? this.selectedYearTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
    );
  }
}

class CalendarDatePicker2WithActionButtonsConfig extends CalendarDatePicker2Config {
  CalendarDatePicker2WithActionButtonsConfig({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    this.gapBetweenCalendarAndButtons,
    this.cancelButtonTextStyle,
    this.cancelButton,
    this.okButtonTextStyle,
    this.okButton,
    this.openedFromDialog,
    this.closeDialogOnCancelTapped,
    this.closeDialogOnOkTapped,
  }) : super(
          calendarType: calendarType,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          calendarViewMode: calendarViewMode,
          weekdayLabels: weekdayLabels,
          weekdayLabelTextStyle: weekdayLabelTextStyle,
          firstDayOfWeek: firstDayOfWeek,
          controlsHeight: controlsHeight,
          lastMonthIcon: lastMonthIcon,
          nextMonthIcon: nextMonthIcon,
          controlsTextStyle: controlsTextStyle,
          dayTextStyle: dayTextStyle,
          selectedDayTextStyle: selectedDayTextStyle,
          selectedDayHighlightColor: selectedDayHighlightColor,
          disabledDayTextStyle: disabledDayTextStyle,
          todayTextStyle: todayTextStyle,
          yearTextStyle: yearTextStyle,
          selectedYearTextStyle: selectedYearTextStyle,
          dayBorderRadius: dayBorderRadius,
          yearBorderRadius: yearBorderRadius,
        );

  /// The gap between calendar and action buttons
  final double? gapBetweenCalendarAndButtons;

  /// Text style for cancel button
  final TextStyle? cancelButtonTextStyle;

  /// Custom cancel button
  final Widget? cancelButton;

  /// Text style for ok button
  final TextStyle? okButtonTextStyle;

  /// Custom ok button
  final Widget? okButton;

  /// Is the calendar opened from dialog
  final bool? openedFromDialog;

  /// If the dialog should be closed when user taps the CANCEL button
  final bool? closeDialogOnCancelTapped;

  /// If the dialog should be closed when user taps the OK button
  final bool? closeDialogOnOkTapped;

  @override
  CalendarDatePicker2WithActionButtonsConfig copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerMode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    double? gapBetweenCalendarAndButtons,
    TextStyle? cancelButtonTextStyle,
    Widget? cancelButton,
    TextStyle? okButtonTextStyle,
    Widget? okButton,
    bool? openedFromDialog,
    bool? closeDialogOnCancelTapped,
    bool? closeDialogOnOkTapped,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
  }) {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: calendarType ?? this.calendarType,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle: weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor: selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      selectedYearTextStyle: selectedYearTextStyle ?? this.selectedYearTextStyle,
      gapBetweenCalendarAndButtons:
          gapBetweenCalendarAndButtons ?? this.gapBetweenCalendarAndButtons,
      cancelButtonTextStyle: cancelButtonTextStyle ?? this.cancelButtonTextStyle,
      cancelButton: cancelButton ?? this.cancelButton,
      okButtonTextStyle: okButtonTextStyle ?? this.okButtonTextStyle,
      okButton: okButton ?? this.okButton,
      openedFromDialog: openedFromDialog ?? this.openedFromDialog,
      closeDialogOnCancelTapped: closeDialogOnCancelTapped ?? this.closeDialogOnCancelTapped,
      closeDialogOnOkTapped: closeDialogOnOkTapped ?? this.closeDialogOnOkTapped,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
    );
  }
}
