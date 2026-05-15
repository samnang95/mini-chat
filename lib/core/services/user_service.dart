import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';

class UserService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Current user profile (reactive) ────────────────────
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // ── Collection reference ───────────────────────────────
  CollectionReference get _usersCollection => _firestore.collection('users');

  // ── Create user profile on register ────────────────────
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    final user = UserModel(
      uid: uid,
      name: name,
      email: email,
      username: '@${name.toLowerCase().replaceAll(' ', '_')}',
      bio: '',
      phone: '',
      avatarUrl: '',
      createdAt: DateTime.now(),
    );

    await _usersCollection.doc(uid).set(user.toFirestore());
    currentUser.value = user;
  }

  // ── Load current user profile ──────────────────────────
  Future<void> loadCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _usersCollection.doc(user.uid).get();
    if (doc.exists) {
      currentUser.value = UserModel.fromFirestore(doc);
    }
  }

  // ── Update profile fields ──────────────────────────────
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? phone,
    String? avatarUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (bio != null) updates['bio'] = bio;
    if (phone != null) updates['phone'] = phone;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

    if (updates.isEmpty) return;

    await _usersCollection.doc(user.uid).update(updates);

    // Update local state
    currentUser.value = currentUser.value?.copyWith(
      name: name,
      bio: bio,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  // ── Get any user by ID ─────────────────────────────────
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // ── Clear on logout ────────────────────────────────────
  void clearUser() {
    currentUser.value = null;
  }
}
