part of '../calendar_date_picker2.dart';

/// A scrollable grid of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
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
class YearPicker extends StatefulWidget {
  /// Creates a year picker.
  const YearPicker({
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

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  /// The initial month to display.
  final DateTime initialMonth;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  late ScrollController _scrollController;

  late List<FocusNode> _yearFocusNodes;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();
    final scrollOffset =
        widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
            ? _scrollOffsetForYear(widget.selectedDates[0]!)
            : _scrollOffsetForYear(DateUtils.dateOnly(DateTime.now()));
    _scrollController = widget.config.yearViewController ??
        ScrollController(initialScrollOffset: scrollOffset);

    _yearFocusNodes = List<FocusNode>.generate(
      math.max(widget.config.totalYears, minYears),
      (index) =>
          FocusNode(debugLabel: 'Year ${widget.config.firstDate.year + index}'),
    );
  }

  @override
  void didUpdateWidget(YearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDates != oldWidget.selectedDates) {
      final scrollOffset =
          widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
              ? _scrollOffsetForYear(widget.selectedDates[0]!)
              : _scrollOffsetForYear(DateUtils.dateOnly(DateTime.now()));
      _scrollController.jumpTo(scrollOffset);
    }
  }

  double _scrollOffsetForYear(DateTime date) {
    final int initialYearIndex = date.year - widget.config.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ _yearPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    return widget.config.totalYears < minYears
        ? 0
        : centeredYearRow * _yearPickerRowHeight;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var focusNode in _yearFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        Divider(
          color: widget.config.hideYearPickerDividers == true
              ? Colors.transparent
              : null,
        ),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            dragStartBehavior: widget.dragStartBehavior,
            gridDelegate: const _YearPickerGridDelegate(),
            itemBuilder: (_, index) => YearPickerItem(
              index,
              focusNode: _yearFocusNodes[index],
              config: widget.config,
              selectedDates: widget.selectedDates,
              onChanged: widget.onChanged,
              initialMonth: widget.initialMonth,
              minYears: minYears,
            ),
            itemCount: math.max(widget.config.totalYears, minYears),
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        ),
        Divider(
          color: widget.config.hideYearPickerDividers == true
              ? Colors.transparent
              : null,
        ),
      ],
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  const _YearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_yearPickerColumnCount - 1) * _yearPickerRowSpacing) /
        _yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _yearPickerRowHeight,
      crossAxisCount: _yearPickerColumnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: _yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}
