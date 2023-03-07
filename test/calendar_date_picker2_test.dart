import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Calendar date picker2 unit test', () {});
  testWidgets('Empty initial list wont throw unmodified list',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarDatePicker2(
            initialValue: const [], config: CalendarDatePicker2Config()),
      ),
    ));
  });
}
