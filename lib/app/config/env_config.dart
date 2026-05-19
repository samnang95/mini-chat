import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'Mini Chat';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get socketUrl => dotenv.env['SOCKET_URL'] ?? '';
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING'] == 'true';

  // ── ImageKit.io ──────────────────────────────────────
  static String get imagekitPublicKey => dotenv.env['IMAGEKIT_PUBLIC_KEY'] ?? '';
  static String get imagekitPrivateKey => dotenv.env['IMAGEKIT_PRIVATE_KEY'] ?? '';
  static String get imagekitUrlEndpoint => dotenv.env['IMAGEKIT_URL_ENDPOINT'] ?? '';
}
