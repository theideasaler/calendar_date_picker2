import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CalendarDatePicker2WithActionButtons extends StatefulWidget {
  const CalendarDatePicker2WithActionButtons({
    required this.initialValue,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
    this.onCancelTapped,
    this.onOkTapped,
    Key? key,
  }) : super(key: key);

  final List<DateTime?> initialValue;

  /// Called when the user taps 'OK' button
  final ValueChanged<List<DateTime?>>? onValueChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The calendar configurations including action buttons
  final CalendarDatePicker2WithActionButtonsConfig config;

  /// The callback when cancel button is tapped
  final Function? onCancelTapped;

  /// The callback when ok button is tapped
  final Function? onOkTapped;

  @override
  State<CalendarDatePicker2WithActionButtons> createState() =>
      _CalendarDatePicker2WithActionButtonsState();
}

class _CalendarDatePicker2WithActionButtonsState
    extends State<CalendarDatePicker2WithActionButtons> {
  List<DateTime?> _values = [];
  List<DateTime?> _editCache = [];

  @override
  void initState() {
    _values = widget.initialValue;
    _editCache = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(
      covariant CalendarDatePicker2WithActionButtons oldWidget) {
    var isValueSame =
        oldWidget.initialValue.length == widget.initialValue.length;

    if (isValueSame) {
      for (var i = 0; i < oldWidget.initialValue.length; i++) {
        var isSame = (oldWidget.initialValue[i] == null &&
                widget.initialValue[i] == null) ||
            DateUtils.isSameDay(
                oldWidget.initialValue[i], widget.initialValue[i]);
        if (!isSame) {
          isValueSame = false;
          break;
        }
      }
    }

    if (!isValueSame) {
      _values = widget.initialValue;
      _editCache = widget.initialValue;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.removePadding(
          context: context,
          child: CalendarDatePicker2(
            initialValue: [..._editCache],
            config: widget.config,
            onValueChanged: (values) => _editCache = values,
            onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
            selectableDayPredicate: widget.selectableDayPredicate,
          ),
        ),
        SizedBox(height: widget.config.gapBetweenCalendarAndButtons ?? 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildCancelButton(Theme.of(context).colorScheme),
            if ((widget.config.gapBetweenCalendarAndButtons ?? 0) > 0)
              SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
            _buildOkButton(Theme.of(context).colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(ColorScheme colorScheme) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _editCache = _values;
        widget.onCancelTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnCancelTapped ?? true)) {
          Navigator.pop(context);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.cancelButton ??
            Text(
              'CANCEL',
              style: widget.config.cancelButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ??
                        colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }

  Widget _buildOkButton(ColorScheme colorScheme) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _values = _editCache;
        widget.onValueChanged?.call(_values);
        widget.onOkTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnOkTapped ?? true)) {
          Navigator.pop(context, _values);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.okButton ??
            Text(
              'OK',
              style: widget.config.cancelButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ??
                        colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }
}
