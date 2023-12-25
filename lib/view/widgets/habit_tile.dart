import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../model/habit_model.dart';

class HabitTile extends StatefulWidget {
  const HabitTile({super.key, required this.list});

  final List<HabitModel> list;
  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  DbController db = Get.find();

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: ((context, index) => Obx(() {
              HabitModel list = widget.list[index];

              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      minVerticalPadding: 0,
                      leading: Tooltip(
                        message: list.running.value == true ? 'Pause' : 'Play',
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            db.habitStart(index: index);
                          },
                          child: Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.center,
                            children: [
                              list.running.value == true
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                              CircularPercentIndicator(
                                progressColor: scheme.primary,
                                backgroundColor: scheme.secondary,
                                lineWidth: 4,
                                radius: 24,
                                percent: list.initialHabbitTime.value /
                                    list.totalHabbitTime.value,
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Text(list.title.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20)),
                      subtitle: Text(
                          'Remaining ${(list.totalHabbitTime.value - list.initialHabbitTime.value).ceil()} / ${list.totalHabbitTime.value.ceil()} min',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      trailing: PopupMenuButton(
                        tooltip: 'Settings',
                        position: PopupMenuPosition.under,
                        child: const Icon(Icons.settings),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {},
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
                                              onPressed: () => navigator!.pop(),
                                              icon: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: scheme.onPrimary,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                          IconButton.outlined(
                                            padding: const EdgeInsets.symmetric(
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
