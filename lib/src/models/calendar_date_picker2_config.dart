import 'package:flutter/material.dart';

/// Custom enum for a date picker type including single, multi, and range.
enum CalendarDatePicker2Type {
  /// Allows selecting a single date.
  single,

  /// Allows selecting multiple dates.
  multi,

  /// Allows selecting a range of two dates.
  ///
  /// See also [CalendarDatePicker2Config.rangeBidirectional].
  range,
}

/// Custom enum for a date picker mode including day, month, and year.
enum CalendarDatePicker2Mode {
  /// Choosing a day.
  day,

  /// Choosing a month.
  month,

  /// Choosing a year.
  year,

  /// Choosing a vertically scrollable calendar.
  ///
  /// The calendar must be wrapped inside a height-constrained widget
  scroll,
}

/// Predicate to determine the text style for a day.
typedef CalendarDayTextStylePredicate = TextStyle? Function({
  required DateTime date,
});

/// Custom builder for the day widget
typedef CalendarDayBuilder = Widget? Function({
  required DateTime date,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isToday,
});

/// Custom builder for the year widget
typedef CalendarYearBuilder = Widget? Function({
  required int year,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentYear,
});

/// Custom builder for the month widget
typedef CalendarMonthBuilder = Widget? Function({
  required int month,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentMonth,
});

/// Handler for the text displayed in the mode picker
typedef CalendarModePickerTextHandler = String? Function({
  required DateTime monthDate,
});

/// Builder for the month and year in the scroll calendar view.
typedef CalendarScrollViewMonthYearBuilder = Widget Function(
    DateTime monthDate);

/// Callback for the scroll calendar view on scrolling
typedef CalendarScrollViewOnScrolling = Widget Function(double offset);

/// Predicate to determine whether a day should be selectable.
typedef CalendarSelectableDayPredicate = bool Function(DateTime day);

/// Predicate to determine whether a year should be selectable.
typedef CalendarSelectableYearPredicate = bool Function(int year);

/// Predicate to determine whether a month should be selectable.
typedef CalendarSelectableMonthPredicate = bool Function(int year, int month);

/// Custom configuration for CalendarDatePicker2
class CalendarDatePicker2Config {
  CalendarDatePicker2Config({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    CalendarDatePicker2Mode? calendarViewMode,
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
    this.selectedRangeHighlightColor,
    this.disabledDayTextStyle,
    this.todayTextStyle,
    this.yearTextStyle,
    this.selectedYearTextStyle,
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.dayBorderRadius,
    this.yearBorderRadius,
    this.monthBorderRadius,
    this.selectableDayPredicate,
    this.selectableMonthPredicate,
    this.selectableYearPredicate,
    this.dayTextStylePredicate,
    this.dayBuilder,
    this.yearBuilder,
    this.monthBuilder,
    this.disableModePicker,
    this.centerAlignModePicker,
    this.customModePickerIcon,
    this.modePickerTextHandler,
    this.selectedRangeDayTextStyle,
    this.rangeBidirectional,
    this.calendarViewScrollPhysics,
    this.daySplashColor,
    this.allowSameValueSelection,
    this.disableMonthPicker,
    this.useAbbrLabelForMonthModePicker,
    this.dayMaxWidth,
    this.hideMonthPickerDividers,
    this.hideYearPickerDividers,
    this.scrollCalendarTopHeaderTextStyle,
    this.hideScrollCalendarTopHeader,
    this.hideScrollCalendarTopHeaderDivider,
    this.hideScrollCalendarMonthWeekHeader,
    this.scrollCalendarConstraints,
    this.scrollViewMonthYearBuilder,
    this.scrollViewOnScrolling,
    this.scrollViewController,
  })  : calendarType = calendarType ?? CalendarDatePicker2Type.single,
        firstDate = DateUtils.dateOnly(firstDate ?? DateTime(1970)),
        lastDate =
            DateUtils.dateOnly(lastDate ?? DateTime(DateTime.now().year + 50)),
        currentDate = currentDate ?? DateUtils.dateOnly(DateTime.now()),
        calendarViewMode = calendarViewMode ?? CalendarDatePicker2Mode.day;

