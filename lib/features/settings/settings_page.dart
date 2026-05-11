import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:mini_chat/core/constants/app_icons.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_chat/core/widgets/x_button_switch.dart';
import 'package:mini_chat/core/widgets/x_profile.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
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
        title: 'Settings',
        action: SvgPicture.asset(AppIcons.icSearch),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            XProfile(),
            SizedBox(height: 8),
            Subtitle(title: 'Preferences'),
            SizedBox(height: 8),
            XButtonSwitch(
              icon: FontAwesomeIcons.moon,
              title: 'DarkMode',
              value: false,
              onChanged: (val) {},
            ),
            XButtonSwitch(
              icon: FontAwesomeIcons.moon,
              title: 'DarkMode',
              value: false,
              onChanged: (val) {},
            ),
            XButtonSwitch(
              icon: FontAwesomeIcons.moon,
              title: 'DarkMode',
              value: false,
              onChanged: (val) {},
            ),
            XButtonSwitch(
              icon: FontAwesomeIcons.moon,
              title: 'DarkMode',
              value: false,
              onChanged: (val) {},
            ),
            XButtonSwitch(
              icon: FontAwesomeIcons.moon,
              title: 'DarkMode',
              value: false,
              onChanged: (val) {},
            ),
          ],
        ),
      ),
    );
  }
}
