part of '../calendar_date_picker2.dart';

/// A button that used to toggle the [CalendarDatePicker2Mode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [CalendarDatePicker2Mode] to display either the calendar view or the year list.
class _DatePickerModeToggleButton extends StatefulWidget {
  const _DatePickerModeToggleButton({
    required this.mode,
    required this.month,
    required this.year,
    required this.onMonthPressed,
    required this.onYearPressed,
    required this.config,
  });

  /// The current display of the calendar picker.
  final CalendarDatePicker2Mode mode;

  /// The current selected month.
  final int month;

  /// The current selected year.
  final int year;

  /// The callback when the month is pressed.
  final VoidCallback onMonthPressed;

  /// The callback when the year is pressed.
  final VoidCallback onYearPressed;

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  @override
  _DatePickerModeToggleButtonState createState() =>
      _DatePickerModeToggleButtonState();
}

class _DatePickerModeToggleButtonState
    extends State<_DatePickerModeToggleButton> with TickerProviderStateMixin {
  late AnimationController _monthController;
  late AnimationController _yearController;

  @override
  void initState() {
    super.initState();
    _monthController = AnimationController(
      value: widget.mode == CalendarDatePicker2Mode.year ||
              widget.mode == CalendarDatePicker2Mode.month
          ? 0.5
          : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _yearController = AnimationController(
      value: widget.mode == CalendarDatePicker2Mode.year ||
              widget.mode == CalendarDatePicker2Mode.month
          ? 0.5
          : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_DatePickerModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == CalendarDatePicker2Mode.month) {
      _monthController.forward();
    } else if (widget.mode == CalendarDatePicker2Mode.year) {
      _yearController.forward();
    } else {
      _monthController.reverse();
      _yearController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextTheme textTheme = themeData.textTheme;
    final Color controlColor = colorScheme.onSurface.withOpacity(0.60);

    var datePickerOffsetPadding = _monthNavButtonsWidth;
    if (widget.config.centerAlignModePicker == true) {
      datePickerOffsetPadding /= 2;
    }

    return Container(
      padding: widget.config.centerAlignModePicker == true
          ? EdgeInsets.zero
          : const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: (widget.config.controlsHeight ?? _subHeaderHeight),
      child: Row(
        children: <Widget>[
          if (widget.mode == CalendarDatePicker2Mode.day &&
              widget.config.centerAlignModePicker == true)
            // Give space for the prev/next month buttons that are underneath this row
            SizedBox(width: datePickerOffsetPadding),
          Flexible(
            child: Semantics(
              label: MaterialLocalizations.of(context).selectYearSemanticsLabel,
              excludeSemantics: true,
              button: true,
              child: SizedBox(
                height: (widget.config.controlsHeight ?? _subHeaderHeight),
                child: InkWell(
                  onTap: widget.config.disableModePicker == true
                      ? null
                      : widget.onMonthPressed,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.config.centerAlignModePicker == true
                            ? 0
                            : 8),
                    child: Row(
                      mainAxisAlignment:
                          widget.config.centerAlignModePicker == true
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            getMonthName(widget.year, widget.month),
                            overflow: TextOverflow.ellipsis,
                            style: widget.config.controlsTextStyle ??
                                textTheme.titleSmall?.copyWith(
                                  color: controlColor,
                                ),
                          ),
                        ),
                        widget.config.disableModePicker == true
                            ? const SizedBox()
                            : RotationTransition(
                                turns: _monthController,
                                child: widget.config.customModePickerIcon ??
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: widget.config.controlsTextStyle
                                              ?.color ??
                                          controlColor,
                                    ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Semantics(
              label: MaterialLocalizations.of(context).selectYearSemanticsLabel,
              excludeSemantics: true,
              button: true,
              child: SizedBox(
                height: (widget.config.controlsHeight ?? _subHeaderHeight),
                child: InkWell(
                  onTap: widget.config.disableModePicker == true
                      ? null
                      : widget.onYearPressed,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.config.centerAlignModePicker == true
                            ? 0
                            : 8),
                    child: Row(
                      mainAxisAlignment:
                          widget.config.centerAlignModePicker == true
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.year.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: widget.config.controlsTextStyle ??
                                textTheme.titleSmall?.copyWith(
                                  color: controlColor,
                                ),
                          ),
                        ),
                        widget.config.disableModePicker == true
                            ? const SizedBox()
                            : RotationTransition(
                                turns: _yearController,
                                child: widget.config.customModePickerIcon ??
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: widget.config.controlsTextStyle
                                              ?.color ??
                                          controlColor,
                                    ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.mode == CalendarDatePicker2Mode.day)
            // Give space for the prev/next month buttons that are underneath this row
            SizedBox(width: datePickerOffsetPadding),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