  /// The enabled date picker mode
  final CalendarDatePicker2Type calendarType;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The initially displayed view of the calendar picker.
  final CalendarDatePicker2Mode calendarViewMode;

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

  /// Custom text style for all calendar days
  final TextStyle? dayTextStyle;

  /// Custom text style for selected calendar day(s)
  final TextStyle? selectedDayTextStyle;

  /// Custom text style for selected range calendar day(s)
  final TextStyle? selectedRangeDayTextStyle;

  /// The highlight color for selected day(s)
  final Color? selectedDayHighlightColor;

  /// The highlight color for day(s) included in the selected range
  /// Only applicable when [calendarType] is [CalendarDatePicker2Type.range]
  final Color? selectedRangeHighlightColor;

  /// Custom text style for disabled calendar day(s)
  final TextStyle? disabledDayTextStyle;

  /// Custom text style for today
  final TextStyle? todayTextStyle;

  // Custom text style for years list
  final TextStyle? yearTextStyle;

  // Custom text style for selected year(s)
  final TextStyle? selectedYearTextStyle;

  // Custom text style for month list
  final TextStyle? monthTextStyle;

  // Custom text style for selected month(s)
  final TextStyle? selectedMonthTextStyle;

  /// Custom border radius for day indicator
  final BorderRadius? dayBorderRadius;

  /// Custom border radius for year indicator
  final BorderRadius? yearBorderRadius;

  /// Custom border radius for month indicator
  final BorderRadius? monthBorderRadius;

  /// Function to provide full control over which dates in the calendar can be selected.
  final CalendarSelectableDayPredicate? selectableDayPredicate;

  /// Function to provide full control over which month in the month list can be selected.
  final CalendarSelectableMonthPredicate? selectableMonthPredicate;

  /// Function to provide full control over which year in the year list be selected.
  final CalendarSelectableYearPredicate? selectableYearPredicate;

  /// Function to provide full control over calendar days text style
  final CalendarDayTextStylePredicate? dayTextStylePredicate;

  /// Function to provide full control over day widget UI
  final CalendarDayBuilder? dayBuilder;

  /// Function to provide full control over year widget UI
  final CalendarYearBuilder? yearBuilder;

  /// Function to provide full control over month widget UI
  final CalendarMonthBuilder? monthBuilder;

  /// Flag to disable mode picker and hide the mode toggle button icon
  final bool? disableModePicker;

  /// Flag to centralize year and month text label in controls
  final bool? centerAlignModePicker;

  /// Custom icon for the mode picker button icon
  final Widget? customModePickerIcon;

  /// Function to control mode picker displayed text
  final CalendarModePickerTextHandler? modePickerTextHandler;

  /// Whether the range selection can be also made in reverse-chronological order.
  /// Only applicable when [calendarType] is [CalendarDatePicker2Type.range].
  final bool? rangeBidirectional;

  /// The scroll physics for the calendar month view
  final ScrollPhysics? calendarViewScrollPhysics;

  /// The splash color of the day widget
  final Color? daySplashColor;

  /// When set to true, [onValueChanged] will be called on the same value selection
  final bool? allowSameValueSelection;

  /// Flag to disable month picker
  final bool? disableMonthPicker;

  /// Use Abbreviation label for month mode picker, only works when month picker is enabled
  final bool? useAbbrLabelForMonthModePicker;

  /// Max width of day widget. When [dayMaxWidth] is not null, it will override default size settings
  final double? dayMaxWidth;

  /// Flag to hide dividers on month picker
  final bool? hideMonthPickerDividers;

  /// Flag to hide dividers on year picker
  final bool? hideYearPickerDividers;

