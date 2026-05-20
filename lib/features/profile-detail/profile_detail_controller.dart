import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_chat/core/services/storage_service.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/core/services/chat_service.dart';
import 'package:mini_chat/core/theme/app_colors.dart';

class ProfileDetailController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final StorageService _storageService = Get.find<StorageService>();
  final ChatService _chatService = Get.find<ChatService>();

  // ── Reactive User Data (from Firestore) ────────────────
  final name = ''.obs;
  final username = ''.obs;
  final bio = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;
  final isUploading = false.obs;
  final isMuted = false.obs;
  final sharedMedia = <String>[].obs;
  final friendUid = ''.obs;

  bool get isBlocked {
    if (friendUid.value.isEmpty) return false;
    return _userService.currentUser.value?.blockedUsers.contains(friendUid.value) ?? false;
  }

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

    // Load data based on arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['uid'] != null) {
      friendUid.value = args['uid'];
      _loadFriendData(args['uid']);
      if (args['conversationId'] != null) {
        _loadSharedMedia(args['conversationId']);
      }
    } else {
      _loadUserData();
      ever(_userService.currentUser, (_) => _loadUserData());
    }
  }

  Future<void> _loadFriendData(String uid) async {
    final user = await _userService.getUserById(uid);
    if (user != null) {
      name.value = user.name;
      username.value = user.username.isNotEmpty
          ? user.username
          : '@${user.name.toLowerCase().replaceAll(' ', '_')}';
      bio.value = user.bio;
      phone.value = user.phone;
      email.value = user.email;
      avatarUrl.value = user.avatarUrl;
    }
  }

  Future<void> _loadSharedMedia(String conversationId) async {
    final media = await _chatService.getSharedMedia(conversationId);
    sharedMedia.value = media;
  }

  void _loadUserData() {
    final user = _userService.currentUser.value;
    if (user != null) {
      name.value = user.name;
      username.value = user.username.isNotEmpty
          ? user.username
          : '@${user.name.toLowerCase().replaceAll(' ', '_')}';
      bio.value = user.bio;
      phone.value = user.phone;
      email.value = user.email;
      avatarUrl.value = user.avatarUrl;
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
    Get.dialog(
      _buildEditDialog('Edit Name', nameEditController, (val) async {
        name.value = val;
        await _userService.updateProfile(name: val);
      }),
    );
  }

  void editBio() {
    bioEditController.text = bio.value;
    Get.dialog(
      _buildEditDialog('Edit Bio', bioEditController, (val) async {
        bio.value = val;
        await _userService.updateProfile(bio: val);
      }),
    );
  }

  void editPhone() {
    phoneEditController.text = phone.value;
    Get.dialog(
      _buildEditDialog('Edit Phone', phoneEditController, (val) async {
        phone.value = val;
        await _userService.updateProfile(phone: val);
      }),
    );
  }

  void changeAvatar() {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkDivider : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Change Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: Colors.blue,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : Colors.black,
                ),
              ),
              onTap: () {
                Get.back();
                _uploadAvatar(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.green,
              ),
              title: Text(
                'Take a Photo',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : Colors.black,
                ),
              ),
              onTap: () {
                Get.back();
                _uploadAvatar(ImageSource.camera);
              },
            ),
            if (avatarUrl.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: Colors.red),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                ),
                onTap: () {
                  Get.back();
                  _removeAvatar();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAvatar(ImageSource source) async {
    final file = await _storageService.pickImage(source: source);
    if (file == null) return;

    isUploading.value = true;

    final uid = _userService.currentUser.value?.uid ?? '';
    final url = await _storageService.uploadAvatar(uid: uid, file: file);

    if (url != null) {
      // Clear image cache to show new avatar immediately
      imageCache.clear();
      imageCache.clearLiveImages();
      avatarUrl.value = url;
      await _userService.updateProfile(avatarUrl: url);
      Get.snackbar(
        'Success',
        'Profile photo updated!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to upload photo. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isUploading.value = false;
  }

  Future<void> _removeAvatar() async {
    avatarUrl.value = '';
    await _userService.updateProfile(avatarUrl: '');
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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

  Future<void> toggleBlockUser() async {
    if (friendUid.value.isNotEmpty) {
      await _userService.toggleBlockUser(friendUid.value);
    }
  }

  void onMessageTap() {
    Get.back(); // If already coming from ChatDetail, this closes the profile.
    // Otherwise, we could check if we need to navigate, but since ChatPage passes to ChatDetail, this handles it simply.
  }

  void onAudioCallTap() {
    // TODO: Start audio call
  }

  void onVideoCallTap() {
    // TODO: Start video call
  }
}
