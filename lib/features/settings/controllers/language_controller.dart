import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final RxString currentLanguage = 'en'.obs;

  static const supportedLocales = [
    {'name': 'English', 'locale': Locale('en')},
    {'name': 'ខ្មែរ', 'locale': Locale('km')},
  ];

  @override
  void onInit() {
    super.onInit();
    currentLanguage.value = Get.context?.locale.languageCode ?? 'en';
  }

  Future<void> changeLanguage(Locale locale) async {
    final context = Get.context;
    if (context != null) {
      await context.setLocale(locale);
      currentLanguage.value = locale.languageCode;

      // Force GetMaterialApp to rebuild with new locale
      Get.updateLocale(locale);
    }
  }
}
