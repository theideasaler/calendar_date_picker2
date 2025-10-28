import 'package:calendar_date_picker2/src/models/calendar_date_picker2_config.dart';

extension CalendarDatePicker2ConfigExt on CalendarDatePicker2Config {
  /// The total number of years in the picker.
  int get totalYears => lastDate.year - firstDate.year + 1;
}
