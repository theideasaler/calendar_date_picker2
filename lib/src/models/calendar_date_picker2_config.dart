import 'package:flutter/material.dart';

/// Custom semantic label types
enum CalendarDatePicker2SemanticsLabel {
  /// Semantic label for month mode picker
  selectMonth,

  /// Semantic label for year mode picker
  selectYear,
}

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

/// Custom builder for the weekday label widget
typedef WeekdayLabelBuilder = Widget? Function({
  required int weekday,
  bool? isScrollViewTopHeader,
});

/// Custom builder for the day widget
typedef DayBuilder = Widget? Function({
  required DateTime date,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isToday,
});

/// Custom builder for the year widget
typedef YearBuilder = Widget? Function({
  required int year,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentYear,
});

/// Custom builder for the month widget
typedef MonthBuilder = Widget? Function({
  required int month,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentMonth,
});

/// Builder for the month and year in the scroll calendar view.
typedef ScrollViewMonthYearBuilder = Widget Function(DateTime monthDate);

/// Builder for the mode picker widget
///
/// [isMonthPicker] will be true if function is called to build month picker
typedef ModePickerBuilder = Widget? Function({
  required CalendarDatePicker2Mode viewMode,
  required DateTime monthDate,
  bool? isMonthPicker,
});

/// Predicate to determine the day widget box decoration for a day in selected range
typedef SelectedRangeDecorationPredicate = BoxDecoration? Function({
  required DateTime dayToBuild,
  required BoxDecoration decoration,
  required bool isStartDate,
  required bool isEndDate,
});

/// Function to provide full control over range picker highlight
typedef SelectedRangeHighlightBuilder = Widget? Function({
  required DateTime dayToBuild,
  required bool isStartDate,
  required bool isEndDate,
});

/// Handler for the text displayed in the mode picker
///
/// [isMonthPicker] will be true if function is called for month picker text
typedef ModePickerTextHandler = String? Function(
    {required DateTime monthDate, bool? isMonthPicker});

/// Callback for the scroll calendar view on scrolling
typedef ScrollViewOnScrolling = void Function(double offset);

/// Predicate to determine the text style for a day.
typedef DayTextStylePredicate = TextStyle? Function({
  required DateTime date,
});

/// Predicate to determine whether a day should be selectable.
typedef SelectableDayPredicate = bool Function(DateTime day);

/// Predicate to determine whether a year should be selectable.
typedef SelectableYearPredicate = bool Function(int year);

