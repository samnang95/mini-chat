import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/config/env_config.dart';
import 'package:mini_chat/core/network/api_client.dart';
import 'package:mini_chat/core/network/api_endpoints.dart';
import 'package:mini_chat/core/network/api_interceptors.dart';
import 'package:mini_chat/features/language/language_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ── Dio Instance ─────────────────────────────────────
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Api-Key': EnvConfig.apiKey,
        },
      ),
    );

    // Add interceptors (only add logging in non-prod)
    dio.interceptors.add(AuthInterceptor());
    if (EnvConfig.enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }

    // ── Register Dio & ApiClient ─────────────────────────
    Get.put<Dio>(dio, permanent: true);
    Get.put<ApiClient>(ApiClient(dio), permanent: true);

    // ── Language ─────────────────────────────────────────
    Get.put(LanguageController(), permanent: true);
  }
}
