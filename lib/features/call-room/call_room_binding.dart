import 'package:get/get.dart';
import 'package:mini_chat/features/call-room/call_room_controller.dart';

class CallRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallRoomController());
  }
}
