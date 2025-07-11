part of '../calendar_date_picker2.dart';

/// Displays a scrollable calendar grid that allows a user to select dates
class _CalendarScrollView extends StatefulWidget {
  /// Creates a scrollable calendar grid for picking dates
  const _CalendarScrollView({
    required this.config,
    required this.initialMonth,
    required this.selectedDates,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The initial month to display.
  final DateTime initialMonth;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  @override
  _CalendarScrollViewState createState() => _CalendarScrollViewState();
}

class _CalendarScrollViewState extends State<_CalendarScrollView> {
  final GlobalKey _scrollViewKey = GlobalKey();
  int _initialMonthIndex = 0;
  late ScrollController _controller;
  late bool _showWeekBottomDivider;

  late MaterialLocalizations _localizations;

  @override
  void initState() {
    super.initState();
    _controller = widget.config.scrollViewController ?? ScrollController();
    _controller.addListener(_scrollListener);

    // Calculate the index for the initially displayed month. This is needed to
    // divide the list of months into two `SliverList`s.
    final DateTime initialDate = widget.initialMonth;
    if (!initialDate.isBefore(widget.config.firstDate) &&
        !initialDate.isAfter(widget.config.lastDate)) {
      _initialMonthIndex =
          DateUtils.monthDelta(widget.config.firstDate, initialDate);
    }

    _showWeekBottomDivider = _initialMonthIndex != 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
  }

  void _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent) {
      setState(() {
        _showWeekBottomDivider = false;
      });
    } else if (!_showWeekBottomDivider) {
      setState(() {
        _showWeekBottomDivider = true;
      });
    }
    widget.config.scrollViewOnScrolling?.call(_controller.offset);
  }

  int get _numberOfMonths =>
      DateUtils.monthDelta(widget.config.firstDate, widget.config.lastDate) + 1;

