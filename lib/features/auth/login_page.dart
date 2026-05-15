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

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacing24,
        ),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.1),
      
              // ── Back Button ──────────────────────────────
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.background,
                    borderRadius: AppDimens.borderRadiusMedium,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: AppDimens.iconSmall,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
      
              SizedBox(height: Get.height * 0.04),
      
              // ── Header ───────────────────────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authLoginTitle).tr(),
                style: AppTypography.heading1,
              ),
              SizedBox(height: Get.height * 0.01),
              Text(
                StringTranslateExtension(LocaleKeys.authLoginSubtitle).tr(),
                style: AppTypography.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
      
              SizedBox(height: Get.height * 0.05),
      
              // ── Email Field ──────────────────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authEmail).tr(),
                style: AppTypography.subtitle2,
              ),
              const SizedBox(height: AppDimens.spacing8),
              XTextField(
                controller: controller.loginEmailController,
                hintText: StringTranslateExtension(LocaleKeys.authEmailHint).tr(),
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: AppDimens.iconMedium,
                  color:
                      isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                ),
              ),
      
              SizedBox(height: Get.height * 0.025),
      
              // ── Password Field ───────────────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authPassword).tr(),
                style: AppTypography.subtitle2,
              ),
              const SizedBox(height: AppDimens.spacing8),
              Obx(
                () => XTextField(
                  controller: controller.loginPasswordController,
                  hintText: StringTranslateExtension(LocaleKeys.authPasswordHint).tr(),
                  obscureText: !controller.isLoginPasswordVisible.value,
                  validator: controller.validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    size: AppDimens.iconMedium,
                    color:
                        isDark
                            ? AppColors.darkTextHint
                            : AppColors.textHint,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: controller.toggleLoginPasswordVisibility,
                    child: Icon(
                      controller.isLoginPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: AppDimens.iconMedium,
                      color:
                          isDark
                              ? AppColors.darkTextHint
                              : AppColors.textHint,
                    ),
                  ),
                ),
              ),
      
              // ── Forgot Password ─────────────────────────
              const SizedBox(height: AppDimens.spacing12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to forgot password
                  },
                  child: Text(
                    StringTranslateExtension(LocaleKeys.authForgotPassword).tr(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      
              SizedBox(height: Get.height * 0.05),
      
              // ── Sign In Button ───────────────────────────
              Obx(
                () => XButton(
                  label: StringTranslateExtension(LocaleKeys.authSignIn).tr(),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  isLoading: controller.isLoading.value,
                ),
              ),
      
              SizedBox(height: Get.height * 0.03),
      
              // ── Divider ──────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.darkDivider : AppColors.divider,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacing16,
                    ),
                    child: Text(
                      StringTranslateExtension(LocaleKeys.authOrContinueWith).tr(),
                      style: AppTypography.caption.copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.darkDivider : AppColors.divider,
                    ),
                  ),
                ],
              ),
      
              SizedBox(height: Get.height * 0.03),
      
              // ── Social Login Buttons ─────────────────────
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Google',
                      onTap: () {
                        // TODO: Google sign in
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacing16),
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.apple_rounded,
                      label: 'Apple',
                      onTap: () {
                        // TODO: Apple sign in
                      },
                    ),
                  ),
                ],
              ),
      
              SizedBox(height: Get.height * 0.05),
      
              // ── Register Link ────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringTranslateExtension(LocaleKeys.authDontHaveAccount).tr(),
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacing4),
                  GestureDetector(
                    onTap: controller.goToRegister,
                    child: Text(
                      StringTranslateExtension(LocaleKeys.authSignUp).tr(),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
      
              SizedBox(height: Get.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social Login Button Widget ────────────────────────────
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.buttonHeight,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.background,
          borderRadius: AppDimens.borderRadiusMedium,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDimens.iconMedium,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            const SizedBox(width: AppDimens.spacing8),
            Text(
              label,
              style: AppTypography.button.copyWith(
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}