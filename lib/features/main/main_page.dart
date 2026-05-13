import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/features/call/call_page.dart';
import 'package:mini_chat/features/chat/chat_page.dart';
import 'package:mini_chat/features/contact/contact_page.dart';
import 'package:mini_chat/features/main/main_controller.dart';
import 'package:mini_chat/features/settings/settings_page.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navHeight = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: const [
          ChatPage(),
          ContactPage(),
          CallPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: navHeight,
        color: AppColors.primaryLighter,
        child: Obx(
          () => Row(
            children: [
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: StringTranslateExtension(LocaleKeys.mainChat).tr(),
                isSelected: controller.currentIndex.value == 0,
                height: navHeight,
                onTap: () => controller.changePage(0),
              ),
              _NavItem(
                icon: Icons.people,
                label: StringTranslateExtension(LocaleKeys.mainContacts).tr(),
                isSelected: controller.currentIndex.value == 1,
                height: navHeight,
                onTap: () => controller.changePage(1),
              ),
              _NavItem(
                icon: Icons.call,
                label: StringTranslateExtension(LocaleKeys.mainCall).tr(),
                isSelected: controller.currentIndex.value == 2,
                height: navHeight,
                onTap: () => controller.changePage(2),
              ),
              _NavItem(
                icon: Icons.settings,
                label: StringTranslateExtension(LocaleKeys.mainSettings).tr(),
                isSelected: controller.currentIndex.value == 3,
                height: navHeight,
                onTap: () => controller.changePage(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final double height;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryDark : AppColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
