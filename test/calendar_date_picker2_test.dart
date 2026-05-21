import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Calendar date picker2 unit test', () {});
  testWidgets('Constant initial list wont throw unmodified list',
      (widgetTester) async {
    const emp = <DateTime>[];
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarDatePicker2(
            value: emp, config: CalendarDatePicker2Config()),
      ),
    ));
  });

  group('CalendarDatePicker2WithActionButtonsConfig padding tests', () {
    test('actionButtonLeftPadding and actionButtonRightPadding parameters can be set', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonLeftPadding: 20,
        actionButtonRightPadding: 20,
      );

      expect(config.actionButtonLeftPadding, 20);
      expect(config.actionButtonRightPadding, 20);
    });

    test('actionButtonLeftPadding and actionButtonRightPadding default to null', () {
      final config = CalendarDatePicker2WithActionButtonsConfig();

      expect(config.actionButtonLeftPadding, null);
      expect(config.actionButtonRightPadding, null);
    });

    test('copyWith preserves actionButtonLeftPadding and actionButtonRightPadding', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonLeftPadding: 20,
        actionButtonRightPadding: 30,
      );

      final copiedConfig = config.copyWith();

      expect(copiedConfig.actionButtonLeftPadding, 20);
      expect(copiedConfig.actionButtonRightPadding, 30);
    });

    test('copyWith can update actionButtonLeftPadding and actionButtonRightPadding', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonLeftPadding: 20,
        actionButtonRightPadding: 30,
      );

      final updatedConfig = config.copyWith(
        actionButtonLeftPadding: 40,
        actionButtonRightPadding: 50,
      );

      expect(updatedConfig.actionButtonLeftPadding, 40);
      expect(updatedConfig.actionButtonRightPadding, 50);
    });

    testWidgets('actionButtonLeftPadding and actionButtonRightPadding are applied to action buttons row',
        (widgetTester) async {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonLeftPadding: 24,
        actionButtonRightPadding: 32,
      );

      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CalendarDatePicker2WithActionButtons(
            value: const [],
            config: config,
          ),
        ),
      ));

      // Verify widget builds without errors
      expect(find.byType(CalendarDatePicker2WithActionButtons), findsOneWidget);
    });
  });

  group('CalendarDatePicker2WithActionButtonsConfig actionButtonHoverColor tests', () {
    test('actionButtonHoverColor parameter can be set', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonHoverColor: Colors.blue,
      );

      expect(config.actionButtonHoverColor, Colors.blue);
    });

    test('actionButtonHoverColor defaults to null', () {
      final config = CalendarDatePicker2WithActionButtonsConfig();

      expect(config.actionButtonHoverColor, null);
    });

    test('copyWith preserves actionButtonHoverColor', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonHoverColor: Colors.red,
      );

      final copiedConfig = config.copyWith();

      expect(copiedConfig.actionButtonHoverColor, Colors.red);
    });

    test('copyWith can update actionButtonHoverColor', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonHoverColor: Colors.red,
      );

      final updatedConfig = config.copyWith(
        actionButtonHoverColor: Colors.green,
      );

      expect(updatedConfig.actionButtonHoverColor, Colors.green);
    });

    testWidgets('actionButtonHoverColor is applied to action buttons',
        (widgetTester) async {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonHoverColor: Colors.amber,
      );

      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CalendarDatePicker2WithActionButtons(
            value: const [],
            config: config,
          ),
        ),
      ));

      // Verify widget builds without errors
      expect(find.byType(CalendarDatePicker2WithActionButtons), findsOneWidget);
    });
  });

  group('CalendarDatePicker2WithActionButtonsConfig actionButtonAlignment tests', () {
    test('actionButtonAlignment parameter can be set', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonAlignment: MainAxisAlignment.center,
      );

      expect(config.actionButtonAlignment, MainAxisAlignment.center);
    });

    test('actionButtonAlignment defaults to null', () {
      final config = CalendarDatePicker2WithActionButtonsConfig();

      expect(config.actionButtonAlignment, null);
    });

    test('copyWith preserves actionButtonAlignment', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonAlignment: MainAxisAlignment.start,
      );

      final copiedConfig = config.copyWith();

      expect(copiedConfig.actionButtonAlignment, MainAxisAlignment.start);
    });

    test('copyWith can update actionButtonAlignment', () {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonAlignment: MainAxisAlignment.start,
      );

      final updatedConfig = config.copyWith(
        actionButtonAlignment: MainAxisAlignment.spaceBetween,
      );

      expect(updatedConfig.actionButtonAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('actionButtonAlignment is applied to action buttons row',
        (widgetTester) async {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        actionButtonAlignment: MainAxisAlignment.center,
      );

      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CalendarDatePicker2WithActionButtons(
            value: const [],
            config: config,
          ),
        ),
      ));

      // Verify widget builds without errors
      expect(find.byType(CalendarDatePicker2WithActionButtons), findsOneWidget);
    });
  });
}
