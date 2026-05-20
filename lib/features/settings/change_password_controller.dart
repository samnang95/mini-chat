import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordController extends GetxController {
  final currentPassword = ''.obs;
  final newPassword = ''.obs;
  final confirmPassword = ''.obs;
  
  final isLoading = false.obs;
  
  void changePassword() async {
    if (currentPassword.value.isEmpty || newPassword.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('Error', 'New passwords do not match');
      return;
    }
    
    if (newPassword.value.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }
    
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword.value,
        );
        await user.reauthenticateWithCredential(cred);
        
        // Update password
        await user.updatePassword(newPassword.value);
        
        Get.back();
        Get.snackbar('Success', 'Password updated successfully');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Authentication failed. Please check your current password.');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}
