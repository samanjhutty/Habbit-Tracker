import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';
import 'package:habbit_tracker/controller/local/time_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../model/habit_model.dart';
import '../pages/add_habit.dart';

class HabitTile extends StatefulWidget {
  const HabitTile({super.key, required this.list});

  final List<HabitModel> list;
  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: ((context, index) => widget.list.isEmpty
            ? const Center(
                child: Text("Let's create a new habit."),
              )
            : GetBuilder<DbController>(builder: (db) {
                HabitModel list = widget.list[index];
                double percentCompleted =
                    (widget.list[index].initialHabbitTime +
                            habitList[index].elapsedTime) /
                        widget.list[index].totalHabbitTime;

                double initialTime = list.totalHabbitTime -
                    (list.initialHabbitTime + habitList[index].elapsedTime);

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        minVerticalPadding: 0,
                        leading: Tooltip(
                          message: list.running == true ? 'Pause' : 'Play',
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => db.habitOnTap(index: index),
                            child: Stack(
                              fit: StackFit.passthrough,
                              alignment: Alignment.center,
                              children: [
                                list.running == true
                                    ? const Icon(Icons.pause)
                                    : const Icon(Icons.play_arrow),
                                CircularPercentIndicator(
                                  progressColor: scheme.primary,
                                  backgroundColor: scheme.secondary,
                                  lineWidth: 4,
                                  radius: 24,
                                  percent: percentCompleted <= 1
                                      ? percentCompleted
                                      : 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        title: Text(list.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                        subtitle: GetBuilder<TimeController>(builder: (timedb) {
                          String remainingInitialTime = initialTime > 60
                              ? '${timedb.formatedTime((initialTime / 60).floor(), (initialTime - 60).ceil())} hrs'
                              : '${initialTime.ceil()} min';

                          String totalTime = list.totalHabbitTime > 60
                              ? '${timedb.formatedTime((list.totalHabbitTime / 60).floor(), (list.totalHabbitTime - 60).ceil())} hrs'
                              : '${list.totalHabbitTime.ceil()} min';

                          return Text(
                              'Remaining  $remainingInitialTime / $totalTime',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12));
                        }),
                        trailing: PopupMenuButton(
                          tooltip: 'Settings',
                          position: PopupMenuPosition.under,
                          child: const Icon(Icons.settings),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                onTap: () => Get.to(
                                    () => AddHabit(data: list, index: index)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Edit')
                                  ],
                                )),
                            PopupMenuItem(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          actionsPadding: const EdgeInsets.only(
                                              right: 16, bottom: 16),
                                          title: const Text('Delete Habbit'),
                                          content: const Text(
                                              'Are you sure you want to delete this habbit?'),
                                          actions: [
                                            IconButton.filled(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                onPressed: () =>
                                                    navigator!.pop(),
                                                icon: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: scheme.onPrimary,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            IconButton.outlined(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              onPressed: () {
                                                setState(() {
                                                  habitList.removeAt(index);
                                                });
                                                navigator!.pop();
                                              },
                                              icon: const Text('Delete'),
                                            )
                                          ],
                                        )),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: scheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Delete'),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ));
              })));
  }
}
