// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part '_impl/_calendar_view.dart';
part '_impl/_date_picker_mode_toggle_button.dart';
part '_impl/_day_picker.dart';
part '_impl/_focus_date.dart';
part '_impl/_month_picker.dart';
part '_impl/year_picker.dart';

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 8.0;

const int _yearPickerColumnCount = 3;
const double _yearPickerPadding = 16.0;
const double _yearPickerRowHeight = 52.0;
const double _yearPickerRowSpacing = 8.0;

const int _monthPickerColumnCount = 3;
const double _monthPickerPadding = 16.0;
const double _monthPickerRowHeight = 52.0;
const double _monthPickerRowSpacing = 8.0;

const double _subHeaderHeight = 52.0;
const double _monthNavButtonsWidth = 108.0;

class CalendarDatePicker2 extends StatefulWidget {
  CalendarDatePicker2({
    required this.config,
    required this.value,
    this.onValueChanged,
    this.displayedMonthDate,
    this.onDisplayedMonthChanged,
    Key? key,
  }) : super(key: key) {
    if (config.calendarType == CalendarDatePicker2Type.single) {
      assert(value.length <= 1,
          'Error: single date picker only allows maximum one initial date');
    }

    if (config.calendarType == CalendarDatePicker2Type.range &&
        value.length > 1) {
      assert(
        value.length == 2 && value[0].isBefore(value[1]),
        'Error: range date picker must has start date set before setting end date, and start date must before end date.',
      );
    }
  }

  /// The calendar UI related configurations
  final CalendarDatePicker2Config config;

  /// The selected [DateTime]s that the picker should display.
  final List<DateTime> value;

  /// Called when the selected dates changed
  final ValueChanged<List<DateTime>>? onValueChanged;

  /// Date to control calendar displayed month
  final DateTime? displayedMonthDate;

  /// Called when the displayed month changed
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  @override
  State<CalendarDatePicker2> createState() => _CalendarDatePicker2State();
}

