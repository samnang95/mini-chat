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
import 'package:mini_chat/app/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  AuthController get controller => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 6 staggered items: back, header, email, password, button, social
    _fadeAnimations = List.generate(6, (i) {
      final start = (i * 0.12).clamp(0.0, 0.7);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    _slideAnimations = List.generate(6, (i) {
      final start = (i * 0.12).clamp(0.0, 0.7);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOutCubic)),
      );
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

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
              _staggered(0, GestureDetector(
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
              )),
      
              SizedBox(height: Get.height * 0.04),
      
              // ── Header ───────────────────────────────────
              _staggered(1, Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringTranslateExtension(LocaleKeys.authLoginTitle).tr(),
                    style: AppTypography.heading1,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Text(
                    StringTranslateExtension(LocaleKeys.authLoginSubtitle).tr(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              )),
      
              SizedBox(height: Get.height * 0.05),
      
              // ── Email Field ──────────────────────────────
              _staggered(2, Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                  ),
                ],
              )),
      
              SizedBox(height: Get.height * 0.025),
      
              // ── Password Field ───────────────────────────
              _staggered(3, Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleLoginPasswordVisibility,
                        child: Icon(
                          controller.isLoginPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: AppDimens.iconMedium,
                          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
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
                        Get.toNamed(AppRoutes.forgotPasswordPage);
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
                ],
              )),
      
              SizedBox(height: Get.height * 0.05),
      
              // ── Sign In Button ───────────────────────────
              _staggered(4, Obx(
                () => XButton(
                  label: StringTranslateExtension(LocaleKeys.authSignIn).tr(),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  isLoading: controller.isLoading.value,
                ),
              )),
      
              SizedBox(height: Get.height * 0.03),
      
              // ── Divider + Social + Register ───────────────
              _staggered(5, Column(
                children: [
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
                            color: isDark
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
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Google',
                          onTap: controller.signInWithGoogle,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spacing16),
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.apple_rounded,
                          label: 'Apple',
                          onTap: controller.signInWithApple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringTranslateExtension(LocaleKeys.authDontHaveAccount).tr(),
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social Login Button Widget ────────────────────────────
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _scaleCtrl.forward();
    await _scaleCtrl.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) {
        _scaleCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
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
                widget.icon,
                size: AppDimens.iconMedium,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              const SizedBox(width: AppDimens.spacing8),
              Text(
                widget.label,
                style: AppTypography.button.copyWith(
                  color:
                      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}