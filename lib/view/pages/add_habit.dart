import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';
import 'package:habbit_tracker/controller/local/time_controller.dart';

import '../../model/habit_model.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key, this.data, this.index});

  final HabitModel? data;
  final int? index;

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  TimeOfDay? time = const TimeOfDay(hour: 1, minute: 0);

  DbController db = Get.find();
  TimeController timedb = Get.find();
  bool isStarted = false;

  @override
  void initState() {
    if (widget.data != null && widget.index != null) {
      var totalTime = widget.data!.totalHabbitTime;

      nameController.text = widget.data!.title;
      time = timedb.doubleToTimeOfDay(totalTime);
      isStarted = widget.data!.running;
    }
    timeController.text = timedb.formatedDateTimeObj(time!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    bool isMobile = MediaQuery.of(context).orientation == Orientation.portrait;

    double myWidth = isMobile ? 350 : 460;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              child: SizedBox(
                width: myWidth,
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New Habit',
                        style: TextStyle(
                            color: scheme.primaryContainer, fontSize: 36),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                          'First we make a habit, then our habit makes us...'),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]+'))
                        ],
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: scheme.inversePrimary)),
                            border: const OutlineInputBorder(),
                            label: const Text('Habit name')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Duration ',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 120,
                                child: TextFormField(
                                  controller: timeController,
                                  onTap: () async {
                                    time =
                                        await db.myTimePicker(context: context);
                                    if (time == null) return;
                                    setState(() {
                                      timeController.text =
                                          timedb.formatedDateTimeObj(time!);
                                    });
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: scheme.inversePrimary)),
                                      border: const OutlineInputBorder(),
                                      label: const Text('Tap to set')),
                                ),
                              ),
                              const SizedBox()
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Start now',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch.adaptive(
                                activeColor: scheme.primary,
                                value: isStarted,
                                onChanged: (value) {
                                  setState(() {
                                    isStarted = value;
                                  });
                                }),
                            const SizedBox()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    widget.data == null || widget.index == null
                                        ? db.newHabit(
                                            title: nameController.text,
                                            totalTime:
                                                timedb.timeOfDayToDouble(time!),
                                            isStart: isStarted)
                                        : db.updateHabit(
                                            index: widget.index!,
                                            title: nameController.text,
                                            elapsedTime:
                                                widget.data!.elapsedTime,
                                            initilTime:
                                                widget.data!.initialHabbitTime,
                                            totalTime: time != null
                                                ? timedb
                                                    .timeOfDayToDouble(time!)
                                                : widget.data!.totalHabbitTime,
                                            listDayKey:
                                                DbController.habbitListKey(
                                                    DateTime.now()),
                                            isStart: isStarted);
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: scheme.primaryContainer,
                                  foregroundColor: scheme.onPrimaryContainer,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                                child: const Text('Save')),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () => navigator!.pop(),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
    );
  }
}
