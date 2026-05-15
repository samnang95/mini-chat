import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_chat/core/constants/app_animations.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_button.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/start-page/start_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';

class StartPage extends GetView<StartController> {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Lottie.asset(
                  AppAnimations.letChat,
                  repeat: true,
                  reverse: false,
                  height: Get.height * 0.4,
                ),
                Text(
                  StringTranslateExtension(LocaleKeys.startPageTitle).tr(),
                  style: AppTypography.heading1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.height * 0.02,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    StringTranslateExtension(LocaleKeys.startPageSubtitle).tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  XButton(
                    label: StringTranslateExtension(
                      LocaleKeys.startPageSignIn,
                    ).tr(),
                    onPressed: () => Get.toNamed(AppRoutes.loginPage),
                  ),
                  SizedBox(height: Get.height * 0.015),
                  XButton(
                    label: StringTranslateExtension(
                      LocaleKeys.startPageGetStarted,
                    ).tr(),
                    type: XButtonType.secondary,
                    onPressed: () => Get.toNamed(AppRoutes.registerPage),
                    backgroundColor: AppColors.primaryLighter,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
          ],
        ),
      ),
    );
  }
}
