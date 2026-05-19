import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini_chat/app/bindings/initial_binding.dart';
import 'package:mini_chat/app/routes/app_pages.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final savedDarkMode = GetStorage().read('isDarkMode') ?? false;

    return GetMaterialApp(
      title: 'Mini Chat',
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: savedDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialBinding: InitialBinding(),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.initial,
    );
  }
}