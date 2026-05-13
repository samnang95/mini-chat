import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/language/language_controller.dart';
import 'package:mini_chat/features/language/widgets/language_option.dart';
import 'package:mini_chat/features/language/widgets/button_confirm.dart';
import 'package:mini_chat/core/constants/app_images.dart';

class LanguagePage extends GetView<LanguageController> {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return XScaffold(
      appBar: XAppBar(
        title: StringTranslateExtension(LocaleKeys.selectLanguage).tr(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
        // Obx listens to changes in the controller and automatically updates the UI
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(
            () => Column(
              children: [
                LanguageOption(
                  flag: AppImages.imageEnglish,
                  title: StringTranslateExtension(LocaleKeys.english).tr(),
                  isSelected: controller.tempLanguage.value == 'en',
                  onTap: () => controller.selectTempLanguage('en'),
                ),
                LanguageOption(
                  flag: AppImages.imageKhmer,
                  title: StringTranslateExtension(LocaleKeys.khmer).tr(),
                  isSelected: controller.tempLanguage.value == 'km',
                  onTap: () => controller.selectTempLanguage('km'),
                ),
                LanguageOption(
                  flag: AppImages.imageChines,
                  title: StringTranslateExtension(LocaleKeys.chinese).tr(),
                  isSelected: controller.tempLanguage.value == 'zh',
                  onTap: () => controller.selectTempLanguage('zh'),
                ),
                const SizedBox(height: 16),
                const Spacer(),
                ButtonConfirm(
                  onPressed: () {
                    // Apply the language only when confirming
                    controller.changeLanguage(Locale(controller.tempLanguage.value));
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