/// Predicate to determine whether a month should be selectable.
typedef SelectableMonthPredicate = bool Function(int year, int month);

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
    this.weekdayLabelBuilder,
    this.firstDayOfWeek,
    this.controlsHeight,
    this.lastMonthIcon,
    this.hideLastMonthIcon,
    this.nextMonthIcon,
    this.hideNextMonthIcon,
    this.controlsTextStyle,
    this.animateToDisplayedMonthDate,
    this.semanticsDictionary,
    this.disableVibration,
    this.dayViewController,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.selectedDayHighlightColor,
    this.selectedRangeHighlightColor,
    this.disabledDayTextStyle,
    this.todayTextStyle,
    this.yearTextStyle,
    this.selectedYearTextStyle,
    this.disabledYearTextStyle,
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.disabledMonthTextStyle,
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
    this.monthViewController,
    this.yearViewController,
    this.disableModePicker,
    this.centerAlignModePicker,
    this.customModePickerIcon,
    this.modePickerTextHandler,
    this.modePickerBuilder,
    this.modePickersGap,
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
    this.scrollViewTopHeaderTextStyle,
    this.hideScrollViewTopHeader,
    this.hideScrollViewTopHeaderDivider,
    this.hideScrollViewMonthWeekHeader,
    this.scrollViewConstraints,
    this.scrollViewMonthYearBuilder,
    this.scrollViewOnScrolling,
    this.scrollViewController,
    this.dynamicCalendarRows,
    this.dayModeScrollDirection,
    this.selectedRangeHighlightBuilder,
    this.selectedRangeDecorationPredicate,
    this.isPickMonthMode,
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

  /// Function to provide full control over weekday label widget
  final WeekdayLabelBuilder? weekdayLabelBuilder;

  /// Index of the first day of week, where 0 points to Sunday, and 6 points to Saturday.
  final int? firstDayOfWeek;

  /// Custom height for calendar control toggle's height
  final double? controlsHeight;

  /// Custom icon for last month button control
  final Widget? lastMonthIcon;

  /// Flag to hide last month icon
  final bool? hideLastMonthIcon;

  /// Custom icon for next month button control
  final Widget? nextMonthIcon;

  /// Flag to hide next month icon
  final bool? hideNextMonthIcon;

  /// Custom text style for calendar mode toggle control
  final TextStyle? controlsTextStyle;

  /// Flag to always animate to the displayedMonthDate
  final bool? animateToDisplayedMonthDate;

  /// Custom dictionary for semantics labels
  final Map<CalendarDatePicker2SemanticsLabel, String?>? semanticsDictionary;

  /// Flag to disable vibration on date selection
  final bool? disableVibration;

  /// Custom page controller for the calendar day view mode
  final PageController? dayViewController;

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

  /// Custom text style for years list
  final TextStyle? yearTextStyle;

  /// Custom text style for selected year(s)
  final TextStyle? selectedYearTextStyle;

  /// Custom text style for disabled year(s)
  final TextStyle? disabledYearTextStyle;

  /// Custom text style for month list
  final TextStyle? monthTextStyle;

  /// Custom text style for selected month(s)
  final TextStyle? selectedMonthTextStyle;

  /// Custom text style for disabled month(s)
  final TextStyle? disabledMonthTextStyle;

  /// Custom border radius for day indicator
  final BorderRadius? dayBorderRadius;

  /// Custom border radius for year indicator
  final BorderRadius? yearBorderRadius;

  /// Custom border radius for month indicator
  final BorderRadius? monthBorderRadius;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Function to provide full control over which month in the month list can be selected.
  final SelectableMonthPredicate? selectableMonthPredicate;

  /// Function to provide full control over which year in the year list be selected.
  final SelectableYearPredicate? selectableYearPredicate;

  /// Function to provide full control over calendar days text style
  final DayTextStylePredicate? dayTextStylePredicate;

  /// Function to provide full control over day widget UI
  final DayBuilder? dayBuilder;

  /// Function to provide full control over year widget UI
  final YearBuilder? yearBuilder;

  /// Function to provide full control over month widget UI
  final MonthBuilder? monthBuilder;

  /// Custom scroll controller for the calendar month view
  final ScrollController? monthViewController;

  /// Custom scroll controller for the calendar year view
  final ScrollController? yearViewController;

  /// Flag to disable mode picker and hide the mode toggle button icon
  final bool? disableModePicker;

  /// Flag to centralize year and month text label in controls
  final bool? centerAlignModePicker;

  /// Custom icon for the mode picker button icon
  final Widget? customModePickerIcon;

  /// Function to control mode picker displayed text
  final ModePickerTextHandler? modePickerTextHandler;

  /// Function to provide full control over mode picker UI
  final ModePickerBuilder? modePickerBuilder;

  /// Custom gap distance between month and year mode pickers
  final double? modePickersGap;

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
  final bool? hideScrollViewTopHeader;

  /// Custom text style for scroll view top week labels header
  final TextStyle? scrollViewTopHeaderTextStyle;

  /// Flag to hide top week labels header divider on scroll view
  final bool? hideScrollViewTopHeaderDivider;

  /// Flag to hide month calendar week labels header on scroll view
  final bool? hideScrollViewMonthWeekHeader;

  /// BoxConstraints for the scroll calendar view, only work for scroll mode
  final BoxConstraints? scrollViewConstraints;

  /// Function to provide full control over scroll calendar month year UI
  final ScrollViewMonthYearBuilder? scrollViewMonthYearBuilder;

  /// Function to callback over scrolling on scroll view
  final ScrollViewOnScrolling? scrollViewOnScrolling;

  /// Custom scroll controller to the scroll calendar view
  final ScrollController? scrollViewController;

  /// Flag to enable dynamic calendar rows based on specific month
  ///
  /// This will make calendar height dynamic to fit real month rows
  final bool? dynamicCalendarRows;

  /// Axis scroll direction for [CalendarDatePicker2Mode.day] mode
  ///
  /// Only works when [calendarViewMode] is not [CalendarDatePicker2Mode.scroll]
  final Axis? dayModeScrollDirection;

  /// Function to provide full control over range picker highlight
  final SelectedRangeHighlightBuilder? selectedRangeHighlightBuilder;

  /// Predicate to determine the day widget box decoration for a day in selected range
  final SelectedRangeDecorationPredicate? selectedRangeDecorationPredicate;

  /// Flag to auto transition to day view when the user selects a month
  final bool? isPickMonthMode;

  /// Copy the current [CalendarDatePicker2Config] with some new values
  CalendarDatePicker2Config copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    CalendarDatePicker2Mode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    WeekdayLabelBuilder? weekdayLabelBuilder,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    bool? hideLastMonthIcon,
    Widget? nextMonthIcon,
    bool? hideNextMonthIcon,
    TextStyle? controlsTextStyle,
    bool? animateToDisplayedMonthDate,
    Map<CalendarDatePicker2SemanticsLabel, String?>? semanticsDictionary,
    bool? disableVibration,
    PageController? dayViewController,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? disabledYearTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    TextStyle? disabledMonthTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    BorderRadius? monthBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    SelectableMonthPredicate? selectableMonthPredicate,
    SelectableYearPredicate? selectableYearPredicate,
    DayTextStylePredicate? dayTextStylePredicate,
    DayBuilder? dayBuilder,
    YearBuilder? yearBuilder,
    MonthBuilder? monthBuilder,
    ScrollController? monthViewController,
    ScrollController? yearViewController,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    ModePickerTextHandler? modePickerTextHandler,
    ModePickerBuilder? modePickerBuilder,
    double? modePickersGap,
    bool? rangeBidirectional,
    ScrollPhysics? calendarViewScrollPhysics,
    Color? daySplashColor,
    bool? allowSameValueSelection,
    bool? disableMonthPicker,
    bool? useAbbrLabelForMonthModePicker,
    double? dayMaxWidth,
    bool? hideMonthPickerDividers,
    bool? hideYearPickerDividers,
    TextStyle? scrollViewTopHeaderTextStyle,
    bool? hideScrollViewTopHeader,
    bool? hideScrollViewTopHeaderDivider,
    bool? hideScrollViewMonthWeekHeader,
    BoxConstraints? scrollViewConstraints,
    ScrollViewMonthYearBuilder? scrollViewMonthYearBuilder,
    ScrollViewOnScrolling? scrollViewOnScrolling,
    ScrollController? scrollViewController,
    bool? dynamicCalendarRows,
    Axis? dayModeScrollDirection,
    SelectedRangeHighlightBuilder? selectedRangeHighlightBuilder,
    SelectedRangeDecorationPredicate? selectedRangeDecorationPredicate,
    bool? isPickMonthMode,
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
      weekdayLabelBuilder: weekdayLabelBuilder ?? this.weekdayLabelBuilder,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      hideLastMonthIcon: hideLastMonthIcon ?? this.hideLastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      hideNextMonthIcon: hideNextMonthIcon ?? this.hideNextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      animateToDisplayedMonthDate:
          animateToDisplayedMonthDate ?? this.animateToDisplayedMonthDate,
      semanticsDictionary: semanticsDictionary ?? this.semanticsDictionary,
      disableVibration: disableVibration ?? this.disableVibration,
      dayViewController: dayViewController ?? this.dayViewController,
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
      disabledYearTextStyle:
          disabledYearTextStyle ?? this.disabledYearTextStyle,
      selectedRangeDayTextStyle:
          selectedRangeDayTextStyle ?? this.selectedRangeDayTextStyle,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      selectedMonthTextStyle:
          selectedMonthTextStyle ?? this.selectedMonthTextStyle,
      disabledMonthTextStyle:
          disabledMonthTextStyle ?? this.disabledMonthTextStyle,
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
      monthViewController: monthViewController ?? this.monthViewController,
      yearViewController: yearViewController ?? this.yearViewController,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
      modePickerBuilder: modePickerBuilder ?? this.modePickerBuilder,
      modePickersGap: modePickersGap ?? this.modePickersGap,
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
      scrollViewTopHeaderTextStyle:
          scrollViewTopHeaderTextStyle ?? this.scrollViewTopHeaderTextStyle,
      hideScrollViewTopHeader:
          hideScrollViewTopHeader ?? this.hideScrollViewTopHeader,
      hideScrollViewTopHeaderDivider:
          hideScrollViewTopHeaderDivider ?? this.hideScrollViewTopHeaderDivider,
      hideScrollViewMonthWeekHeader:
          hideScrollViewMonthWeekHeader ?? this.hideScrollViewMonthWeekHeader,
      scrollViewConstraints:
          scrollViewConstraints ?? this.scrollViewConstraints,
      scrollViewMonthYearBuilder:
          scrollViewMonthYearBuilder ?? this.scrollViewMonthYearBuilder,
      scrollViewOnScrolling:
          scrollViewOnScrolling ?? this.scrollViewOnScrolling,
      scrollViewController: scrollViewController ?? this.scrollViewController,
      dynamicCalendarRows: dynamicCalendarRows ?? this.dynamicCalendarRows,
      dayModeScrollDirection:
          dayModeScrollDirection ?? this.dayModeScrollDirection,
      selectedRangeHighlightBuilder:
          selectedRangeHighlightBuilder ?? this.selectedRangeHighlightBuilder,
      selectedRangeDecorationPredicate: selectedRangeDecorationPredicate ??
          this.selectedRangeDecorationPredicate,
        isPickMonthMode: isPickMonthMode ?? this.isPickMonthMode,
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
    WeekdayLabelBuilder? weekdayLabelBuilder,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    bool? hideLastMonthIcon,
    Widget? nextMonthIcon,
    bool? hideNextMonthIcon,
    TextStyle? controlsTextStyle,
    bool? animateToDisplayedMonthDate,
    Map<CalendarDatePicker2SemanticsLabel, String?>? semanticsDictionary,
    bool? disableVibration,
    PageController? dayViewController,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? disabledYearTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    TextStyle? disabledMonthTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    BorderRadius? monthBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    SelectableMonthPredicate? selectableMonthPredicate,
    SelectableYearPredicate? selectableYearPredicate,
    DayTextStylePredicate? dayTextStylePredicate,
    DayBuilder? dayBuilder,
    YearBuilder? yearBuilder,
    MonthBuilder? monthBuilder,
    ScrollController? monthViewController,
    ScrollController? yearViewController,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    ModePickerTextHandler? modePickerTextHandler,
    ModePickerBuilder? modePickerBuilder,
    double? modePickersGap,
    bool? rangeBidirectional,
    ScrollPhysics? calendarViewScrollPhysics,
    Color? daySplashColor,
    bool? allowSameValueSelection,
    bool? disableMonthPicker,
    bool? useAbbrLabelForMonthModePicker,
    double? dayMaxWidth,
    bool? hideMonthPickerDividers,
    bool? hideYearPickerDividers,
    TextStyle? scrollViewTopHeaderTextStyle,
    bool? hideScrollViewTopHeader,
    bool? hideScrollViewTopHeaderDivider,
    bool? hideScrollViewMonthWeekHeader,
    BoxConstraints? scrollViewConstraints,
    ScrollViewMonthYearBuilder? scrollViewMonthYearBuilder,
    ScrollViewOnScrolling? scrollViewOnScrolling,
    ScrollController? scrollViewController,
    bool? dynamicCalendarRows,
    Axis? dayModeScrollDirection,
    SelectedRangeHighlightBuilder? selectedRangeHighlightBuilder,
    SelectedRangeDecorationPredicate? selectedRangeDecorationPredicate,
    this.gapBetweenCalendarAndButtons,
    this.cancelButtonTextStyle,
    this.cancelButton,
    this.okButtonTextStyle,
    this.okButton,
    this.openedFromDialog,
    this.closeDialogOnCancelTapped,
    this.closeDialogOnOkTapped,
    this.buttonPadding,
    bool? isPickMonthMode,
  }) : super(
          calendarType: calendarType,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          calendarViewMode: calendarViewMode,
          weekdayLabels: weekdayLabels,
          weekdayLabelTextStyle: weekdayLabelTextStyle,
          weekdayLabelBuilder: weekdayLabelBuilder,
          firstDayOfWeek: firstDayOfWeek,
          controlsHeight: controlsHeight,
          lastMonthIcon: lastMonthIcon,
          hideLastMonthIcon: hideLastMonthIcon,
          nextMonthIcon: nextMonthIcon,
          hideNextMonthIcon: hideNextMonthIcon,
          controlsTextStyle: controlsTextStyle,
          animateToDisplayedMonthDate: animateToDisplayedMonthDate,
          semanticsDictionary: semanticsDictionary,
          disableVibration: disableVibration,
          dayViewController: dayViewController,
          dayTextStyle: dayTextStyle,
          selectedDayTextStyle: selectedDayTextStyle,
          selectedRangeDayTextStyle: selectedRangeDayTextStyle,
          selectedDayHighlightColor: selectedDayHighlightColor,
          selectedRangeHighlightColor: selectedRangeHighlightColor,
          disabledDayTextStyle: disabledDayTextStyle,
          todayTextStyle: todayTextStyle,
          yearTextStyle: yearTextStyle,
          selectedYearTextStyle: selectedYearTextStyle,
          disabledYearTextStyle: disabledYearTextStyle,
          monthTextStyle: monthTextStyle,
          selectedMonthTextStyle: selectedMonthTextStyle,
          disabledMonthTextStyle: disabledMonthTextStyle,
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
          monthViewController: monthViewController,
          yearViewController: yearViewController,
          disableModePicker: disableModePicker,
          centerAlignModePicker: centerAlignModePicker,
          customModePickerIcon: customModePickerIcon,
          modePickerTextHandler: modePickerTextHandler,
          modePickerBuilder: modePickerBuilder,
          modePickersGap: modePickersGap,
          rangeBidirectional: rangeBidirectional,
          calendarViewScrollPhysics: calendarViewScrollPhysics,
          daySplashColor: daySplashColor,
          allowSameValueSelection: allowSameValueSelection,
          disableMonthPicker: disableMonthPicker,
          useAbbrLabelForMonthModePicker: useAbbrLabelForMonthModePicker,
          dayMaxWidth: dayMaxWidth,
          hideMonthPickerDividers: hideMonthPickerDividers,
          hideYearPickerDividers: hideYearPickerDividers,
          scrollViewTopHeaderTextStyle: scrollViewTopHeaderTextStyle,
          hideScrollViewTopHeader: hideScrollViewTopHeader,
          hideScrollViewTopHeaderDivider: hideScrollViewTopHeaderDivider,
          hideScrollViewMonthWeekHeader: hideScrollViewMonthWeekHeader,
          scrollViewConstraints: scrollViewConstraints,
          scrollViewMonthYearBuilder: scrollViewMonthYearBuilder,
          scrollViewOnScrolling: scrollViewOnScrolling,
          scrollViewController: scrollViewController,
          dynamicCalendarRows: dynamicCalendarRows,
          dayModeScrollDirection: dayModeScrollDirection,
          selectedRangeHighlightBuilder: selectedRangeHighlightBuilder,
          selectedRangeDecorationPredicate: selectedRangeDecorationPredicate,
          isPickMonthMode: isPickMonthMode,
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
    WeekdayLabelBuilder? weekdayLabelBuilder,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    bool? hideLastMonthIcon,
    Widget? nextMonthIcon,
    bool? hideNextMonthIcon,
    TextStyle? controlsTextStyle,
    bool? animateToDisplayedMonthDate,
    Map<CalendarDatePicker2SemanticsLabel, String?>? semanticsDictionary,
    bool? disableVibration,
    PageController? dayViewController,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    TextStyle? selectedRangeDayTextStyle,
    Color? selectedDayHighlightColor,
    Color? selectedRangeHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    TextStyle? disabledYearTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? selectedMonthTextStyle,
    TextStyle? disabledMonthTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    BorderRadius? monthBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    SelectableMonthPredicate? selectableMonthPredicate,
    SelectableYearPredicate? selectableYearPredicate,
    DayTextStylePredicate? dayTextStylePredicate,
    DayBuilder? dayBuilder,
    YearBuilder? yearBuilder,
    MonthBuilder? monthBuilder,
    ScrollController? monthViewController,
    ScrollController? yearViewController,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    ModePickerTextHandler? modePickerTextHandler,
    ModePickerBuilder? modePickerBuilder,
    double? modePickersGap,
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
    TextStyle? scrollViewTopHeaderTextStyle,
    bool? hideScrollViewTopHeader,
    bool? hideScrollViewTopHeaderDivider,
    bool? hideScrollViewMonthWeekHeader,
    BoxConstraints? scrollViewConstraints,
    ScrollViewMonthYearBuilder? scrollViewMonthYearBuilder,
    ScrollViewOnScrolling? scrollViewOnScrolling,
    ScrollController? scrollViewController,
    bool? dynamicCalendarRows,
    Axis? dayModeScrollDirection,
    SelectedRangeHighlightBuilder? selectedRangeHighlightBuilder,
    SelectedRangeDecorationPredicate? selectedRangeDecorationPredicate,
    bool? isPickMonthMode,
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
      weekdayLabelBuilder: weekdayLabelBuilder ?? this.weekdayLabelBuilder,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      hideLastMonthIcon: hideLastMonthIcon ?? this.hideLastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      hideNextMonthIcon: hideNextMonthIcon ?? this.hideNextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      animateToDisplayedMonthDate:
          animateToDisplayedMonthDate ?? this.animateToDisplayedMonthDate,
      semanticsDictionary: semanticsDictionary ?? this.semanticsDictionary,
      disableVibration: disableVibration ?? this.disableVibration,
      dayViewController: dayViewController ?? this.dayViewController,
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
      disabledYearTextStyle:
          disabledYearTextStyle ?? this.disabledYearTextStyle,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      selectedMonthTextStyle:
          selectedMonthTextStyle ?? this.selectedMonthTextStyle,
      disabledMonthTextStyle:
          disabledMonthTextStyle ?? this.disabledMonthTextStyle,
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
      monthViewController: monthViewController ?? this.monthViewController,
      yearViewController: yearViewController ?? this.yearViewController,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
      modePickerBuilder: modePickerBuilder ?? this.modePickerBuilder,
      modePickersGap: modePickersGap ?? this.modePickersGap,
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
      scrollViewTopHeaderTextStyle:
          scrollViewTopHeaderTextStyle ?? this.scrollViewTopHeaderTextStyle,
      hideScrollViewTopHeader:
          hideScrollViewTopHeader ?? this.hideScrollViewTopHeader,
      hideScrollViewTopHeaderDivider:
          hideScrollViewTopHeaderDivider ?? this.hideScrollViewTopHeaderDivider,
      hideScrollViewMonthWeekHeader:
          hideScrollViewMonthWeekHeader ?? this.hideScrollViewMonthWeekHeader,
      scrollViewConstraints:
          scrollViewConstraints ?? this.scrollViewConstraints,
      scrollViewMonthYearBuilder:
          scrollViewMonthYearBuilder ?? this.scrollViewMonthYearBuilder,
      scrollViewOnScrolling:
          scrollViewOnScrolling ?? this.scrollViewOnScrolling,
      scrollViewController: scrollViewController ?? this.scrollViewController,
      dynamicCalendarRows: dynamicCalendarRows ?? this.dynamicCalendarRows,
      dayModeScrollDirection:
          dayModeScrollDirection ?? this.dayModeScrollDirection,
      selectedRangeHighlightBuilder:
          selectedRangeHighlightBuilder ?? this.selectedRangeHighlightBuilder,
      selectedRangeDecorationPredicate: selectedRangeDecorationPredicate ??
          this.selectedRangeDecorationPredicate,
      isPickMonthMode: isPickMonthMode,
    );
  }
}
