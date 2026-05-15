import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/services/user_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = Get.find<UserService>();

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

  // ── Login with Firebase ───────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );

      // Load user profile from Firestore
      try {
        await _userService.loadCurrentUser();
      } catch (_) {}

      // Success → Navigate to main page
      Get.offAllNamed(AppRoutes.mainPage);
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register with Firebase ────────────────────────────
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Create account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
      );

      // Update display name
      await credential.user?.updateDisplayName(
        registerNameController.text.trim(),
      );

      // Save user profile to Firestore (non-blocking)
      try {
        await _userService.createUserProfile(
          uid: credential.user!.uid,
          name: registerNameController.text.trim(),
          email: registerEmailController.text.trim(),
        );
      } catch (_) {}

      // Success → Navigate to main page
      Get.offAllNamed(AppRoutes.mainPage);
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Forgot Password ──────────────────────────────────
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Email Sent',
        'Check your inbox for a password reset link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseErrorMessage(e.code));
    }
  }

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    _userService.clearUser();
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.loginPage);
  }

  // ── Navigation ────────────────────────────────────────
  void goToRegister() {
    Get.toNamed(AppRoutes.registerPage);
  }

  void goToLogin() {
    Get.back();
  }

  // ── Error Helpers ─────────────────────────────────────
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Authentication failed. Please try again';
    }
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