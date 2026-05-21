import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final String type; // 'text', 'image', 'voice', 'location'
  final String? mediaUrl;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, List<String>> reactions; // emoji -> [userIds]

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.type = 'text',
    this.mediaUrl,
    required this.createdAt,
    this.isRead = false,
    this.reactions = const {},
  });

  bool get hasReactions => reactions.isNotEmpty && reactions.values.any((v) => v.isNotEmpty);

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse reactions: { "❤️": ["uid1", "uid2"], "😂": ["uid3"] }
    final rawReactions = data['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = rawReactions.map(
      (key, value) => MapEntry(key, List<String>.from(value ?? [])),
    );

    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: data['type'] ?? 'text',
      mediaUrl: data['mediaUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      reactions: reactions,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
      'mediaUrl': mediaUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'reactions': reactions,
    };
  }
}
