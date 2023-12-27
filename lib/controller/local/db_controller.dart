// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_constants.dart';
import 'package:habbit_tracker/model/habit_model.dart';

class DbController extends GetxController {
  newHabit(
      {required String title,
      required double totalTime,
      required bool isStart}) {
    habitList.add(HabitModel(
        title: title,
        initialHabbitTime: 0.0,
        elapsedTime: 0.0,
        totalHabbitTime: totalTime,
        running: isStart,
        completed: false));
    box.put(habbitListKey(DateTime.now()), habitList);
    update();
  }

  updateHabit(
      {required int index,
      required String title,
      required double initilTime,
      required double elapsedTime,
      required double totalTime,
      required String listDayKey,
      required bool isStart}) {
    habitList[index] = HabitModel(
        title: title,
        initialHabbitTime: initilTime,
        elapsedTime: elapsedTime,
        totalHabbitTime: totalTime,
        running: isStart,
        completed: initilTime == totalTime ? true : false);
    box.put(listDayKey, habitList);
    update();
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

  habitOnTap({required int index}) async {
    double totalTime = habitList[index].totalHabbitTime;

    habitList[index].running = !habitList[index].running;
    update();

    if (habitList[index].initialHabbitTime + habitList[index].elapsedTime >=
        totalTime) {
      habitList[index].running = false;
      update();
      showDialog(
          context: navigator!.context,
          builder: (context) => AlertDialog(
                title: const Text('Reset Habit'),
                content: const Text(
                    "You've alrealy completed this habit, would you like to reset it?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        habitList[index].initialHabbitTime = 0;
                        habitList[index].elapsedTime = 0;
                        update();

                        navigator!.pop();
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        navigator!.pop();
                      },
                      child: const Text('No'))
                ],
              ));
    }

    DateTime time = DateTime.now();
    if (habitList[index].running) {
      habitList[index].elapsedTime += habitList[index].initialHabbitTime;
      print('time outside: ${habitList[index].elapsedTime.toStringAsFixed(2)}');

      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        habitList[index].initialHabbitTime = habitList[index].initialHabbitTime;

        if (habitList[index].running == false ||
            habitList[index].initialHabbitTime + habitList[index].elapsedTime >=
                totalTime) {
          print(
              'time running: ${habitList[index].elapsedTime.toStringAsFixed(2)}');
          if (habitList[index].initialHabbitTime +
                  habitList[index].elapsedTime >=
              totalTime) {
            // show notification
            Get.rawSnackbar(message: 'Habbit completed');
          }
          habitList[index].running = false;
          update();
          timer.cancel();

          // box.put(habbitListKey(DateTime.now()), habitList);
        } else {
          habitList[index].completed = true;
          var time2 = DateTime.now();

          habitList[index].initialHabbitTime =
              ((time2.difference(time).inSeconds) / 60).toDouble();
          update();
          print(
              'total time ${habitList[index].title}: ${habitList[index].initialHabbitTime.toStringAsFixed(2)}');
        }
      });
    }
  }
}
