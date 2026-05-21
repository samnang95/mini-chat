import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/auth/auth_binding.dart';
import 'package:mini_chat/features/auth/login_page.dart';
import 'package:mini_chat/features/auth/register_page.dart';
import 'package:mini_chat/features/auth/forgot_password_page.dart';
import 'package:mini_chat/features/call/call_binding.dart';
import 'package:mini_chat/features/call/call_page.dart';
import 'package:mini_chat/features/call-room/call_room_binding.dart';
import 'package:mini_chat/features/call-room/call_room_page.dart';
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
import 'package:mini_chat/features/profile-detail/profile_detail_friend_page.dart';
import 'package:mini_chat/features/settings/settings_binding.dart';
import 'package:mini_chat/features/settings/settings_page.dart';
import 'package:mini_chat/features/settings/blocked_users_page.dart';
import 'package:mini_chat/features/settings/change_password_page.dart';
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
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.loginPage,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.registerPage,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.settingsPage,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.languagePage,
      page: () => const LanguagePage(),
      binding: LanguageBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.mainPage,
      page: () => const MainPage(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.chatPage,
      page: () => const ChatPage(),
      binding: ChatBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.contactPage,
      page: () => const ContactPage(),
      binding: ContactBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.callPage,
      page: () => const CallPage(),
      binding: CallBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.chatDetailPage,
      page: () => const ChatDetailPage(),
      binding: ChatDetailBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.profileDetailPage,
      page: () => const ProfileDetailPage(),
      binding: ProfileDetailBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.profileDetailFriendPage,
      page: () => const ProfileDetailFriendPage(),
      binding: ProfileDetailBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.blockedUsersPage,
      page: () => const BlockedUsersPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.callRoomPage,
      page: () => const CallRoomPage(),
      binding: CallRoomBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.changePasswordPage,
      page: () => const ChangePasswordPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordPage,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
