import 'package:calendar_date_picker2/src/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class C2YearPickerGridView extends StatelessWidget {
  const C2YearPickerGridView({
    Key? key,
    required this.controller,
    required this.dragStartBehavior,
    required this.itemBuilder,
    required this.itemCount,
  }) : super(key: key);

  final ScrollController controller;
  final DragStartBehavior dragStartBehavior;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      gridDelegate: _yearPickerGridDelegate,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(
        horizontal: C2Constants.yearPickerPadding,
      ),
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  const _YearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (C2Constants.yearPickerColumnCount - 1) *
                C2Constants.yearPickerRowSpacing) /
        C2Constants.yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: C2Constants.yearPickerRowHeight,
      crossAxisCount: C2Constants.yearPickerColumnCount,
      crossAxisStride: tileWidth + C2Constants.yearPickerRowSpacing,
      mainAxisStride: C2Constants.yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}

const _YearPickerGridDelegate _yearPickerGridDelegate =
    _YearPickerGridDelegate();
