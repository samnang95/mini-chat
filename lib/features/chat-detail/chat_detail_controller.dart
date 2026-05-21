import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:mini_chat/core/services/chat_service.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/core/services/storage_service.dart';
import 'package:mini_chat/data/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:mini_chat/core/theme/app_colors.dart';

class ChatDetailController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final UserService _userService = Get.find<UserService>();

  final StorageService _storageService = Get.find<StorageService>();

  final chatName = ''.obs;
  final chatStatus = 'Online'.obs;
  final chatAvatar = ''.obs;
  final isFriendTyping = false.obs;
  final isUploading = false.obs;
  final conversationId = ''.obs;
  final otherUserId = ''.obs;

  final messages = <MessageModel>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Voice recording state
  final _audioRecorder = AudioRecorder();
  final isRecording = false.obs;
  final recordingDuration = 0.obs;
  Timer? _recordingTimer;
  Timer? _typingTimer;

  StreamSubscription? _messagesSubscription;
  StreamSubscription? _userSubscription;
  StreamSubscription? _conversationSubscription;

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
      _listenToConversation();
    }

    messageController.addListener(_onTextChanged);

    // Listen to friend's online status
    if (otherUserId.value.isNotEmpty) {
      _listenToFriendStatus();
    }
  }

  void _onTextChanged() {
    final text = messageController.text;
    if (text.isNotEmpty) {
      Get.find<ChatService>().setTypingStatus(conversationId.value, true);
      
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        Get.find<ChatService>().setTypingStatus(conversationId.value, false);
      });
    }
  }

  void _listenToConversation() {
    _conversationSubscription = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId.value)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final typingUsers = List<String>.from(data['typingUsers'] ?? []);
        isFriendTyping.value = typingUsers.contains(otherUserId.value);
      }
    });
  }

  void _listenToFriendStatus() {
    // We need to listen directly to the Firestore document for the friend
    _userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId.value)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final isOnline = data['isOnline'] ?? false;
        if (isOnline) {
          chatStatus.value = 'Online';
        } else {
          final lastSeen = (data['lastSeen'] as dynamic)?.toDate();
          if (lastSeen != null) {
            chatStatus.value = _formatLastSeen(lastSeen);
          } else {
            chatStatus.value = 'Offline';
          }
        }
      }
    });
  }

  String _formatLastSeen(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Last seen just now';
    if (diff.inHours < 1) return 'Last seen ${diff.inMinutes}m ago';
    if (diff.inDays < 1) {
      return 'Last seen at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays == 1) return 'Last seen yesterday';
    if (diff.inDays < 7) return 'Last seen ${diff.inDays}d ago';
    return 'Last seen ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _listenToMessages() {
    _messagesSubscription = _chatService
        .getMessages(conversationId.value)
        .listen((msgList) {
      final previousCount = messages.length;
      messages.value = msgList;

      // Only scroll to bottom when a new message arrives, not on reaction updates
      if (msgList.length > previousCount) {
        _scrollToBottom();
      }
      
      // Mark received messages as read
      _chatService.markMessagesAsRead(conversationId.value, _currentUid);
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
    _typingTimer?.cancel();
    Get.find<ChatService>().setTypingStatus(conversationId.value, false);

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

  // ── Emoji Reactions ─────────────────────────────────────
  static const reactionEmojis = ['❤️', '😂', '👍', '😮', '😢', '🔥'];

  Future<void> toggleReaction(MessageModel msg, String emoji) async {
    await _chatService.toggleReaction(conversationId.value, msg.id, emoji);
  }

  // ── Message Options ────────────────────────────────────
  void showMessageOptions(BuildContext context, MessageModel msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Emoji Reaction Picker ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: reactionEmojis.map((emoji) {
                  final hasReacted = msg.reactions[emoji]?.contains(_currentUid) ?? false;
                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      toggleReaction(msg, emoji);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hasReacted
                            ? AppColors.primary.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1),
            // ── Other options ──
            if (msg.type == 'text')
              ListTile(
                leading: const Icon(Icons.copy, color: AppColors.primary),
                title: const Text('Copy Text'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: msg.text));
                  Get.back();
                  Get.snackbar('Copied', 'Message copied to clipboard');
                },
              ),
            if (isMyMessage(msg))
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete for Everyone', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Get.back();
                  await _chatService.deleteMessage(conversationId.value, msg.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  // ── Check if message is from me ────────────────────────
  bool isMyMessage(MessageModel message) {
    return message.senderId == _currentUid;
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    _userSubscription?.cancel();
    _conversationSubscription?.cancel();
    _typingTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}