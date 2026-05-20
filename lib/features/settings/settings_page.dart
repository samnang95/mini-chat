import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_button_switch.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/core/widgets/x_profile.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/auth/auth_controller.dart';
import 'package:mini_chat/features/auth/widgets/logout.dart';
import 'package:mini_chat/features/settings/settings_controller.dart';
import 'package:mini_chat/features/settings/widgets/subtitle.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(
      appBar: XAppBar(
        leading: GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profileDetailPage),
          child: Obx(() {
            final avatarUrl = Get.find<UserService>().currentUser.value?.avatarUrl ?? '';
            return ClipOval(
              child: avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      width: 40,
                      height: 35,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      AppImages.image,
                      width: 40,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
            );
          }),
        ),
        titleWidget: XGradientText(
          StringTranslateExtension(LocaleKeys.settings).tr(),
          colors: const [Color.fromARGB(255, 8, 8, 11), AppColors.accent],
          style: AppTypography.heading1,
        ),
        action: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.profileDetailPage),
                child: XProfile(),
              ),
              SizedBox(height: 8),
              Subtitle(
                title: StringTranslateExtension(LocaleKeys.preferences).tr(),
              ),
              SizedBox(height: 8),
              XButtonSwitch(
                isSwitch: false,
                suffixIcon: FontAwesomeIcons.arrowRightLong,
                icon: FontAwesomeIcons.user,
                title: StringTranslateExtension(LocaleKeys.account).tr(),
                value: false,
                onChanged: (val) {},
                onTap: () => Get.toNamed(AppRoutes.profileDetailPage),
              ),
              XButtonSwitch(
                isSwitch: false,
                suffixIcon: FontAwesomeIcons.arrowRightLong,
                icon: FontAwesomeIcons.shield,
                title: StringTranslateExtension(
                  LocaleKeys.privacyAndSecurity,
                ).tr(),
                value: false,
                onChanged: (val) {},
                onTap: () => Get.toNamed(AppRoutes.changePasswordPage),
              ),
              XButtonSwitch(
                isSwitch: false,
                suffixIcon: FontAwesomeIcons.arrowRightLong,
                // ignore: deprecated_member_use
                icon: FontAwesomeIcons.commentAlt,
                title: StringTranslateExtension(LocaleKeys.chatSettings).tr(),
                value: false,
                onChanged: (val) {},
              ),
              XButtonSwitch(
                icon: FontAwesomeIcons.google,
                title: StringTranslateExtension(LocaleKeys.translation).tr(),
                isSwitch: false,
                onTap: () {
                  Get.toNamed(AppRoutes.languagePage);
                },
                suffixIcon: FontAwesomeIcons.arrowRightLong,
              ),
              Obx(
                () => XButtonSwitch(
                  icon: controller.isDarkMode.value
                      ? FontAwesomeIcons.moon
                      : FontAwesomeIcons.sun,
                  title: StringTranslateExtension(LocaleKeys.appearance).tr(),
                  value: controller.isDarkMode.value,
                  onChanged: (val) => controller.toggleTheme(val),
                ),
              ),
              SizedBox(height: 8),
              Subtitle(title: StringTranslateExtension(LocaleKeys.support).tr()),
              SizedBox(height: 8),
              XButtonSwitch(
                icon: Icons.block_rounded,
                title: 'Blocked Users', // Hardcoded for now
                isSwitch: false,
                onTap: () {
                  Get.toNamed(AppRoutes.blockedUsersPage);
                },
                suffixIcon: FontAwesomeIcons.arrowRightLong,
              ),
              XButtonSwitch(
                isSwitch: false,
                suffixIcon: FontAwesomeIcons.arrowRightLong,
                icon: FontAwesomeIcons.circleQuestion,
                title: StringTranslateExtension(LocaleKeys.helpCenter).tr(),
                value: false,
                onChanged: (val) {},
              ),
              Logout(
                onPressed: () {
                  Get.find<AuthController>().logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
