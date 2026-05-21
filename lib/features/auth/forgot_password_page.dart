import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_dimens.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_button.dart';
import 'package:mini_chat/core/widgets/x_text_field.dart';
import 'package:mini_chat/features/auth/auth_controller.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spacing24),
        child: Form(
          key: controller.forgotPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: Get.height * 0.02),
            Text(
              'Forgot Password',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: AppDimens.spacing8),
            Text(
              'Enter your email address to receive a password reset link.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: Get.height * 0.05),
            Text(
              StringTranslateExtension(LocaleKeys.authEmail).tr(),
              style: AppTypography.subtitle2,
            ),
            const SizedBox(height: AppDimens.spacing8),
            XTextField(
              controller: controller.forgotPasswordEmailController,
              hintText: StringTranslateExtension(LocaleKeys.authEmailHint).tr(),
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              prefixIcon: Icon(
                Icons.email_outlined,
                size: AppDimens.iconMedium,
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
              ),
            ),
            SizedBox(height: Get.height * 0.05),
            Obx(
              () => XButton(
                label: 'Send Reset Link',
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (!controller.forgotPasswordFormKey.currentState!.validate()) {
                          return;
                        }
                        final email = controller.forgotPasswordEmailController.text.trim();
                        controller.isLoading.value = true;
                        await controller.forgotPassword(email);
                        controller.isLoading.value = false;
                        Get.back();
                      },
                isLoading: controller.isLoading.value,
              ),
            ),
          ],
        ),
      )
    ),
    );
  }
}
