import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/home/home_binding.dart';
import 'package:mini_chat/features/home/home_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

  ];
}
