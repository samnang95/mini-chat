import 'package:get/get.dart';
import 'package:mini_chat/features/main/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}