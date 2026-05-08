import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/localization/locale_keys.dart';
import 'package:mini_chat/features/auth/controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringTranslateExtension(LocaleKeys.authLogin).tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: StringTranslateExtension(LocaleKeys.authEmail).tr(),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: controller.passwordController,
              decoration: InputDecoration(
                labelText: StringTranslateExtension(
                  LocaleKeys.authPassword,
                ).tr(),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),

            // Error message
            Obx(() {
              if (controller.errorMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Login button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          StringTranslateExtension(LocaleKeys.authLogin).tr(),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
