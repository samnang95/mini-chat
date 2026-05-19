import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:mini_chat/core/services/chat_service.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/core/services/storage_service.dart';
import 'package:mini_chat/data/chat/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatDetailController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final UserService _userService = Get.find<UserService>();

  final StorageService _storageService = Get.find<StorageService>();

  final chatName = ''.obs;
  final chatStatus = 'Online'.obs;
  final chatAvatar = ''.obs;
  final conversationId = ''.obs;
  final otherUserId = ''.obs;

  final messages = <MessageModel>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final isUploading = false.obs;

  // Voice recording state
  final _audioRecorder = AudioRecorder();
  final isRecording = false.obs;
  final recordingDuration = 0.obs;
  Timer? _recordingTimer;

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

  // ── Send Image ─────────────────────────────────────────
  Future<void> sendImage(ImageSource source) async {
    final file = await _storageService.pickImage(source: source);
    if (file == null) return;

    isUploading.value = true;

    // Create conversation if it doesn't exist yet
    if (conversationId.value.isEmpty && otherUserId.value.isNotEmpty) {
      conversationId.value = await _chatService.getOrCreateConversation(
        otherUserId.value,
      );
      _listenToMessages();
    }

    if (conversationId.value.isNotEmpty) {
      final url = await _storageService.uploadChatImage(
        conversationId: conversationId.value,
        file: file,
      );

      if (url != null) {
        await _chatService.sendMessage(
          conversationId: conversationId.value,
          text: '📸 Image',
          type: 'image',
          mediaUrl: url,
        );
      }
    }

    isUploading.value = false;
  }

  // ── Voice Recording ────────────────────────────────────
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        Get.snackbar('Permission Denied', 'Microphone access is required to send voice messages');
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        isRecording.value = true;
        recordingDuration.value = 0;
        
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordingDuration.value++;
        });
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      isRecording.value = false;
      
      final path = await _audioRecorder.stop();
      if (path != null) {
        final file = File(path);
        
        isUploading.value = true;
        
        // Ensure conversation exists
        if (conversationId.value.isEmpty && otherUserId.value.isNotEmpty) {
          conversationId.value = await _chatService.getOrCreateConversation(otherUserId.value);
          _listenToMessages();
        }

        if (conversationId.value.isNotEmpty) {
          final url = await _storageService.uploadChatImage(
            conversationId: conversationId.value,
            file: file,
          );

          if (url != null) {
            await _chatService.sendMessage(
              conversationId: conversationId.value,
              text: '🎤 Voice Message',
              type: 'voice',
              mediaUrl: url,
            );
          }
        }
        
        isUploading.value = false;
      }
    } catch (e) {
      print('Error stopping recording: $e');
      isUploading.value = false;
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