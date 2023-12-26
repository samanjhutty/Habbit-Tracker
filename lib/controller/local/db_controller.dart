// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_constants.dart';
import 'package:habbit_tracker/model/habit_model.dart';

class DbController extends GetxController {
  double elapsedTime = 0.0;
  newHabit(
      {required RxString title,
      required RxDouble totalTime,
      required RxBool isStart}) {
    habitList.add(HabitModel(
        title: title,
        initialHabbitTime: 0.0.obs,
        totalHabbitTime: totalTime,
        running: isStart,
        completed: false.obs));
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
        running: isStart,
        completed: initilTime == totalTime ? true.obs : false.obs);
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

  String formatedDateTimeObj(TimeOfDay time) {
    String hrs =
        time.hour.isLowerThan(10) ? '0${time.hour}' : time.hour.toString();
    String min = time.minute.isLowerThan(10)
        ? '0${time.minute}'
        : time.minute.toString();
    return '$hrs:$min';
  }

  String formatedTime(int hour, int minute) {
    String newMin = minute.isLowerThan(10) ? '0$minute' : minute.toString();
    return '$hour : $newMin';
  }

  habitOnTap({required int index}) async {
    HabitModel list = habitList[index];
    double totalTime = list.totalHabbitTime.value;

    list.running.value = !list.running.value;

    if (list.initialHabbitTime.value + elapsedTime == totalTime) {
      showDialog(
          context: navigator!.context,
          builder: (context) => AlertDialog(
                title: const Text('Reset Habit'),
                content: const Text(
                    "You've alrealy completed this habit, would you like to reset it?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        list.initialHabbitTime.value = 0;
                        elapsedTime = 0;
                        navigator!.pop();
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        navigator!.pop();
                        list.running.value = false;
                      },
                      child: const Text('No'))
                ],
              ));
    }

    DateTime time = DateTime.now();
    if (list.running.value) {
      elapsedTime += list.initialHabbitTime.value;
      print('time outside: ${elapsedTime.toStringAsFixed(2)}');

      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        list.initialHabbitTime.value = list.initialHabbitTime.value;

        if (list.running.value == false ||
            list.initialHabbitTime.value + elapsedTime >= totalTime) {
          timer.cancel();
          list.running.value = false;
          print('time running: ${elapsedTime.toStringAsFixed(2)}');
          if (list.initialHabbitTime.value + elapsedTime >= totalTime) {
            timer.cancel();

            // show notification
            Get.rawSnackbar(message: 'Habbit completed');
            list.running.value = false;
          }

          // box.put(habbitListKey(DateTime.now()), habitList);
        } else {
          habitList[index].completed = true.obs;
          var time2 = DateTime.now();
          list.initialHabbitTime.value =
              ((time2.difference(time).inSeconds) / 60).toDouble();
          print(
              'total time: ${list.initialHabbitTime.value.toStringAsFixed(2)}');
        }
      });
    }
  }
}
