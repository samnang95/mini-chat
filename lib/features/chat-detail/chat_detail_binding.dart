import 'package:get/get.dart';
import 'package:mini_chat/features/chat-detail/chat_detail_controller.dart';

class ChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatDetailController());
  }
}