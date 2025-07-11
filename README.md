# calendar_date_picker2_fixed

A patched version of the original [calendar_date_picker2](https://pub.dev/packages/calendar_date_picker2), replacing the broken `Color.withValues()` with `withOpacity()` for Dart 3.0 compatibility.

## Why this package?

The original package uses a non-existent method (`Color.withValues`) which causes build failures. This version fixes that and is published for easy use.

## Usage

```dart
import 'package:calendar_date_picker2_fixed/calendar_date_picker2_fixed.dart';
