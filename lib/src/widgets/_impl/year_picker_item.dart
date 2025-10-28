import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calendar_date_picker2/src/widgets/_impl/year_picker_item_default.dart';
import 'package:calendar_date_picker2/src/widgets/_impl/year_picker_item_defaults.dart';
import 'package:flutter/material.dart';

class YearPickerItem extends StatefulWidget {
  final int index;

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// The initial month to display.
  final DateTime initialMonth;

  // The approximate number of years necessary to fill the available space.
  final int minYears;

  final FocusNode focusNode;

  const YearPickerItem(
    this.index, {
    required this.focusNode,
    required this.config,
    required this.onChanged,
    required this.selectedDates,
    required this.initialMonth,
    required this.minYears,
    Key? key,
  }) : super(key: key);

  @override
  State<YearPickerItem> createState() => _YearPickerItemState();
}

class _YearPickerItemState extends State<YearPickerItem> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = widget.config.totalYears < widget.minYears
        ? (widget.minYears - widget.config.totalYears) ~/ 2
        : 0;
    final int year = widget.config.firstDate.year + widget.index - offset;

    final bool isSelected = widget.selectedDates.any((d) => d?.year == year);
    final bool isCurrentYear = year == widget.config.currentDate.year;

    final yearSelectableFromPredicate =
        widget.config.selectableYearPredicate?.call(year) ?? true;
    final isDisabled = (year < widget.config.firstDate.year ||
            year > widget.config.lastDate.year) ||
        !yearSelectableFromPredicate;

    TextStyle? textStyle = yearPickerTextStyle(
      widget.config,
      textTheme,
      colorScheme,
      isSelected,
      isCurrentYear,
      isDisabled,
    );

    const double decorationHeight = 36.0;

    BoxDecoration? decoration = yearPickerDecoration(
      widget.config,
      colorScheme,
      decorationHeight,
      isSelected: isSelected,
      isCurrentYear: isCurrentYear,
      isDisabled: isDisabled,
      isFocused: _isFocused,
      borderFocusColor: widget.config.focusColor,
    );

    Widget yearItem = widget.config.yearBuilder?.call(
          year: year,
          textStyle: textStyle,
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: isDisabled,
          isCurrentYear: isCurrentYear,
        ) ??
        YearPickerItemDefault(
          year,
          textStyle: textStyle,
          decoration: decoration,
          decorationHeight: decorationHeight,
          isSelected: isSelected,
        );

    if (isDisabled) {
      yearItem = ExcludeSemantics(child: yearItem);
    } else {
      yearItem = InkWell(
        focusNode: widget.focusNode,
        onFocusChange: (isFocused) {
          setState(() => _isFocused = isFocused);
        },
        key: ValueKey<int>(year),
        onTap: () => widget.onChanged(
          DateTime(year, widget.initialMonth.month),
        ),
        child: yearItem,
      );
    }

    return yearItem;
  }
}
