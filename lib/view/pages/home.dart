import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_constants.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';
import 'package:habbit_tracker/model/habit_model.dart';
import 'package:habbit_tracker/view/widgets/habit_tile.dart';

class MyHomeTab extends StatefulWidget {
  const MyHomeTab({super.key});

  final String title = 'Keep focus in check';
  final String subtitle = 'Keep track of your habbit everyday';
  @override
  State<MyHomeTab> createState() => _MyHomeTabState();
}

class _MyHomeTabState extends State<MyHomeTab> {
  List<HabitModel> list = <HabitModel>[];

  @override
  void initState() {
    _getList();
    super.initState();
  }

  _getList() async {
    list = await box.get(DbController.habbitListKey(DateTime.now()),
        defaultValue: habitList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    Size device = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).orientation == Orientation.portrait;

    double graphHeight = device.height * 0.4;

    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Scaffold(
            appBar: AppBar(
              bottom: isMobile
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(graphHeight),
                      child: Container(
                        height: graphHeight,
                        color: scheme.secondaryContainer,
                      ),
                    )
                  : null,
              toolbarHeight: 80,
              title: ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: Text(widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 22)),
                subtitle: Text(widget.subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
            body: Stack(
              children: [
                list.isEmpty
                    ? const Center(
                        child: Text(
                          "No habbit maintained, let's build a new one!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : isMobile || device.width < 650
                        ? HabitTile(list: list)
                        : Row(
                            children: [
                              SizedBox(
                                  width: 450, child: HabitTile(list: list)),
                              Expanded(
                                child: Container(
                                  color: scheme.secondaryContainer,
                                ),
                              )
                            ],
                          ),
                Container(
                  padding: const EdgeInsets.only(bottom: 12, right: 12),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () => Get.toNamed('/add-habit'),
                    tooltip: 'Create a Habbit',
                    child: const Icon(Icons.add_task_rounded),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
