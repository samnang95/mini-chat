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

    final convDoc = await _conversationsRef.doc(conversationId).get();
    if (convDoc.exists) {
      final data = convDoc.data() as Map<String, dynamic>?;
      final participants = List<String>.from(data?['participants'] ?? []);
      final otherUid = participants.firstWhere((id) => id != _currentUid, orElse: () => '');

      final updates = <String, dynamic>{
        'lastMessage': text,
        'lastMessageTime': Timestamp.fromDate(DateTime.now()),
        'lastMessageSenderId': _currentUid,
      };

      if (otherUid.isNotEmpty) {
        updates['unreadCounts.$otherUid'] = FieldValue.increment(1);
      }

      await _conversationsRef.doc(conversationId).update(updates);
    }
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

  // ── Get Shared Media ───────────────────────────────────
  Future<List<String>> getSharedMedia(String conversationId) async {
    if (conversationId.isEmpty) return [];
    try {
      final snapshot = await _messagesRef(conversationId)
          .where('type', isEqualTo: 'image')
          .get();

      final messages = snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
      // Sort locally to avoid needing a Firestore composite index
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return messages
          .map((m) => m.mediaUrl ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error getting shared media: $e');
      return [];
    }
  }

  // ── Set Typing Status ───────────────────────────────────
  Future<void> setTypingStatus(String conversationId, bool isTyping) async {
    if (conversationId.isEmpty) return;
    
    final update = isTyping
        ? FieldValue.arrayUnion([_currentUid])
        : FieldValue.arrayRemove([_currentUid]);
        
    try {
      await _conversationsRef.doc(conversationId).update({
        'typingUsers': update,
      });
    } catch (e) {
      print('Failed to update typing status: $e');
    }
  }

  // ── Mark Messages as Read ────────────────────────────────
  Future<void> markMessagesAsRead(String conversationId, String currentUid) async {
    if (conversationId.isEmpty) return;
    try {
      // Clear current user's unread count
      await _conversationsRef.doc(conversationId).update({
        'unreadCounts.$currentUid': 0,
      });

      final snapshot = await _messagesRef(conversationId)
          .where('isRead', isEqualTo: false)
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      var count = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final senderId = data?['senderId'] as String?;
        if (senderId != null && senderId != currentUid) {
          batch.update(doc.reference, {'isRead': true});
          count++;
        }
      }
      if (count > 0) {
        await batch.commit();
      }
    } catch (e) {
      print('Failed to mark messages as read: $e');
    }
  }

  // ── Delete Message ───────────────────────────────────────
  Future<void> deleteMessage(String conversationId, String messageId) async {
    if (conversationId.isEmpty || messageId.isEmpty) return;
    try {
      await _messagesRef(conversationId).doc(messageId).update({
        'text': 'This message was deleted',
        'type': 'deleted',
      });
    } catch (e) {
      print('Failed to delete message: $e');
    }
  }
}
