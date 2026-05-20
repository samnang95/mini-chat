import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/services/chat_service.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';
import 'package:mini_chat/data/chat/models/conversation_model.dart';

class ChatController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final UserService _userService = Get.find<UserService>();

  final searchQuery = ''.obs;
  final isShow = false.obs;
  final scrollController = ScrollController();

  final conversations = <ConversationModel>[].obs;
  final userCache = <String, UserModel>{}.obs;

  StreamSubscription? _conversationsSubscription;

  String get _currentUid => _userService.currentUser.value?.uid ?? '';

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

    // Listen to real-time conversations
    _listenToConversations();
  }

  void _listenToConversations() {
    _conversationsSubscription = _chatService
        .getConversations()
        .listen((convList) async {
      conversations.value = convList;

      // Cache user info for each conversation
      for (final conv in convList) {
        final otherUid = conv.participants.firstWhere(
          (uid) => uid != _currentUid,
          orElse: () => '',
        );
        if (otherUid.isNotEmpty && !userCache.containsKey(otherUid)) {
          final user = await _userService.getUserById(otherUid);
          if (user != null) {
            userCache[otherUid] = user;
          }
        }
      }
    });
  }

  // ── Get other user in conversation ─────────────────────
  String getOtherUserId(ConversationModel conv) {
    return conv.participants.firstWhere(
      (uid) => uid != _currentUid,
      orElse: () => '',
    );
  }

  UserModel? getOtherUser(ConversationModel conv) {
    final otherUid = getOtherUserId(conv);
    return userCache[otherUid];
  }

  int getUnreadCount(ConversationModel conv) {
    return conv.unreadCounts[_currentUid] ?? 0;
  }

  int get totalUnreadCount {
    return conversations.fold(0, (sum, conv) => sum + getUnreadCount(conv));
  }

  // ── Search ─────────────────────────────────────────────
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  List<ConversationModel> get filteredConversations {
    // Track userCache changes so Obx rebuilds the list when a user is loaded
    final _ = userCache.length;
    // Track blocked users to rebuild when someone is blocked/unblocked
    final blockedUsers = _userService.currentUser.value?.blockedUsers ?? [];
    
    final unblockedConvs = conversations.where((conv) {
      final otherUid = getOtherUserId(conv);
      return !blockedUsers.contains(otherUid);
    });

    if (searchQuery.value.isEmpty) return unblockedConvs.toList();
    
    return unblockedConvs.where((conv) {
      final user = getOtherUser(conv);
      if (user == null) return false;
      return user.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
    }).toList();
  }

  // ── Format time ────────────────────────────────────────
  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  // ── Pull to Refresh ────────────────────────────────────
  Future<void> refreshConversations() async {
    // Re-fetch user cache (avatars, names may have changed)
    userCache.clear();
    for (final conv in conversations) {
      final otherUid = conv.participants.firstWhere(
        (uid) => uid != _currentUid,
        orElse: () => '',
      );
      if (otherUid.isNotEmpty) {
        final user = await _userService.getUserById(otherUid);
        if (user != null) {
          userCache[otherUid] = user;
        }
      }
    }
  }

  @override
  void onClose() {
    _conversationsSubscription?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}
