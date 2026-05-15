import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mini_chat/data/chat/models/conversation_model.dart';
import 'package:mini_chat/data/chat/models/message_model.dart';

class ChatService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUid => _auth.currentUser?.uid ?? '';

  // ── Collection References ──────────────────────────────
  CollectionReference get _conversationsRef =>
      _firestore.collection('conversations');

  CollectionReference _messagesRef(String conversationId) =>
      _conversationsRef.doc(conversationId).collection('messages');

  // ── Get or Create Conversation ─────────────────────────
  Future<String> getOrCreateConversation(String otherUserId) async {
    // Check if conversation already exists
    final query = await _conversationsRef
        .where('participants', arrayContains: _currentUid)
        .get();

    for (final doc in query.docs) {
      final participants = List<String>.from(
        (doc.data() as Map<String, dynamic>)['participants'] ?? [],
      );
      if (participants.contains(otherUserId)) {
        return doc.id; // Return existing conversation
      }
    }

    // Create new conversation
    final doc = await _conversationsRef.add(
      ConversationModel(
        id: '',
        participants: [_currentUid, otherUserId],
        lastMessageTime: DateTime.now(),
      ).toFirestore(),
    );

    return doc.id;
  }

  // ── Send Message ───────────────────────────────────────
  Future<void> sendMessage({
    required String conversationId,
    required String text,
    String type = 'text',
    String? mediaUrl,
  }) async {
    final message = MessageModel(
      id: '',
      senderId: _currentUid,
      text: text,
      type: type,
      mediaUrl: mediaUrl,
      createdAt: DateTime.now(),
    );

    // Add message to subcollection
    await _messagesRef(conversationId).add(message.toFirestore());

    // Update conversation's last message
    await _conversationsRef.doc(conversationId).update({
      'lastMessage': text,
      'lastMessageTime': Timestamp.fromDate(DateTime.now()),
      'lastMessageSenderId': _currentUid,
    });
  }

  // ── Stream Messages (real-time) ────────────────────────
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _messagesRef(conversationId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  // ── Stream Conversations (real-time) ───────────────────
  Stream<List<ConversationModel>> getConversations() {
    return _conversationsRef
        .where('participants', arrayContains: _currentUid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromFirestore(doc))
            .toList());
  }
}
