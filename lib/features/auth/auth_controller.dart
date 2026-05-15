import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';

class AuthController extends GetxController {
  // ── Login Fields ──────────────────────────────────────
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  // ── Register Fields ───────────────────────────────────
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();

  // ── State ─────────────────────────────────────────────
  final isLoginPasswordVisible = false.obs;
  final isRegisterPasswordVisible = false.obs;
  final isRegisterConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  // ── Toggle Visibility ─────────────────────────────────
  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
  }

  void toggleRegisterConfirmPasswordVisibility() {
    isRegisterConfirmPasswordVisible.value =
        !isRegisterConfirmPasswordVisible.value;
  }

  // ── Validators ────────────────────────────────────────
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != registerPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ── Actions ───────────────────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    // TODO: Replace with real API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Navigate to main page on success
    Get.offAllNamed(AppRoutes.mainPage);
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;

    // TODO: Replace with real API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Navigate to main page on success
    Get.offAllNamed(AppRoutes.mainPage);
  }

  // ── Navigation ────────────────────────────────────────
  void goToRegister() {
    Get.toNamed(AppRoutes.registerPage);
  }

  void goToLogin() {
    Get.back();
  }

  // ── Dispose ───────────────────────────────────────────
  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.onClose();
  }
}