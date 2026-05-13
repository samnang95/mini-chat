import 'package:get/get.dart';
import 'package:mini_chat/features/call/call_controller.dart';
import 'package:mini_chat/features/chat/chat_controller.dart';
import 'package:mini_chat/features/contact/contact_controller.dart';
import 'package:mini_chat/features/main/main_controller.dart';
import 'package:mini_chat/features/settings/settings_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut(() => CallController());
    Get.lazyPut(() => SettingsController());
  }
}