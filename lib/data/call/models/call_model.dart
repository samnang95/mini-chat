import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String id;
  final String callerId;
  final String receiverId;
  final String type; // 'incoming' or 'outgoing' relative to the user querying, but in DB we store who called who.
  final String media; // 'voice' or 'video'
  final String status; // 'ringing', 'accepted', 'rejected', 'ended'
  final String? conversationId;
  final bool missed;
  final DateTime createdAt;
  final int? durationSeconds;

  const CallModel({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.media,
    this.status = 'ended',
    this.conversationId,
    this.missed = false,
    required this.createdAt,
    this.durationSeconds,
  });

  factory CallModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CallModel(
      id: doc.id,
      callerId: data['callerId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      type: data['type'] ?? 'voice', // usually 'voice' or 'video'
      media: data['media'] ?? 'voice',
      status: data['status'] ?? 'ended',
      conversationId: data['conversationId'],
      missed: data['missed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationSeconds: data['durationSeconds'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'type': type,
      'media': media,
      'status': status,
      'conversationId': conversationId,
      'missed': missed,
      'createdAt': Timestamp.fromDate(createdAt),
      'durationSeconds': durationSeconds,
    };
  }
}
