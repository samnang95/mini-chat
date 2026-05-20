import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/app.dart';
import 'package:mini_chat/app/config/flavor_config.dart';
import 'package:mini_chat/firebase_options.dart';
import 'package:mini_chat/core/services/notification_service.dart';

Future<void> mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait up
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Make status bar transparent globally on Android
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Load the .env file for the current flavor
  await dotenv.load(fileName: config.envFileName);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local storage
  await GetStorage.init();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Notification Service
  Get.putAsync(() => NotificationService().init());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('km'), Locale('zh')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const App(),
    ),
  );
}
