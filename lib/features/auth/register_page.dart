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

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacing24,
        ),
        child: Form(
          key: controller.registerFormKey,
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
                StringTranslateExtension(LocaleKeys.authRegisterTitle).tr(),
                style: AppTypography.heading1,
              ),
              SizedBox(height: Get.height * 0.01),
              Text(
                StringTranslateExtension(LocaleKeys.authRegisterSubtitle).tr(),
                style: AppTypography.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
      
              SizedBox(height: Get.height * 0.04),
      
              // ── Full Name Field ──────────────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authFullName).tr(),
                style: AppTypography.subtitle2,
              ),
              const SizedBox(height: AppDimens.spacing8),
              XTextField(
                controller: controller.registerNameController,
                hintText: StringTranslateExtension(LocaleKeys.authFullNameHint).tr(),
                keyboardType: TextInputType.name,
                validator: controller.validateName,
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  size: AppDimens.iconMedium,
                  color:
                      isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                ),
              ),
      
              SizedBox(height: Get.height * 0.02),
      
              // ── Email Field ──────────────────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authEmail).tr(),
                style: AppTypography.subtitle2,
              ),
              const SizedBox(height: AppDimens.spacing8),
              XTextField(
                controller: controller.registerEmailController,
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
      
              SizedBox(height: Get.height * 0.02),
      
              // ── Password Field ───────────────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authPassword).tr(),
                style: AppTypography.subtitle2,
              ),
              const SizedBox(height: AppDimens.spacing8),
              Obx(
                () => XTextField(
                  controller: controller.registerPasswordController,
                  hintText: StringTranslateExtension(LocaleKeys.authPasswordHint).tr(),
                  obscureText: !controller.isRegisterPasswordVisible.value,
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
                    onTap: controller.toggleRegisterPasswordVisibility,
                    child: Icon(
                      controller.isRegisterPasswordVisible.value
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
      
              SizedBox(height: Get.height * 0.02),
      
              // ── Confirm Password Field ───────────────────
              Text(
                StringTranslateExtension(LocaleKeys.authConfirmPassword).tr(),
                style: AppTypography.subtitle2,
              ),
              const SizedBox(height: AppDimens.spacing8),
              Obx(
                () => XTextField(
                  controller: controller.registerConfirmPasswordController,
                  hintText: StringTranslateExtension(LocaleKeys.authConfirmPasswordHint).tr(),
                  obscureText:
                      !controller.isRegisterConfirmPasswordVisible.value,
                  validator: controller.validateConfirmPassword,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    size: AppDimens.iconMedium,
                    color:
                        isDark
                            ? AppColors.darkTextHint
                            : AppColors.textHint,
                  ),
                  suffixIcon: GestureDetector(
                    onTap:
                        controller.toggleRegisterConfirmPasswordVisibility,
                    child: Icon(
                      controller.isRegisterConfirmPasswordVisible.value
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
      
              SizedBox(height: Get.height * 0.04),
      
              // ── Sign Up Button ───────────────────────────
              Obx(
                () => XButton(
                  label: StringTranslateExtension(LocaleKeys.authSignUp).tr(),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.register,
                  isLoading: controller.isLoading.value,
                ),
              ),
      
              SizedBox(height: Get.height * 0.04),
      
              // ── Login Link ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringTranslateExtension(LocaleKeys.authAlreadyHaveAccount).tr(),
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacing4),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: Text(
                      StringTranslateExtension(LocaleKeys.authSignIn).tr(),
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