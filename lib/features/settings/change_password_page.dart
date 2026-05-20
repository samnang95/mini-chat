import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/features/settings/change_password_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePasswordController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return XScaffold(
      appBar: XAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
        titleWidget: Text(
          'Change Password',
          style: AppTypography.heading2.copyWith(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create a new secure password for your account. Make sure it is at least 6 characters long.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              label: 'Current Password',
              onChanged: (val) => controller.currentPassword.value = val,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'New Password',
              onChanged: (val) => controller.newPassword.value = val,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Confirm New Password',
              onChanged: (val) => controller.confirmPassword.value = val,
              isDark: isDark,
            ),
            const Spacer(),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: controller.isLoading.value 
                  ? const SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Update Password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required Function(String) onChanged,
    required bool isDark,
  }) {
    return TextField(
      obscureText: true,
      onChanged: onChanged,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? AppColors.darkTextHint : AppColors.textHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
      ),
    );
  }
}
