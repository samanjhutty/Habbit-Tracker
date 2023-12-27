import 'package:hive/hive.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel {
  HabitModel(
      {required this.title,
      required this.initialHabbitTime,
      required this.elapsedTime,
      required this.totalHabbitTime,
      required this.running,
      required this.completed});

  @HiveField(0)
  String title;

  @HiveField(1)
  bool running;

  @HiveField(2)
  double initialHabbitTime;

  @HiveField(3)
  double elapsedTime;

  @HiveField(4)
  double totalHabbitTime;

  @HiveField(5)
  bool completed;
}

List<HabitModel> habitList = [
  HabitModel(
      title: 'Exercise',
      initialHabbitTime: 0.0,
      elapsedTime: 0.0,
      totalHabbitTime: 61.0,
      running: false,
      completed: false),
  HabitModel(
      title: 'Test',
      initialHabbitTime: 0.0,
      elapsedTime: 0.0,
      totalHabbitTime: 1.0,
      running: false,
      completed: false),
];
