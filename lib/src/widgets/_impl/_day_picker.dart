part of '../calendar_date_picker2.dart';

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _DayPicker extends StatefulWidget {
  /// Creates a day picker.
  const _DayPicker({
    required this.config,
    required this.displayedMonth,
    required this.selectedDates,
    required this.onChanged,
    required this.dayRowsCount,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime> selectedDates;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// The number of rows to display in the day picker.
  final int dayRowsCount;

  @override
  _DayPickerState createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate.maybeOf(context)?.date;
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    final weekdays =
        widget.config.weekdayLabels ?? localizations.narrowWeekdays;
    final firstDayOfWeek =
        widget.config.firstDayOfWeek ?? localizations.firstDayOfWeekIndex;
    assert(firstDayOfWeek >= 0 && firstDayOfWeek <= 6,
        'firstDayOfWeek must between 0 and 6');
    for (int i = firstDayOfWeek; true; i = (i + 1) % 7) {
      final String weekday = weekdays[i];
      result.add(ExcludeSemantics(
        child: widget.config.weekdayLabelBuilder?.call(weekday: i) ??
            Center(
              child: Text(
                weekday,
                style: widget.config.weekdayLabelTextStyle ?? headerStyle,
              ),
            ),
      ));
      if (i == (firstDayOfWeek - 1) % 7) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? headerStyle = textTheme.bodySmall?.apply(
      color: colorScheme.onSurface.withOpacity(0.60),
    );
    final TextStyle dayStyle = textTheme.bodySmall!;
    final Color enabledDayColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledDayColor = colorScheme.onSurface.withOpacity(0.38);
    final Color selectedDayColor = colorScheme.onPrimary;
    final Color selectedDayBackground = colorScheme.primary;
    final Color todayColor = colorScheme.primary;
    final Color daySplashColor =
        widget.config.daySplashColor ?? selectedDayBackground.withOpacity(0.38);

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = getMonthFirstDayOffset(year, month,
        widget.config.firstDayOfWeek ?? localizations.firstDayOfWeekIndex);

    final List<Widget> dayItems = _dayHeaders(headerStyle, localizations);
    if (widget.config.calendarViewMode == CalendarDatePicker2Mode.scroll &&
        widget.config.hideScrollViewMonthWeekHeader == true) {
      dayItems.clear();
    }
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled = dayToBuild.isAfter(widget.config.lastDate) ||
            dayToBuild.isBefore(widget.config.firstDate) ||
            !(widget.config.selectableDayPredicate?.call(dayToBuild) ?? true);
        final bool isSelectedDay =
            widget.selectedDates.any((d) => DateUtils.isSameDay(d, dayToBuild));

        final bool isToday =
            DateUtils.isSameDay(widget.config.currentDate, dayToBuild);

        BoxDecoration? decoration;
        Color dayColor = enabledDayColor;
        if (isSelectedDay) {
          // The selected day gets a circle background highlight, and a
          // contrasting text color.
          dayColor = selectedDayColor;
          decoration = BoxDecoration(
            borderRadius: widget.config.dayBorderRadius,
            color: widget.config.selectedDayHighlightColor ??
                selectedDayBackground,
            shape: widget.config.dayBorderRadius != null
                ? BoxShape.rectangle
                : BoxShape.circle,
          );
        } else if (isDisabled) {
          dayColor = disabledDayColor;
        } else if (isToday) {
          // The current day gets a different text color and a circle stroke
          // border.
          dayColor = widget.config.selectedDayHighlightColor ?? todayColor;
          decoration = BoxDecoration(
            borderRadius: widget.config.dayBorderRadius,
            border: Border.all(color: dayColor),
            shape: widget.config.dayBorderRadius != null
                ? BoxShape.rectangle
                : BoxShape.circle,
          );
        }

        var customDayTextStyle =
            widget.config.dayTextStylePredicate?.call(date: dayToBuild) ??
                widget.config.dayTextStyle;

        if (isToday && widget.config.todayTextStyle != null) {
          customDayTextStyle = widget.config.todayTextStyle;
        }

        if (isDisabled) {
          customDayTextStyle = customDayTextStyle?.copyWith(
            color: disabledDayColor,
            fontWeight: FontWeight.normal,
          );
          if (widget.config.disabledDayTextStyle != null) {
            customDayTextStyle = widget.config.disabledDayTextStyle;
          }
        }

        final isFullySelectedRangePicker =
            widget.config.calendarType == CalendarDatePicker2Type.range &&
                widget.selectedDates.length == 2;
        var isDateInBetweenRangePickerSelectedDates = false;

        if (isFullySelectedRangePicker) {
          final startDate = DateUtils.dateOnly(widget.selectedDates[0]);
          final endDate = DateUtils.dateOnly(widget.selectedDates[1]);

          isDateInBetweenRangePickerSelectedDates =
              !(dayToBuild.isBefore(startDate) ||
                      dayToBuild.isAfter(endDate)) &&
                  !DateUtils.isSameDay(startDate, endDate);
        }

        if (isDateInBetweenRangePickerSelectedDates &&
            widget.config.selectedRangeDayTextStyle != null) {
          customDayTextStyle = widget.config.selectedRangeDayTextStyle;
        }

        if (isSelectedDay) {
          customDayTextStyle = widget.config.selectedDayTextStyle;
        }

        final dayTextStyle =
            customDayTextStyle ?? dayStyle.apply(color: dayColor);

        Widget dayWidget = widget.config.dayBuilder?.call(
              date: dayToBuild,
              textStyle: dayTextStyle,
              decoration: decoration,
              isSelected: isSelectedDay,
              isDisabled: isDisabled,
              isToday: isToday,
            ) ??
            _buildDefaultDayWidgetContent(
              decoration,
              localizations,
              day,
              dayTextStyle,
            );

        if (isDateInBetweenRangePickerSelectedDates) {
          final rangePickerIncludedDayDecoration = BoxDecoration(
            color: widget.config.selectedRangeHighlightColor ??
                (widget.config.selectedDayHighlightColor ??
                        selectedDayBackground)
                    .withOpacity(0.15),
          );

          if (DateUtils.isSameDay(
            DateUtils.dateOnly(widget.selectedDates[0]),
            dayToBuild,
          )) {
            dayWidget = Stack(
              children: [
                Row(children: [
                  const Spacer(),
                  Expanded(
                    child: Container(
                      decoration: rangePickerIncludedDayDecoration,
                    ),
                  ),
                ]),
                dayWidget,
              ],
            );
          } else if (DateUtils.isSameDay(
            DateUtils.dateOnly(widget.selectedDates[1]),
            dayToBuild,
          )) {
            dayWidget = Stack(
              children: [
                Row(children: [
                  Expanded(
                    child: Container(
                      decoration: rangePickerIncludedDayDecoration,
                    ),
                  ),
                  const Spacer(),
                ]),
                dayWidget,
              ],
            );
          } else {
            dayWidget = Stack(
              children: [
                Container(
                  decoration: rangePickerIncludedDayDecoration,
                ),
                dayWidget,
              ],
            );
          }
        }

        dayWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: dayWidget,
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          var dayInkRadius = _dayPickerRowHeight / 2 + 4;
          if (widget.config.dayMaxWidth != null) {
            dayInkRadius = (widget.config.dayMaxWidth! + 2) / 2 + 4;
          }
          dayWidget = InkResponse(
            focusNode: _dayFocusNodes[day - 1],
            onTap: () => widget.onChanged(dayToBuild),
            radius: dayInkRadius,
            splashColor: daySplashColor,
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        gridDelegate: _DayPickerGridDelegate(
          config: widget.config,
          dayRowsCount: widget.dayRowsCount,
        ),
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }

  Widget _buildDefaultDayWidgetContent(
    BoxDecoration? decoration,
    MaterialLocalizations localizations,
    int day,
    TextStyle dayTextStyle,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: decoration,
              child: Center(
                child: Text(
                  localizations.formatDecimal(day),
                  style: dayTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate({
    required this.config,
    required this.dayRowsCount,
  });

  /// The calendar configurations
  final CalendarDatePicker2Config? config;

  /// The number of rows to display in the day picker.
  final int dayRowsCount;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    var totalRowsCount = dayRowsCount + 1;
    if (config?.calendarViewMode == CalendarDatePicker2Mode.scroll &&
        config?.hideScrollViewMonthWeekHeader == true) {
      totalRowsCount -= 1;
    }
    var rowHeight = config?.dayMaxWidth != null
        ? (config!.dayMaxWidth! + 2)
        : _dayPickerRowHeight;
    final double tileHeight = math.min(
      rowHeight,
      constraints.viewportMainAxisExtent / totalRowsCount,
    );
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}
