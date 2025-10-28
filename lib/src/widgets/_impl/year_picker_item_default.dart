import 'package:flutter/material.dart';

class YearPickerItemDefault extends StatelessWidget {
  final int year;

  final bool isSelected;

  final TextStyle? textStyle;

  final BoxDecoration? decoration;
  final double decorationHeight;
  final double decorationWidth;

  const YearPickerItemDefault(
    this.year, {
    required this.textStyle,
    required this.decoration,
    required this.decorationHeight,
    this.decorationWidth = 72.0,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: decoration,
        height: decorationHeight,
        width: decorationWidth,
        child: Center(
          child: Semantics(
            selected: isSelected,
            button: true,
            child: Text(year.toString(), style: textStyle),
          ),
        ),
      ),
    );
  }
}
