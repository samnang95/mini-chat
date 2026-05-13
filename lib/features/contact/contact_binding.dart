import 'package:get/get.dart';
import 'package:mini_chat/features/contact/contact_controller.dart';

class ContactBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
  }
} 