class _CalendarDatePicker2State extends State<CalendarDatePicker2> {
  bool _announcedInitialDate = false;
  late List<DateTime> _selectedDates;
  late CalendarDatePicker2Mode _mode;
  late DateTime _currentDisplayedMonthDate;
  final GlobalKey _dayPickerKey = GlobalKey();
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    final initialDate = widget.displayedMonthDate ??
        DateUtils.dateOnly(
            widget.value.isNotEmpty ? widget.value[0] : DateTime.now());
    _mode = config.calendarViewMode;
    _currentDisplayedMonthDate = DateTime(initialDate.year, initialDate.month);
    _selectedDates = widget.value.toList();
  }

  @override
  void didUpdateWidget(CalendarDatePicker2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.calendarViewMode != oldWidget.config.calendarViewMode) {
      _mode = widget.config.calendarViewMode;
    }

    if (widget.displayedMonthDate != null) {
      _currentDisplayedMonthDate = DateTime(
        widget.displayedMonthDate!.year,
        widget.displayedMonthDate!.month,
      );
    }

    _selectedDates = widget.value.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate && _selectedDates.isNotEmpty) {
      _announcedInitialDate = true;
      for (final date in _selectedDates) {
        SemanticsService.announce(
          _localizations.formatFullDate(date),
          _textDirection,
        );
      }
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(CalendarDatePicker2Mode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_selectedDates.isNotEmpty) {
        for (final date in _selectedDates) {
          SemanticsService.announce(
            _mode == CalendarDatePicker2Mode.day
                ? _localizations.formatMonthYear(date)
                : _mode == CalendarDatePicker2Mode.month
                    ? _localizations.formatMonthYear(date)
                    : _localizations.formatYear(date),
            _textDirection,
          );
        }
      }
    });
  }

  void _handleDisplayedMonthDateChanged(
    DateTime date, {
    bool fromYearPicker = false,
  }) {
    _vibrate();
    setState(() {
      final currentDisplayedMonthDate = DateTime(
        _currentDisplayedMonthDate.year,
        _currentDisplayedMonthDate.month,
      );
      var newDisplayedMonthDate = currentDisplayedMonthDate;

      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        newDisplayedMonthDate = DateTime(date.year, date.month);
      }

      if (fromYearPicker) {
        final selectedDatesInThisYear = _selectedDates
            .where((d) => d.year == date.year)
            .toList()
          ..sort((d1, d2) => d1.compareTo(d2));
        if (selectedDatesInThisYear.isNotEmpty) {
          newDisplayedMonthDate =
              DateTime(date.year, selectedDatesInThisYear[0].month);
        }
      }

      if (currentDisplayedMonthDate.year != newDisplayedMonthDate.year ||
          currentDisplayedMonthDate.month != newDisplayedMonthDate.month) {
        _currentDisplayedMonthDate = DateTime(
          newDisplayedMonthDate.year,
          newDisplayedMonthDate.month,
        );
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleMonthChanged(DateTime value) {
    _vibrate();
    setState(() {
      _mode = CalendarDatePicker2Mode.day;
      _handleDisplayedMonthDateChanged(value);
    });
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    if (value.isBefore(widget.config.firstDate)) {
      value = widget.config.firstDate;
    } else if (value.isAfter(widget.config.lastDate)) {
      value = widget.config.lastDate;
    }

    setState(() {
      _mode = CalendarDatePicker2Mode.day;
      _handleDisplayedMonthDateChanged(value, fromYearPicker: true);
    });
  }

  void _handleDayChanged(DateTime newlySelectedDate) {
    _vibrate();

    var selectedDates = [..._selectedDates];
    var preventRefresh = false;

    switch (widget.config.calendarType) {
      case CalendarDatePicker2Type.single:
        var previouslySelectedDate =
            selectedDates.isEmpty ? null : selectedDates[0];
        if (widget.config.allowSameValueSelection == false &&
            DateUtils.isSameDay(previouslySelectedDate, newlySelectedDate)) {
          preventRefresh = true;
        } else {
          selectedDates = [newlySelectedDate];
        }
        break;

      case CalendarDatePicker2Type.multi:
        final index = selectedDates
            .indexWhere((d) => DateUtils.isSameDay(d, newlySelectedDate));
        if (index != -1) {
          selectedDates.removeAt(index);
        } else {
          selectedDates.add(newlySelectedDate);
        }
        selectedDates.sort((d1, d2) => d1.compareTo(d2));
        break;

      case CalendarDatePicker2Type.range:
        if (selectedDates.isEmpty) {
          selectedDates = [newlySelectedDate];
          break;
        }

        var previouslySelectedDate = selectedDates[0];
        if (selectedDates.length > 1) {
          // range previously set, so we reset the range to let the user start a
          // new range selection
          selectedDates = [newlySelectedDate];
        } else if (widget.config.rangeBidirectional != true &&
            newlySelectedDate.isBefore(previouslySelectedDate)) {
          // the user selected a date before the previously selected date, while
          // the bidirectional range selection is disabled, so we reset the range
          // to let the user start a new range selection
          selectedDates = [newlySelectedDate];
        } else {
          // The user previously selected a date, and just selected a new date
          selectedDates = [selectedDates[0], newlySelectedDate];
        }

        break;
    }

    if (!preventRefresh) {
      setState(() {
        _selectedDates = selectedDates;
      });
      widget.onValueChanged?.call(_selectedDates);
    }
  }

  Widget _buildPicker() {
    switch (_mode) {
      case CalendarDatePicker2Mode.day:
        return _CalendarView(
          config: widget.config,
          key: _dayPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          selectedDates: _selectedDates,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleDisplayedMonthDateChanged,
        );
      case CalendarDatePicker2Mode.month:
        return Padding(
          padding: EdgeInsets.only(
              top: widget.config.controlsHeight ?? _subHeaderHeight),
          child: _MonthPicker(
            config: widget.config,
            key: _monthPickerKey,
            initialMonth: _currentDisplayedMonthDate,
            selectedDates: _selectedDates,
            onChanged: _handleMonthChanged,
          ),
        );
      case CalendarDatePicker2Mode.year:
        return Padding(
          padding: EdgeInsets.only(
              top: widget.config.controlsHeight ?? _subHeaderHeight),
          child: YearPicker(
            config: widget.config,
            key: _yearPickerKey,
            initialMonth: _currentDisplayedMonthDate,
            selectedDates: _selectedDates,
            onChanged: _handleYearChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    var maxContentHeight = _maxDayPickerHeight;
    if (widget.config.dayMaxWidth != null) {
      maxContentHeight =
          (widget.config.dayMaxWidth! + 2) * (_maxDayPickerRowCount + 1);
    }

    return Stack(
      children: <Widget>[
        SizedBox(
          height: (widget.config.controlsHeight ?? _subHeaderHeight) +
              maxContentHeight,
          child: _buildPicker(),
        ),
        // Put the mode toggle button on top so that it won't be covered up by the _CalendarView
        _DatePickerModeToggleButton(
          config: widget.config,
          mode: _mode,
          monthDate: _currentDisplayedMonthDate,
          onMonthPressed: () {
            if (_mode == CalendarDatePicker2Mode.year) {
              _handleModeChanged(CalendarDatePicker2Mode.month);
            } else {
              _handleModeChanged(
                _mode == CalendarDatePicker2Mode.month
                    ? CalendarDatePicker2Mode.day
                    : CalendarDatePicker2Mode.month,
              );
            }
          },
          onYearPressed: () {
            if (_mode == CalendarDatePicker2Mode.month) {
              _handleModeChanged(CalendarDatePicker2Mode.year);
            } else {
              _handleModeChanged(
                _mode == CalendarDatePicker2Mode.year
                    ? CalendarDatePicker2Mode.day
                    : CalendarDatePicker2Mode.year,
              );
            }
          },
        ),
      ],
    );
  }
}
