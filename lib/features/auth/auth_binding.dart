import 'package:get/get.dart';
import 'package:mini_chat/features/auth/auth_controller.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}