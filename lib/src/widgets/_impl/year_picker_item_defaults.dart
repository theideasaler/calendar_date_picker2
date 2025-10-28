import 'package:calendar_date_picker2/src/models/calendar_date_picker2_config.dart';
import 'package:flutter/material.dart';

// ignore: body_might_complete_normally_nullable
BoxDecoration? yearPickerDecoration(
  CalendarDatePicker2Config config,
  ColorScheme colorScheme,
  double decorationHeight, {
  required bool isSelected,
  required bool isCurrentYear,
  required bool isDisabled,
  required bool isFocused,
  required Color? borderFocusColor,
}) {
  final focusColor = borderFocusColor ?? colorScheme.secondary;
  final highlightColor =
      config.selectedDayHighlightColor ?? colorScheme.primary;

  final borderRadius =
      config.yearBorderRadius ?? BorderRadius.circular(decorationHeight / 2);

  if (isSelected) {
    return BoxDecoration(
      color: highlightColor,
      border: Border.all(color: isFocused ? focusColor : Colors.transparent),
      borderRadius: borderRadius,
    );
  } else if (isCurrentYear && !isDisabled) {
    return BoxDecoration(
      border: Border.all(color: isFocused ? focusColor : highlightColor),
      borderRadius: borderRadius,
    );
  } else if (isFocused) {
    return BoxDecoration(
      border: Border.all(color: focusColor),
      borderRadius: borderRadius,
    );
  }
}

TextStyle? yearPickerTextStyle(
  CalendarDatePicker2Config config,
  TextTheme textTheme,
  ColorScheme colorScheme,
  bool isSelected,
  bool isCurrentYear,
  bool isDisabled,
) {
  final Color textColor;
  if (isSelected) {
    textColor = colorScheme.onPrimary;
  } else if (isDisabled) {
    textColor = colorScheme.onSurface.withValues(alpha: 0.38);
  } else if (isCurrentYear) {
    textColor = config.selectedDayHighlightColor ?? colorScheme.primary;
  } else {
    textColor = colorScheme.onSurface.withValues(alpha: 0.87);
  }

  // text style
  TextStyle? itemStyle =
      config.yearTextStyle ?? textTheme.bodyLarge?.apply(color: textColor);
  if (isDisabled) {
    itemStyle = config.disabledYearTextStyle ?? itemStyle;
  }
  if (isSelected) {
    itemStyle = config.selectedYearTextStyle ?? itemStyle;
  }
  return itemStyle;
}
