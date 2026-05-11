import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/home/home_binding.dart';
import 'package:mini_chat/features/home/home_page.dart';
import 'package:mini_chat/features/language/language_binding.dart';
import 'package:mini_chat/features/language/language_page.dart';
import 'package:mini_chat/features/settings/settings_binding.dart';
import 'package:mini_chat/features/settings/settings_page.dart';
import 'package:mini_chat/features/splash/splash_binding.dart';
import 'package:mini_chat/features/splash/splash_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguagePage(),
      binding: LanguageBinding(),
    ),
  ];
}
