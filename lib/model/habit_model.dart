import 'package:get/get.dart';
import 'package:hive/hive.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel {
  HabitModel({
    required this.title,
    required this.initialHabbitTime,
    required this.totalHabbitTime,
    required this.running,
  });

  @HiveField(0)
  final RxString title;

  @HiveField(1)
  RxBool running;

  @HiveField(2)
  final RxDouble totalHabbitTime;

  @HiveField(3)
  final RxDouble initialHabbitTime;
}

List<HabitModel> habitList = [
  HabitModel(
    title: 'Study'.obs,
    initialHabbitTime: 0.0.obs,
    totalHabbitTime: 5.0.obs,
    running: false.obs,
  ),
  HabitModel(
    title: 'Exercise'.obs,
    initialHabbitTime: 0.0.obs,
    totalHabbitTime: 10.0.obs,
    running: false.obs,
  ),
  HabitModel(
    title: 'Test'.obs,
    initialHabbitTime: 0.0.obs,
    totalHabbitTime: 2.0.obs,
    running: false.obs,
  ),
];
