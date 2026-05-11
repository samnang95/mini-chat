import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_chat/core/localization/locale_keys.dart';
import 'package:mini_chat/core/widgets/x_button_switch.dart';
import 'package:mini_chat/core/widgets/x_profile.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/auth/widgets/logout.dart';
import 'package:mini_chat/features/settings/settings_controller.dart';
import 'package:mini_chat/features/settings/widgets/subtitle.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(
      appBar: XAppBar(
        leading: ClipOval(
          child: Image.asset(
            AppImages.image,
            width: 40,
            height: 35,
            fit: BoxFit.cover,
          ),
        ),
        title: StringTranslateExtension(LocaleKeys.settings).tr(),
        action: Icon(FontAwesomeIcons.magnifyingGlass),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            XProfile(),
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
              isSwitch: false,
              suffixIcon: FontAwesomeIcons.arrowRightLong,
              icon: FontAwesomeIcons.circleQuestion,
              title: StringTranslateExtension(LocaleKeys.helpCenter).tr(),
              value: false,
              onChanged: (val) {},
            ),
            Logout(),
          ],
        ),
      ),
    );
  }
}