  /// Flag to hide top week labels header on scroll view
  final bool? hideScrollCalendarTopHeader;

  /// Custom text style for scroll view top week labels header
  final TextStyle? scrollCalendarTopHeaderTextStyle;

  /// Flag to hide top week labels header divider on scroll view
  final bool? hideScrollCalendarTopHeaderDivider;

  /// Flag to hide month calendar week labels header on scroll view
  final bool? hideScrollCalendarMonthWeekHeader;

  /// BoxConstraints for the scroll calendar view, only work for scroll mode
  final BoxConstraints? scrollCalendarConstraints;

  /// Function to provide full control over scroll calendar month year UI
  final CalendarScrollViewMonthYearBuilder? scrollViewMonthYearBuilder;

  /// Function to callback over scrolling on scroll view
  final CalendarScrollViewOnScrolling? scrollViewOnScrolling;

  /// Custom scroll controller to the scroll calendar view
  final ScrollController? scrollViewController;

  /// Copy the current [CalendarDatePicker2Config] with some new values
  CalendarDatePicker2Config copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    CalendarDatePicker2Mode? calendarViewMode,
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
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    BorderRadius? monthBorderRadius,
    CalendarSelectableDayPredicate? selectableDayPredicate,
    CalendarSelectableMonthPredicate? selectableMonthPredicate,
    CalendarSelectableYearPredicate? selectableYearPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    CalendarMonthBuilder? monthBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
    bool? rangeBidirectional,
    ScrollPhysics? calendarViewScrollPhysics,
    Color? daySplashColor,
    bool? allowSameValueSelection,
    bool? disableMonthPicker,
    bool? useAbbrLabelForMonthModePicker,
    double? dayMaxWidth,
    bool? hideMonthPickerDividers,
    bool? hideYearPickerDividers,
    TextStyle? scrollCalendarTopHeaderTextStyle,
    bool? hideScrollCalendarTopHeader,
    bool? hideScrollCalendarTopHeaderDivider,
    bool? hideScrollCalendarMonthWeekHeader,
    BoxConstraints? scrollCalendarConstraints,
    CalendarScrollViewMonthYearBuilder? scrollViewMonthYearBuilder,
    CalendarScrollViewOnScrolling? scrollViewOnScrolling,
    ScrollController? scrollViewController,
  }) {
    return CalendarDatePicker2Config(
      calendarType: calendarType ?? this.calendarType,
      firstDate: DateUtils.dateOnly(firstDate ?? this.firstDate),
      lastDate: DateUtils.dateOnly(lastDate ?? this.lastDate),
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      selectedRangeHighlightColor:
          selectedRangeHighlightColor ?? this.selectedRangeHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      selectedYearTextStyle:
          selectedYearTextStyle ?? this.selectedYearTextStyle,
      selectedRangeDayTextStyle:
          selectedRangeDayTextStyle ?? this.selectedRangeDayTextStyle,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      selectedMonthTextStyle:
          selectedMonthTextStyle ?? this.selectedMonthTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
      monthBorderRadius: monthBorderRadius ?? this.monthBorderRadius,
      selectableDayPredicate:
          selectableDayPredicate ?? this.selectableDayPredicate,
      selectableMonthPredicate:
          selectableMonthPredicate ?? this.selectableMonthPredicate,
      selectableYearPredicate:
          selectableYearPredicate ?? this.selectableYearPredicate,
      dayTextStylePredicate:
          dayTextStylePredicate ?? this.dayTextStylePredicate,
      dayBuilder: dayBuilder ?? this.dayBuilder,
      yearBuilder: yearBuilder ?? this.yearBuilder,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
      rangeBidirectional: rangeBidirectional ?? this.rangeBidirectional,
      calendarViewScrollPhysics:
          calendarViewScrollPhysics ?? this.calendarViewScrollPhysics,
      daySplashColor: daySplashColor ?? this.daySplashColor,
      allowSameValueSelection:
          allowSameValueSelection ?? this.allowSameValueSelection,
      disableMonthPicker: disableMonthPicker ?? this.disableMonthPicker,
      useAbbrLabelForMonthModePicker:
          useAbbrLabelForMonthModePicker ?? this.useAbbrLabelForMonthModePicker,
      dayMaxWidth: dayMaxWidth ?? this.dayMaxWidth,
      hideMonthPickerDividers:
          hideMonthPickerDividers ?? this.hideMonthPickerDividers,
      hideYearPickerDividers:
          hideYearPickerDividers ?? this.hideYearPickerDividers,
      scrollCalendarTopHeaderTextStyle: scrollCalendarTopHeaderTextStyle ??
          this.scrollCalendarTopHeaderTextStyle,
      hideScrollCalendarTopHeader:
          hideScrollCalendarTopHeader ?? this.hideScrollCalendarTopHeader,
      hideScrollCalendarTopHeaderDivider: hideScrollCalendarTopHeaderDivider ??
          this.hideScrollCalendarTopHeaderDivider,
      hideScrollCalendarMonthWeekHeader: hideScrollCalendarMonthWeekHeader ??
          this.hideScrollCalendarMonthWeekHeader,
      scrollCalendarConstraints:
          scrollCalendarConstraints ?? this.scrollCalendarConstraints,
      scrollViewMonthYearBuilder:
          scrollViewMonthYearBuilder ?? this.scrollViewMonthYearBuilder,
      scrollViewOnScrolling:
          scrollViewOnScrolling ?? this.scrollViewOnScrolling,
      scrollViewController: scrollViewController ?? this.scrollViewController,
    );
  }
}

