import 'dart:core';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;

class BoxConstants {
  static const boxName = 'Habit-Tracker';
  static const startDateKey = 'APP-START-DATE';

  // For each individual habit
  static const habitTitleKey = 'Habit-Title';
  static const habitElapsedTimeKey = 'Habit-Emapsed-Time';
  static const habitInitialTimekey = 'Habit-Initial-Time';
  static const habitTotalTimeKey = 'Habit-Total-Time';
  static const habitRunningKey = 'Habit-Running';
}
