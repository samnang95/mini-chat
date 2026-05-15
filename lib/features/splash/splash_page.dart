import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_chat/core/constants/app_animations.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/features/splash/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLighter,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Column(
              children: [
                Lottie.asset(AppAnimations.boxMessage,repeat: true),
                SizedBox(height: 4),
                XGradientText(
                  LocaleKeys.appName.tr(),
                  colors: [AppColors.primary, AppColors.accent],
                  style: AppTypography.heading1,
                ),
                Text(
                  LocaleKeys.splashTagline.tr(),
                  style: AppTypography.bodyLarge,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 10,
                  width: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightest,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AnimatedBuilder(
                    animation: controller.animation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 250 * controller.animation.value,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  LocaleKeys.splashInstalling.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.splashProductOf.tr(),
                      style: AppTypography.bodyLarge,
                    ),
                    SizedBox(width: 4),
                    Text(
                      LocaleKeys.splashStudioClarity.tr(),
                      style: TextStyle(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
