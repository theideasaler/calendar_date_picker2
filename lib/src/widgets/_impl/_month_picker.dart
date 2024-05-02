part of '../calendar_date_picker2.dart';

/// A scrollable grid of months to allow picking a month.
///
/// The month picker widget is rarely used directly. Instead, consider using
/// [CalendarDatePicker2], or [showDatePicker2] which create full date pickers.
///
/// See also:
///
///  * [CalendarDatePicker2], which provides a Material Design date picker
///    interface.
///
///  * [showDatePicker2], which shows a dialog containing a Material Design
///    date picker.
///
class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  const _MonthPicker({
    required this.config,
    required this.selectedDates,
    required this.onChanged,
    required this.initialMonth,
    this.dragStartBehavior = DragStartBehavior.start,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onChanged;

  /// The initial month to display.
  final DateTime initialMonth;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  @override
  State<_MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  late ScrollController _scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minMonths = 12;

  @override
  void initState() {
    super.initState();
    final scrollOffset =
        widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
            ? _scrollOffsetForMonth(widget.selectedDates[0]!)
            : _scrollOffsetForMonth(DateUtils.dateOnly(DateTime.now()));
    _scrollController = ScrollController(initialScrollOffset: scrollOffset);
  }

  @override
  void didUpdateWidget(_MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDates != oldWidget.selectedDates) {
      final scrollOffset =
          widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
              ? _scrollOffsetForMonth(widget.selectedDates[0]!)
              : _scrollOffsetForMonth(DateUtils.dateOnly(DateTime.now()));
      _scrollController.jumpTo(scrollOffset);
    }
  }

  double _scrollOffsetForMonth(DateTime date) {
    final int initialMonthIndex = date.month - DateTime.january;
    final int initialMonthRow = initialMonthIndex ~/ _monthPickerColumnCount;
    final int centeredMonthRow = initialMonthRow - 2;
    return _itemCount < minMonths
        ? 0
        : centeredMonthRow * _monthPickerRowHeight;
  }

  Widget _buildMonthItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _MonthPicker with disabled months if necessary.
    final int offset =
        _itemCount < minMonths ? (minMonths - _itemCount) ~/ 2 : 0;
    final int month = DateTime.january + index - offset;
    final bool isSelected = widget.selectedDates.isNotEmpty &&
        widget.selectedDates[0] != null &&
        widget.selectedDates[0]!.month == month;
    final bool isDisabled = month < widget.config.firstDate.month;
    final bool isCurrentMonth = month == widget.config.currentDate.month;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    final Color textColor;
    if (isSelected) {
      textColor = colorScheme.onPrimary;
    } else if (isDisabled) {
      textColor = colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentMonth) {
      textColor =
          widget.config.selectedDayHighlightColor ?? colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withOpacity(0.87);
    }

    TextStyle? itemStyle = widget.config.monthTextStyle ??
        textTheme.bodyLarge?.apply(color: textColor);
    if (isSelected) {
      itemStyle = widget.config.selectedMonthTextStyle ?? itemStyle;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
        borderRadius: widget.config.monthBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    } else if (isCurrentMonth && !isDisabled) {
      decoration = BoxDecoration(
        border: Border.all(
          color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
        ),
        borderRadius: widget.config.monthBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    }

    Widget monthItem = widget.config.monthBuilder?.call(
          month: month,
          textStyle: itemStyle,
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: isDisabled,
          isCurrentMonth: isCurrentMonth,
        ) ??
        Center(
          child: Container(
            decoration: decoration,
            height: decorationHeight,
            width: decorationWidth,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Text(
                  // show the month as a name
                  getMonthName(
                    DateUtils.dateOnly(DateTime.now()).year,
                    month,
                  ),
                  style: itemStyle,
                ),
              ),
            ),
          ),
        );

    if (isDisabled) {
      monthItem = ExcludeSemantics(
        child: monthItem,
      );
    } else {
      monthItem = InkWell(
        key: ValueKey<int>(month),
        onTap: isDisabled
            ? null
            : () {
                widget.onChanged(DateUtils.dateOnly(
                  DateTime(widget.initialMonth.year, month),
                ));
              },
        child: monthItem,
      );
    }

    return monthItem;
  }

  int get _itemCount {
    return DateTime.december - DateTime.january + 1;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        const Divider(),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            dragStartBehavior: widget.dragStartBehavior,
            gridDelegate: _monthPickerGridDelegate,
            itemBuilder: _buildMonthItem,
            itemCount: math.max(_itemCount, minMonths),
            padding:
                const EdgeInsets.symmetric(horizontal: _monthPickerPadding),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _MonthPickerGridDelegate extends SliverGridDelegate {
  const _MonthPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_monthPickerColumnCount - 1) * _monthPickerRowSpacing) /
        _monthPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _monthPickerRowHeight,
      crossAxisCount: _monthPickerColumnCount,
      crossAxisStride: tileWidth + _monthPickerRowSpacing,
      mainAxisStride: _monthPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthPickerGridDelegate oldDelegate) => false;
}

const _MonthPickerGridDelegate _monthPickerGridDelegate =
    _MonthPickerGridDelegate();
