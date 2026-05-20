import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;
  final String phone;
  final String avatarUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final List<String> blockedUsers;
  final DateTime createdAt;
  final String? fcmToken;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.username = '',
    this.bio = '',
    this.phone = '',
    this.avatarUrl = '',
    this.isOnline = false,
    this.lastSeen,
    this.blockedUsers = const [],
    required this.createdAt,
    this.fcmToken,
  });

  // ── From Firestore ─────────────────────────────────────
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      bio: data['bio'] ?? '',
      phone: data['phone'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      isOnline: data['isOnline'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmToken: data['fcmToken'] as String?,
    );
  }

  // ── To Firestore ───────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'blockedUsers': blockedUsers,
      'createdAt': Timestamp.fromDate(createdAt),
      'fcmToken': fcmToken,
    };
  }

  // ── CopyWith ───────────────────────────────────────────
  UserModel copyWith({
    String? name,
    String? username,
    String? bio,
    String? phone,
    String? avatarUrl,
    bool? isOnline,
    DateTime? lastSeen,
    List<String>? blockedUsers,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
