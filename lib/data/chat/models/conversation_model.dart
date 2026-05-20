import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final List<String> typingUsers;
  final Map<String, int> unreadCounts;

  const ConversationModel({
    required this.id,
    required this.participants,
    this.lastMessage = '',
    required this.lastMessageTime,
    this.lastMessageSenderId = '',
    this.typingUsers = const [],
    this.unreadCounts = const {},
  });

  factory ConversationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversationModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      typingUsers: List<String>.from(data['typingUsers'] ?? []),
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageSenderId': lastMessageSenderId,
      'typingUsers': typingUsers,
      'unreadCounts': unreadCounts,
    };
  }
}
