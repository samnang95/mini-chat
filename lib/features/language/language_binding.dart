import 'package:get/get.dart';
import 'package:mini_chat/features/language/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageController());  
  }
}