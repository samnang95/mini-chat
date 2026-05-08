import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/error/failures.dart';
import 'package:mini_chat/domain/auth/entities/user_entity.dart';
import 'package:mini_chat/domain/auth/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;

  AuthController({required this.loginUseCase});

  // ── Reactive State ──────────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Actions ─────────────────────────────────────────────
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await loginUseCase(
        LoginParams(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );

      user.value = result;
      Get.offAllNamed('/home');
    } on ServerFailure catch (e) {
      errorMessage.value = e.message;
    } on NetworkFailure {
      errorMessage.value = 'No internet connection. Please try again.';
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Lifecycle ───────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
