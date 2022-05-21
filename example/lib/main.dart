import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

var today = DateUtils.dateOnly(DateTime.now());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalendarDatePicker2 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DateTime?> _customSingleDatePickerValue = [];
  List<DateTime?> _defaultSingleDatePickerValue = [];
  List<DateTime?> _defaultMultiDatePickerValue = [];
  List<DateTime?> _defaultRangeDatePickerValue = [];

  List<DateTime?> _defaultSingleDatePickerValueWithDefaultValue = [
    DateTime(2022, 3, 9)
  ];
  List<DateTime?> _defaultMultiDatePickerValueWithDefaultValue = [
    DateTime(today.year, today.month, 1),
    DateTime(today.year, today.month, 5),
    DateTime(today.year, today.month, 14),
    DateTime(today.year, today.month, 17),
    DateTime(today.year, today.month, 25),
  ];
  List<DateTime?> _defaultRangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    today
  ];
  List<DateTime?> _defaultRangeDatePickerValueWithDefaultValue2 = [
    DateTime(2019, 8, 12),
  ];
  List<DateTime?> _defaultRangeDatePickerValueWithDefaultValue3 = [null, today];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            _buildCustomDatePicker(),
            _buildDefaultSingleDatePickerWithValue(),
            _buildDefaultMultiDatePickerWithValue(),
            _buildDefaultRangeDatePickerWithValue(),
            // _buildDefaultRangeDatePickerWithValue2(),
            // _buildDefaultRangeDatePickerWithValue3(),
            // _buildDefaultSingleDatePicker(),
            // _buildDefaultMultiDatePicker(),
            // _buildDefaultRangeDatePicker(),
          ],
        ),
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(' , ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        var startDate = values[0].toString().replaceAll('00:00:00.000', '');
        var endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  Widget _buildCustomDatePicker() {
    var config = CalendarDatePicker2Config(
      controlsHeight: 48,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      dayTextStyle: const TextStyle(
        color: Color.fromRGBO(0, 0, 0, 0.8),
        fontWeight: FontWeight.w400,
        fontSize: 13,
      ),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      selectedDayHighlightColor: Colors.indigo,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Custom Single Date Picker'),
        CalendarDatePicker2(
          config: config,
          initialValue: _customSingleDatePickerValue,
          onValueChanged: (values) =>
              setState(() => _customSingleDatePickerValue = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _customSingleDatePickerValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultSingleDatePicker() {
    var config = CalendarDatePicker2Config();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Single Date Picker'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultSingleDatePickerValue,
          onValueChanged: (values) =>
              setState(() => _defaultSingleDatePickerValue = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultSingleDatePickerValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultMultiDatePicker() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Multi Date Picker'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultMultiDatePickerValue,
          onValueChanged: (values) =>
              setState(() => _defaultMultiDatePickerValue = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultMultiDatePickerValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultRangeDatePicker() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Range Date Picker'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultRangeDatePickerValue,
          onValueChanged: (values) =>
              setState(() => _defaultRangeDatePickerValue = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultRangeDatePickerValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    var config = CalendarDatePicker2Config();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Single Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultSingleDatePickerValueWithDefaultValue,
          onValueChanged: (values) => setState(
              () => _defaultSingleDatePickerValueWithDefaultValue = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultSingleDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultMultiDatePickerWithValue() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Multi Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultMultiDatePickerValueWithDefaultValue,
          onValueChanged: (values) => setState(
              () => _defaultMultiDatePickerValueWithDefaultValue = values),
        ),
        Wrap(
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultMultiDatePickerValueWithDefaultValue,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultRangeDatePickerWithValue() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultRangeDatePickerValueWithDefaultValue,
          onValueChanged: (values) => setState(
              () => _defaultRangeDatePickerValueWithDefaultValue = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultRangeDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultRangeDatePickerWithValue2() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultRangeDatePickerValueWithDefaultValue2,
          onValueChanged: (values) => setState(
              () => _defaultRangeDatePickerValueWithDefaultValue2 = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultRangeDatePickerValueWithDefaultValue2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDefaultRangeDatePickerWithValue3() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Default Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _defaultRangeDatePickerValueWithDefaultValue3,
          onValueChanged: (values) => setState(
              () => _defaultRangeDatePickerValueWithDefaultValue3 = values),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _defaultRangeDatePickerValueWithDefaultValue3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
