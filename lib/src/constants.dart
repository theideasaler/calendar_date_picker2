class C2Constants {
  C2Constants._(); // Private constructor

  static const double dayPickerRowHeight = 42.0;
  static const double subHeaderHeight = 52.0;
  // A 31 day month that starts on Saturday.
  static const int maxDayPickerRowCount = 6;
  static const double maxDayPickerHeight =
      dayPickerRowHeight * (maxDayPickerRowCount + 1);

  static const double monthPickerHorizontalPadding = 8.0;
  static const double monthNavButtonsWidth = 108.0;
  static const Duration monthScrollDuration = Duration(milliseconds: 200);

  static const int yearPickerColumnCount = 3;
  static const double yearPickerPadding = 16.0;
  static const double yearPickerRowHeight = 52.0;
  static const double yearPickerRowSpacing = 8.0;
}
