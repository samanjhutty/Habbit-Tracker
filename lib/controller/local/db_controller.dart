import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_constants.dart';
import 'package:habbit_tracker/model/habit_model.dart';

class DbController extends GetxController {
  addHabit(
      {required RxString title,
      required RxDouble totalTime,
      required RxBool isStart}) {
    habitList.add(HabitModel(
        title: title,
        initialHabbitTime: 0.0.obs,
        totalHabbitTime: totalTime,
        running: isStart));
    box.put(habbitListKey(DateTime.now()), habitList);
  }

  updateHabit(
      {required int index,
      required RxString title,
      required RxDouble initilTime,
      required RxDouble totalTime,
      required RxDouble listDayKey,
      required RxBool isStart}) {
    habitList[index] = HabitModel(
        title: title,
        initialHabbitTime: initilTime,
        totalHabbitTime: totalTime,
        running: isStart);
    box.put(listDayKey, habitList);
  }

  Future myTimePicker({required context}) async {
    var time = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: const TimeOfDay(hour: 1, minute: 0));
    return time;
  }

  static String habbitListKey(DateTime date) {
    String today = '${date.year}${date.month}${date.day}';

    return 'HabbitList-day:$today';
  }

  habitStart({required int index}) {
    DateTime time = DateTime.now();

    var list = habitList[index];
    list.running.value = !list.running.value;

    double? elapsedTime;

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (list.running.value == false ||
          elapsedTime == list.totalHabbitTime.value) {
        print('habit stoped');
        list.running.value = false;
        timer.cancel();
      }
      print('habit running...');
      elapsedTime = DateTime.now().difference(time).inMinutes.toDouble();
      list.initialHabbitTime.value = elapsedTime!;
    });
  }
}
