import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/services/user_service.dart';

class ProfileDetailController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  // ── Reactive User Data (from Firestore) ────────────────
  final name = ''.obs;
  final username = ''.obs;
  final bio = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final isMuted = false.obs;

  // ── Text Editing Controllers (for My Profile edit) ─────
  late TextEditingController nameEditController;
  late TextEditingController bioEditController;
  late TextEditingController phoneEditController;

  @override
  void onInit() {
    super.onInit();
    nameEditController = TextEditingController();
    bioEditController = TextEditingController();
    phoneEditController = TextEditingController();

    // Load real user data
    _loadUserData();

    // Listen for changes to currentUser
    ever(_userService.currentUser, (_) => _loadUserData());
  }

  void _loadUserData() {
    final user = _userService.currentUser.value;
    if (user != null) {
      name.value = user.name;
      username.value = user.username.isNotEmpty ? user.username : '@${user.name.toLowerCase().replaceAll(' ', '_')}';
      bio.value = user.bio;
      phone.value = user.phone;
      email.value = user.email;
    }
  }

  @override
  void onClose() {
    nameEditController.dispose();
    bioEditController.dispose();
    phoneEditController.dispose();
    super.onClose();
  }

  // ── Edit Actions (save to Firestore) ───────────────────
  void editName() {
    nameEditController.text = name.value;
    Get.dialog(_buildEditDialog('Edit Name', nameEditController, (val) async {
      name.value = val;
      await _userService.updateProfile(name: val);
    }));
  }

  void editBio() {
    bioEditController.text = bio.value;
    Get.dialog(_buildEditDialog('Edit Bio', bioEditController, (val) async {
      bio.value = val;
      await _userService.updateProfile(bio: val);
    }));
  }

  void editPhone() {
    phoneEditController.text = phone.value;
    Get.dialog(_buildEditDialog('Edit Phone', phoneEditController, (val) async {
      phone.value = val;
      await _userService.updateProfile(phone: val);
    }));
  }

  void changeAvatar() {
    // TODO: Open image picker + upload to Firebase Storage
    Get.snackbar(
      'Coming Soon',
      'Image picker will be integrated here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Widget _buildEditDialog(
    String title,
    TextEditingController textController,
    Function(String) onSave,
  ) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onSave(textController.text);
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  // ── Friend Actions (used by ProfileDetailFriendPage) ───
  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void onMessageTap() {
    // TODO: Navigate to chat with this user
    Get.back();
  }

  void onAudioCallTap() {
    // TODO: Start audio call
  }

  void onVideoCallTap() {
    // TODO: Start video call
  }
}