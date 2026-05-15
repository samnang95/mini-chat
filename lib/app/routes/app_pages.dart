import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/auth/auth_binding.dart';
import 'package:mini_chat/features/auth/login_page.dart';
import 'package:mini_chat/features/auth/register_page.dart';
import 'package:mini_chat/features/call/call_binding.dart';
import 'package:mini_chat/features/call/call_page.dart';
import 'package:mini_chat/features/chat-detail/chat_detail_binding.dart';
import 'package:mini_chat/features/chat-detail/chat_detail_page.dart';
import 'package:mini_chat/features/chat/chat_binding.dart';
import 'package:mini_chat/features/chat/chat_page.dart';
import 'package:mini_chat/features/contact/contact_binding.dart';
import 'package:mini_chat/features/contact/contact_page.dart';
import 'package:mini_chat/features/home/home_binding.dart';
import 'package:mini_chat/features/home/home_page.dart';
import 'package:mini_chat/features/language/language_binding.dart';
import 'package:mini_chat/features/language/language_page.dart';
import 'package:mini_chat/features/main/main_binding.dart';
import 'package:mini_chat/features/main/main_page.dart';
import 'package:mini_chat/features/profile-detail/profile_detail_binding.dart';
import 'package:mini_chat/features/profile-detail/profile_detail_page.dart';
import 'package:mini_chat/features/settings/settings_binding.dart';
import 'package:mini_chat/features/settings/settings_page.dart';
import 'package:mini_chat/features/splash/splash_binding.dart';
import 'package:mini_chat/features/splash/splash_page.dart';
import 'package:mini_chat/features/start-page/start_binding.dart';
import 'package:mini_chat/features/start-page/start_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.startPage,
      page: () => const StartPage(),
      binding: StartBinding(),
    ),
    GetPage(
      name: AppRoutes.loginPage,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.registerPage,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.settingsPage,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.languagePage,
      page: () => const LanguagePage(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: AppRoutes.mainPage,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.chatPage,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.contactPage,
      page: () => const ContactPage(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.callPage,
      page: () => const CallPage(),
      binding: CallBinding(),
    ),
    GetPage(
      name: AppRoutes.chatDetailPage,
      page: () => const ChatDetailPage(),
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.profileDetailPage,
      page: () => const ProfileDetailPage(),
      binding: ProfileDetailBinding(),
    ),
  ];
}
