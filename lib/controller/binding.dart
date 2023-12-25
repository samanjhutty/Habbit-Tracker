import 'package:get/get.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DbController());
  }
}
