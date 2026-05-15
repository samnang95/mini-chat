import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;
  final String phone;
  final String avatarUrl;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.username = '',
    this.bio = '',
    this.phone = '',
    this.avatarUrl = '',
    required this.createdAt,
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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ── CopyWith ───────────────────────────────────────────
  UserModel copyWith({
    String? name,
    String? username,
    String? bio,
    String? phone,
    String? avatarUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}
