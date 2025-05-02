// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part '_impl/_calendar_scroll_view.dart';
part '_impl/_calendar_view.dart';
part '_impl/_date_picker_mode_toggle_button.dart';
part '_impl/_day_picker.dart';
part '_impl/_focus_date.dart';
part '_impl/_month_picker.dart';
part '_impl/year_picker.dart';

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
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
    const valid = true;
    const invalid = false;

    if (config.calendarType == CalendarDatePicker2Type.single) {
      assert(value.length < 2,
          'Error: single date picker only allows maximum one initial date');
    }

    if (config.calendarType == CalendarDatePicker2Type.range &&
        value.length > 1) {
      final isRangePickerValueValid = value[0] == null
          ? (value[1] != null ? invalid : valid)
          : (value[1] != null
              ? (value[1]!.isBefore(value[0]!) ? invalid : valid)
              : valid);

      assert(
        isRangePickerValueValid,
        'Error: range date picker must has start date set before setting end date, and start date must before end date.',
      );
    }
  }

  /// The calendar UI related configurations
  final CalendarDatePicker2Config config;

  /// The selected [DateTime]s that the picker should display.
  final List<DateTime?> value;

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
  late List<DateTime?> _selectedDates;
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
        (widget.value.isNotEmpty && widget.value[0] != null
            ? DateTime(widget.value[0]!.year, widget.value[0]!.month)
            : DateUtils.dateOnly(DateTime.now()));
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
        if (date != null) {
          SemanticsService.announce(
            _localizations.formatFullDate(date),
            _textDirection,
          );
        }
      }
    }
  }

  void _vibrate() {
    if (widget.config.disableVibration == true) return;

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
          if (date != null) {
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
            .where((d) => d?.year == date.year)
            .toList()
          ..sort((d1, d2) => d1!.compareTo(d2!));
        if (selectedDatesInThisYear.isNotEmpty) {
          newDisplayedMonthDate =
              DateTime(date.year, selectedDatesInThisYear[0]!.month);
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
    if (widget.config.autoTransitionToDayView != false) {
      _mode = CalendarDatePicker2Mode.day;
    }
    setState(() {
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

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      var selectedDates = [..._selectedDates];
      selectedDates.removeWhere((d) => d == null);

      final calendarType = widget.config.calendarType;
      switch (calendarType) {
        case CalendarDatePicker2Type.single:
          selectedDates = [value];
          break;

        case CalendarDatePicker2Type.multi:
          final index =
              selectedDates.indexWhere((d) => DateUtils.isSameDay(d, value));
          if (index != -1) {
            selectedDates.removeAt(index);
          } else {
            selectedDates.add(value);
          }
          break;

        case CalendarDatePicker2Type.range:
          if (selectedDates.isEmpty) {
            selectedDates.add(value);
            break;
          }

          final isRangeSet =
              selectedDates.length > 1 && selectedDates[1] != null;
          final isSelectedDayBeforeStartDate =
              value.isBefore(selectedDates[0]!);

          if (isRangeSet) {
            selectedDates = [value, null];
          } else if (isSelectedDayBeforeStartDate &&
              widget.config.rangeBidirectional != true) {
            selectedDates = [value, null];
          } else {
            selectedDates = [selectedDates[0], value];
          }

          break;
      }

      selectedDates
        ..removeWhere((d) => d == null)
        ..sort((d1, d2) => d1!.compareTo(d2!));

      final isValueDifferent =
          widget.config.calendarType != CalendarDatePicker2Type.single ||
              !DateUtils.isSameDay(selectedDates[0],
                  _selectedDates.isNotEmpty ? _selectedDates[0] : null);
      if (isValueDifferent || widget.config.allowSameValueSelection == true) {
        _selectedDates = [...selectedDates];
        widget.onValueChanged
            ?.call(_selectedDates.whereType<DateTime>().toList());
      }
    });
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
      case CalendarDatePicker2Mode.scroll:
        return Container(
          constraints: widget.config.scrollViewConstraints,
          child: _CalendarScrollView(
            config: widget.config,
            key: _dayPickerKey,
            initialMonth: _currentDisplayedMonthDate,
            selectedDates: _selectedDates,
            onChanged: _handleDayChanged,
            onDisplayedMonthChanged: _handleDisplayedMonthDateChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    final dayRowsCount = widget.config.dynamicCalendarRows == true
        ? getDayRowsCount(
            _currentDisplayedMonthDate.year,
            _currentDisplayedMonthDate.month,
            widget.config.firstDayOfWeek ?? _localizations.firstDayOfWeekIndex,
          )
        : _maxDayPickerRowCount;
    final totalRowsCount = dayRowsCount + 1;
    final rowHeight = widget.config.dayMaxWidth != null
        ? (widget.config.dayMaxWidth! + 2)
        : _dayPickerRowHeight;
    final maxContentHeight = rowHeight * totalRowsCount;

    return widget.config.calendarViewMode == CalendarDatePicker2Mode.scroll
        ? _buildPicker()
        : Stack(
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