/// Custom configuration for CalendarDatePicker2 with action buttons
class CalendarDatePicker2WithActionButtonsConfig
    extends CalendarDatePicker2Config {
  CalendarDatePicker2WithActionButtonsConfig({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    CalendarDatePicker2Mode? calendarViewMode,
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
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    BorderRadius? monthBorderRadius,
    CalendarSelectableDayPredicate? selectableDayPredicate,
    CalendarSelectableMonthPredicate? selectableMonthPredicate,
    CalendarSelectableYearPredicate? selectableYearPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    CalendarMonthBuilder? monthBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
    bool? rangeBidirectional,
    ScrollPhysics? calendarViewScrollPhysics,
    Color? daySplashColor,
    bool? allowSameValueSelection,
    bool? disableMonthPicker,
    bool? useAbbrLabelForMonthModePicker,
    double? dayMaxWidth,
    bool? hideMonthPickerDividers,
    bool? hideYearPickerDividers,
    TextStyle? scrollCalendarTopHeaderTextStyle,
    bool? hideScrollCalendarTopHeader,
    bool? hideScrollCalendarTopHeaderDivider,
    bool? hideScrollCalendarMonthWeekHeader,
    BoxConstraints? scrollCalendarConstraints,
    CalendarScrollViewMonthYearBuilder? scrollViewMonthYearBuilder,
    CalendarScrollViewOnScrolling? scrollViewOnScrolling,
    ScrollController? scrollViewController,
    this.gapBetweenCalendarAndButtons,
    this.cancelButtonTextStyle,
    this.cancelButton,
    this.okButtonTextStyle,
    this.okButton,
    this.openedFromDialog,
    this.closeDialogOnCancelTapped,
    this.closeDialogOnOkTapped,
    this.buttonPadding,
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
          selectedRangeDayTextStyle: selectedRangeDayTextStyle,
          selectedDayHighlightColor: selectedDayHighlightColor,
          selectedRangeHighlightColor: selectedRangeHighlightColor,
          disabledDayTextStyle: disabledDayTextStyle,
          todayTextStyle: todayTextStyle,
          yearTextStyle: yearTextStyle,
          selectedYearTextStyle: selectedYearTextStyle,
          monthTextStyle: monthTextStyle,
          selectedMonthTextStyle: selectedMonthTextStyle,
          dayBorderRadius: dayBorderRadius,
          yearBorderRadius: yearBorderRadius,
          monthBorderRadius: monthBorderRadius,
          selectableDayPredicate: selectableDayPredicate,
          selectableMonthPredicate: selectableMonthPredicate,
          selectableYearPredicate: selectableYearPredicate,
          dayTextStylePredicate: dayTextStylePredicate,
          dayBuilder: dayBuilder,
          yearBuilder: yearBuilder,
          monthBuilder: monthBuilder,
          disableModePicker: disableModePicker,
          centerAlignModePicker: centerAlignModePicker,
          customModePickerIcon: customModePickerIcon,
          modePickerTextHandler: modePickerTextHandler,
          rangeBidirectional: rangeBidirectional,
          calendarViewScrollPhysics: calendarViewScrollPhysics,
          daySplashColor: daySplashColor,
          allowSameValueSelection: allowSameValueSelection,
          disableMonthPicker: disableMonthPicker,
          useAbbrLabelForMonthModePicker: useAbbrLabelForMonthModePicker,
          dayMaxWidth: dayMaxWidth,
          hideMonthPickerDividers: hideMonthPickerDividers,
          hideYearPickerDividers: hideYearPickerDividers,
          scrollCalendarTopHeaderTextStyle: scrollCalendarTopHeaderTextStyle,
          hideScrollCalendarTopHeader: hideScrollCalendarTopHeader,
          hideScrollCalendarTopHeaderDivider:
              hideScrollCalendarTopHeaderDivider,
          hideScrollCalendarMonthWeekHeader: hideScrollCalendarMonthWeekHeader,
          scrollCalendarConstraints: scrollCalendarConstraints,
          scrollViewMonthYearBuilder: scrollViewMonthYearBuilder,
          scrollViewOnScrolling: scrollViewOnScrolling,
          scrollViewController: scrollViewController,
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

  /// Custom wrapping padding for Ok & Cancel buttons
  final EdgeInsets? buttonPadding;

  @override
  CalendarDatePicker2WithActionButtonsConfig copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    CalendarDatePicker2Mode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    BorderRadius? monthBorderRadius,
    CalendarSelectableDayPredicate? selectableDayPredicate,
    CalendarSelectableMonthPredicate? selectableMonthPredicate,
    CalendarSelectableYearPredicate? selectableYearPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    CalendarMonthBuilder? monthBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
    double? gapBetweenCalendarAndButtons,
    TextStyle? cancelButtonTextStyle,
    Widget? cancelButton,
    TextStyle? okButtonTextStyle,
    Widget? okButton,
    bool? openedFromDialog,
    bool? closeDialogOnCancelTapped,
    bool? closeDialogOnOkTapped,
    EdgeInsets? buttonPadding,
    bool? rangeBidirectional,
    ScrollPhysics? calendarViewScrollPhysics,
    Color? daySplashColor,
    bool? allowSameValueSelection,
    bool? disableMonthPicker,
    bool? useAbbrLabelForMonthModePicker,
    double? dayMaxWidth,
    bool? hideMonthPickerDividers,
    bool? hideYearPickerDividers,
    TextStyle? scrollCalendarTopHeaderTextStyle,
    bool? hideScrollCalendarTopHeader,
    bool? hideScrollCalendarTopHeaderDivider,
    bool? hideScrollCalendarMonthWeekHeader,
    BoxConstraints? scrollCalendarConstraints,
    CalendarScrollViewMonthYearBuilder? scrollViewMonthYearBuilder,
    CalendarScrollViewOnScrolling? scrollViewOnScrolling,
    ScrollController? scrollViewController,
  }) {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: calendarType ?? this.calendarType,
      firstDate: DateUtils.dateOnly(firstDate ?? this.firstDate),
      lastDate: DateUtils.dateOnly(lastDate ?? this.lastDate),
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedRangeDayTextStyle:
          selectedRangeDayTextStyle ?? this.selectedRangeDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      selectedRangeHighlightColor:
          selectedRangeHighlightColor ?? this.selectedRangeHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      selectedYearTextStyle:
          selectedYearTextStyle ?? this.selectedYearTextStyle,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      selectedMonthTextStyle:
          selectedMonthTextStyle ?? this.selectedMonthTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      yearBorderRadius: yearBorderRadius ?? this.yearBorderRadius,
      monthBorderRadius: monthBorderRadius ?? this.monthBorderRadius,
      selectableDayPredicate:
          selectableDayPredicate ?? this.selectableDayPredicate,
      selectableMonthPredicate:
          selectableMonthPredicate ?? this.selectableMonthPredicate,
      selectableYearPredicate:
          selectableYearPredicate ?? this.selectableYearPredicate,
      dayTextStylePredicate:
          dayTextStylePredicate ?? this.dayTextStylePredicate,
      dayBuilder: dayBuilder ?? this.dayBuilder,
      yearBuilder: yearBuilder ?? this.yearBuilder,
      monthBuilder: monthBuilder ?? this.monthBuilder,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
      rangeBidirectional: rangeBidirectional ?? this.rangeBidirectional,
      gapBetweenCalendarAndButtons:
          gapBetweenCalendarAndButtons ?? this.gapBetweenCalendarAndButtons,
      cancelButtonTextStyle:
          cancelButtonTextStyle ?? this.cancelButtonTextStyle,
      cancelButton: cancelButton ?? this.cancelButton,
      okButtonTextStyle: okButtonTextStyle ?? this.okButtonTextStyle,
      okButton: okButton ?? this.okButton,
      openedFromDialog: openedFromDialog ?? this.openedFromDialog,
      closeDialogOnCancelTapped:
          closeDialogOnCancelTapped ?? this.closeDialogOnCancelTapped,
      closeDialogOnOkTapped:
          closeDialogOnOkTapped ?? this.closeDialogOnOkTapped,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      calendarViewScrollPhysics:
          calendarViewScrollPhysics ?? this.calendarViewScrollPhysics,
      daySplashColor: daySplashColor ?? this.daySplashColor,
      allowSameValueSelection:
          allowSameValueSelection ?? this.allowSameValueSelection,
      disableMonthPicker: disableMonthPicker ?? this.disableMonthPicker,
      useAbbrLabelForMonthModePicker:
          useAbbrLabelForMonthModePicker ?? this.useAbbrLabelForMonthModePicker,
      dayMaxWidth: dayMaxWidth ?? this.dayMaxWidth,
      hideMonthPickerDividers:
          hideMonthPickerDividers ?? this.hideMonthPickerDividers,
      hideYearPickerDividers:
          hideYearPickerDividers ?? this.hideYearPickerDividers,
      scrollCalendarTopHeaderTextStyle: scrollCalendarTopHeaderTextStyle ??
          this.scrollCalendarTopHeaderTextStyle,
      hideScrollCalendarTopHeader:
          hideScrollCalendarTopHeader ?? this.hideScrollCalendarTopHeader,
      hideScrollCalendarTopHeaderDivider: hideScrollCalendarTopHeaderDivider ??
          this.hideScrollCalendarTopHeaderDivider,
      hideScrollCalendarMonthWeekHeader: hideScrollCalendarMonthWeekHeader ??
          this.hideScrollCalendarMonthWeekHeader,
      scrollCalendarConstraints:
          scrollCalendarConstraints ?? this.scrollCalendarConstraints,
      scrollViewMonthYearBuilder:
          scrollViewMonthYearBuilder ?? this.scrollViewMonthYearBuilder,
      scrollViewOnScrolling:
          scrollViewOnScrolling ?? this.scrollViewOnScrolling,
      scrollViewController: scrollViewController ?? this.scrollViewController,
    );
  }
}