  Widget _buildMonthItem(
      BuildContext context, int index, bool beforeInitialMonth) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextTheme textTheme = themeData.textTheme;
    final Color controlColor = colorScheme.onSurface.withOpacity(0.60);
    final int monthIndex = beforeInitialMonth
        ? _initialMonthIndex - index - 1
        : _initialMonthIndex + index;
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.config.firstDate, monthIndex);
    final dayRowsCount = widget.config.dynamicCalendarRows == true
        ? getDayRowsCount(
            month.year,
            month.month,
            widget.config.firstDayOfWeek ?? _localizations.firstDayOfWeekIndex,
          )
        : _maxDayPickerRowCount;
    var totalRowsCount = dayRowsCount + 1;
    var rowHeight = widget.config.dayMaxWidth != null
        ? (widget.config.dayMaxWidth! + 2)
        : _dayPickerRowHeight;
    if (widget.config.calendarViewMode == CalendarDatePicker2Mode.scroll &&
        widget.config.hideScrollViewMonthWeekHeader == true) {
      // Exclude header row
      totalRowsCount -= 1;
    }
    final maxContentHeight = rowHeight * totalRowsCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.config.scrollViewMonthYearBuilder?.call(month) ??
            Row(
              children: [
                if (widget.config.centerAlignModePicker == true) const Spacer(),
                Container(
                  height: rowHeight,
                  margin: const EdgeInsets.symmetric(
                      horizontal: _monthPickerHorizontalPadding),
                  padding: const EdgeInsets.symmetric(
                      horizontal: _monthPickerHorizontalPadding),
                  child: Center(
                    child: Text(
                      widget.config.modePickerTextHandler
                              ?.call(monthDate: month) ??
                          _localizations.formatMonthYear(month),
                      style: widget.config.controlsTextStyle ??
                          textTheme.titleSmall?.copyWith(color: controlColor),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
        SizedBox(
          height: maxContentHeight,
          child: _DayPicker(
            key: ValueKey<DateTime>(month),
            config: widget.config,
            selectedDates: widget.selectedDates.whereType<DateTime>().toList(),
            displayedMonth: month,
            onChanged: widget.onChanged,
            dayRowsCount: dayRowsCount,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Key monthsAfterInitialMonthKey = Key('monthsAfterInitialMonth');

    return Column(
      children: <Widget>[
        if (widget.config.hideScrollViewTopHeader != true)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CalendarScrollViewHeader(widget.config),
              if (_showWeekBottomDivider &&
                  widget.config.hideScrollViewTopHeaderDivider != true)
                const Divider(height: 0),
            ],
          ),
        Expanded(
          child: _CalendarKeyboardNavigator(
            config: widget.config,
            firstDate: widget.config.firstDate,
            lastDate: widget.config.lastDate,
            initialFocusedDay: widget.config.currentDate,
            // In order to prevent performance issues when displaying the
            // correct initial month, 2 `SliverList`s are used to split the
            // months. The first item in the second SliverList is the initial
            // month to be displayed.
            child: CustomScrollView(
              key: _scrollViewKey,
              controller: _controller,
              center: monthsAfterInitialMonthKey,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        _buildMonthItem(context, index, true),
                    childCount: _initialMonthIndex,
                  ),
                ),
                SliverList(
                  key: monthsAfterInitialMonthKey,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        _buildMonthItem(context, index, false),
                    childCount: _numberOfMonths - _initialMonthIndex,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarKeyboardNavigator extends StatefulWidget {
  const _CalendarKeyboardNavigator({
    required this.config,
    required this.child,
    required this.firstDate,
    required this.lastDate,
    required this.initialFocusedDay,
  });

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  final Widget child;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialFocusedDay;

  @override
  _CalendarKeyboardNavigatorState createState() =>
      _CalendarKeyboardNavigatorState();
}

class _CalendarKeyboardNavigatorState
    extends State<_CalendarKeyboardNavigator> {
  final Map<ShortcutActivator, Intent> _shortcutMap =
      const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowLeft):
        DirectionalFocusIntent(TraversalDirection.left),
    SingleActivator(LogicalKeyboardKey.arrowRight):
        DirectionalFocusIntent(TraversalDirection.right),
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };
  late Map<Type, Action<Intent>> _actionMap;
  late FocusNode _dayGridFocus;
  TraversalDirection? _dayTraversalDirection;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();

    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent:
          CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void dispose() {
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _focusedDay ??= widget.initialFocusedDay;
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final DateTime? nextDate =
          _nextDateInDirection(_focusedDay!, intent.direction);
      if (nextDate != null) {
        _focusedDay = nextDate;
        _dayTraversalDirection = intent.direction;
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(
      TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    final DateTime nextDate = DateUtils.addDaysToDate(
        date, _dayDirectionOffset(direction, textDirection));
    if (!nextDate.isBefore(widget.config.firstDate) &&
        !nextDate.isAfter(widget.config.lastDate)) {
      return nextDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: _shortcutMap,
      actions: _actionMap,
      focusNode: _dayGridFocus,
      onFocusChange: _handleGridFocusChange,
      child: _FocusedDate(
        date: _dayGridFocus.hasFocus ? _focusedDay : null,
        scrollDirection: _dayGridFocus.hasFocus ? _dayTraversalDirection : null,
        child: widget.child,
      ),
    );
  }
}

class _CalendarScrollViewHeader extends StatelessWidget {
  const _CalendarScrollViewHeader(this.config);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

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
    final weekdays = config.weekdayLabels ?? localizations.narrowWeekdays;
    final firstDayOfWeek =
        config.firstDayOfWeek ?? localizations.firstDayOfWeekIndex;
    assert(firstDayOfWeek >= 0 && firstDayOfWeek <= 6,
        'firstDayOfWeek must between 0 and 6');
    for (int i = firstDayOfWeek; true; i = (i + 1) % 7) {
      final String weekday = weekdays[i];
      result.add(ExcludeSemantics(
        child: Center(
          child: config.weekdayLabelBuilder
                  ?.call(weekday: i, isScrollViewTopHeader: true) ??
              Text(
                weekday,
                style: config.scrollViewTopHeaderTextStyle ??
                    config.weekdayLabelTextStyle ??
                    headerStyle,
              ),
        ),
      ));
      if (i == (firstDayOfWeek - 1) % 7) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextStyle? headerStyle = themeData.textTheme.bodySmall?.apply(
      color: colorScheme.onSurface.withOpacity(0.60),
    );
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final List<Widget> headers = _dayHeaders(headerStyle, localizations);

    return Container(
      constraints: BoxConstraints(
          maxHeight: config.dayMaxWidth != null
              ? config.dayMaxWidth! + 2
              : _dayPickerRowHeight),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double tileWidth =
            (constraints.maxWidth - _monthPickerHorizontalPadding * 2) /
                DateTime.daysPerWeek;

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _monthPickerHorizontalPadding),
          child: Row(
            children: [
              const Spacer(),
              for (Widget header in headers)
                SizedBox(
                  width: tileWidth,
                  height: _dayPickerRowHeight,
                  child: Center(child: header),
                ),
              const Spacer(),
            ],
          ),
        );
      }),
    );
  }
}
