import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/services/chat_service.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/data/chat/models/message_model.dart';

class ChatDetailController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final UserService _userService = Get.find<UserService>();

  final chatName = ''.obs;
  final chatStatus = 'Online'.obs;
  final chatAvatar = ''.obs;
  final conversationId = ''.obs;
  final otherUserId = ''.obs;

  final messages = <MessageModel>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  StreamSubscription? _messagesSubscription;

  String get _currentUid => _userService.currentUser.value?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    // Read arguments passed from chat list
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      chatName.value = args['name'] ?? '';
      chatStatus.value = args['status'] ?? 'Online';
      chatAvatar.value = args['avatar'] ?? '';
      conversationId.value = args['conversationId'] ?? '';
      otherUserId.value = args['otherUserId'] ?? '';
    }

    // Listen to real-time messages
    if (conversationId.value.isNotEmpty) {
      _listenToMessages();
    }
  }

  void _listenToMessages() {
    _messagesSubscription = _chatService
        .getMessages(conversationId.value)
        .listen((messageList) {
      messages.value = messageList;
      // Auto-scroll to bottom on new messages
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Send Message ───────────────────────────────────────
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    // Create conversation if it doesn't exist yet
    if (conversationId.value.isEmpty && otherUserId.value.isNotEmpty) {
      conversationId.value = await _chatService.getOrCreateConversation(
        otherUserId.value,
      );
      _listenToMessages();
    }

    if (conversationId.value.isNotEmpty) {
      await _chatService.sendMessage(
        conversationId: conversationId.value,
        text: text,
      );
    }
  }

  // ── Check if message is from me ────────────────────────
  bool isMyMessage(MessageModel message) {
    return message.senderId == _currentUid;
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}