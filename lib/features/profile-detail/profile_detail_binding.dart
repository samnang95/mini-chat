import 'package:get/get.dart';
import 'package:mini_chat/features/profile-detail/profile_detail_controller.dart';

class ProfileDetailBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => ProfileDetailController());
  }
}