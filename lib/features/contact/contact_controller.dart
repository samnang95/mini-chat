import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/services/chat_service.dart';
import 'package:mini_chat/core/services/user_service.dart';

class ContactController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final ChatService _chatService = Get.find<ChatService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final isShow = false.obs;
  final scrollController = ScrollController();
  final contacts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.offset > 0) {
        if (!isShow.value) isShow.value = true;
      } else {
        if (isShow.value) isShow.value = false;
      }
    });

    // Load real users from Firestore
    _loadUsers();

    // Re-load if blocked users change
    List<String> previousBlocked = _userService.currentUser.value?.blockedUsers ?? [];
    ever(_userService.currentUser, (user) {
      if (user != null) {
        final currentBlocked = user.blockedUsers;
        if (currentBlocked.length != previousBlocked.length || 
            !currentBlocked.every((e) => previousBlocked.contains(e))) {
          previousBlocked = List.from(currentBlocked);
          _loadUsers();
        }
      }
    });
  }

  // ── Load all registered users ──────────────────────────
  Future<void> _loadUsers() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final blockedUsers = _userService.currentUser.value?.blockedUsers ?? [];

    final snapshot = await _firestore.collection('users').get();

    final users = snapshot.docs
        .where((doc) => doc.id != currentUid && !blockedUsers.contains(doc.id)) // Exclude myself and blocked users
        .map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'name': data['name'] ?? '',
        'status': data['bio']?.isNotEmpty == true
            ? data['bio']
            : 'Hey there! I am using Mini Chat.',
        'isOnline': data['isOnline'] ?? false,
        'avatar': data['avatarUrl'] ?? '',
        'email': data['email'] ?? '',
      };
    }).toList();

    contacts.value = users;
  }

  // ── Invite Friend (Search by Email) ────────────────────
  void inviteFriend() {
    final emailController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Start Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your friend\'s email to start chatting:'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'friend@email.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;

              Get.back();
              await _startChatByEmail(email);
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  Future<void> _startChatByEmail(String email) async {
    try {
      // Find user by email
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isEmpty) {
        Get.snackbar(
          'Not Found',
          'No user found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final friendDoc = query.docs.first;
      final friendData = friendDoc.data();
      final friendUid = friendDoc.id;

      // Don't chat with yourself
      if (friendUid == FirebaseAuth.instance.currentUser?.uid) {
        Get.snackbar(
          'Oops',
          'You can\'t chat with yourself!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Get or create conversation
      final conversationId = await _chatService.getOrCreateConversation(friendUid);

      // Navigate to chat
      Get.toNamed(
        AppRoutes.chatDetailPage,
        arguments: {
          'conversationId': conversationId,
          'name': friendData['name'] ?? '',
          'avatar': friendData['avatarUrl'] ?? '',
          'status': 'Online',
          'otherUserId': friendUid,
        },
      );

      // Refresh contacts
      _loadUsers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
