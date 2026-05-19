import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  final isDarkMode = false.obs;

  static const _darkModeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    // Load saved preference (theme is already applied in app.dart)
    isDarkMode.value = _storage.read(_darkModeKey) ?? false;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _storage.write(_darkModeKey, value); // Save to disk
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}