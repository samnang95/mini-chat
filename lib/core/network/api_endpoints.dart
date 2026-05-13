import 'package:mini_chat/app/config/env_config.dart';

abstract class ApiEndpoints {
  // ── Base URL (loaded from .env file) ───────────────────
  static String get baseUrl => EnvConfig.baseUrl;

  // ── Auth ───────────────────────────────────────────────
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const logout = '/auth/logout';
  static const refreshToken = '/auth/refresh';

  // ── User ───────────────────────────────────────────────
  static const profile = '/user/profile';
  static const updateProfile = '/user/profile';

  // ── Chat ───────────────────────────────────────────────
  static const conversations = '/chat/conversations';
  static String messages(String conversationId) =>
      '/chat/conversations/$conversationId/messages';
}