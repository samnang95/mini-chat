import 'package:get/get.dart';
import 'package:mini_chat/features/start-page/start_controller.dart';

class StartBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => StartController());
  }
}