import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  TimeOfDay? time = const TimeOfDay(hour: 1, minute: 0);

  DbController db = Get.find();
  RxBool isStarted = false.obs;

  formatedTime(TimeOfDay time) {
    String hrs =
        time.hour.isLowerThan(10) ? '0${time.hour}' : time.hour.toString();
    String min = time.minute.isLowerThan(10)
        ? '0${time.minute}'
        : time.minute.toString();
    return '$hrs:$min';
  }

  @override
  void initState() {
    timeController.text = formatedTime(time!);
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
                                      timeController.text = formatedTime(time!);
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
                            Obx(
                              () => Switch.adaptive(
                                  activeColor: scheme.primary,
                                  value: isStarted.value,
                                  onChanged: (value) {
                                    isStarted.value = value;
                                  }),
                            ),
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
                                    db.addHabit(
                                        title: nameController.text.obs,
                                        totalTime: 60.0.obs,
                                        isStart: isStarted);
                                    Get.back();
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
