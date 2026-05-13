import 'package:get/get.dart';
import 'package:mini_chat/features/call/call_controller.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallController());
  }
}