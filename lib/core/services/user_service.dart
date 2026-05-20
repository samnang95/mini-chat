import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';

class UserService extends GetxService with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Current user profile (reactive) ────────────────────
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateOnlineStatus(true);
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      updateOnlineStatus(false);
    }
  }

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
      updateOnlineStatus(true); // Mark online immediately when loaded
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

  // ── Update Online Status ───────────────────────────────
  Future<void> updateOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    };

    try {
      await _usersCollection.doc(user.uid).update(updates);
      currentUser.value = currentUser.value?.copyWith(
        isOnline: isOnline,
        lastSeen: DateTime.now(),
      );
    } catch (e) {
      print('Failed to update online status: $e');
    }
  }

  // ── Update FCM Token ───────────────────────────────────
  Future<void> updateFcmToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _usersCollection.doc(user.uid).update({
        'fcmToken': token,
      });
      currentUser.value = currentUser.value?.copyWith(
        fcmToken: token,
      );
    } catch (e) {
      print('Failed to update FCM token: $e');
    }
  }

  // ── Get any user by ID ─────────────────────────────────
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // ── Block / Unblock User ───────────────────────────────
  Future<void> toggleBlockUser(String targetUid) async {
    final user = _auth.currentUser;
    if (user == null || currentUser.value == null) return;

    final currentBlocked = List<String>.from(currentUser.value!.blockedUsers);
    
    if (currentBlocked.contains(targetUid)) {
      currentBlocked.remove(targetUid);
    } else {
      currentBlocked.add(targetUid);
    }

    try {
      await _usersCollection.doc(user.uid).update({
        'blockedUsers': currentBlocked,
      });

      // Update local state
      currentUser.value = currentUser.value?.copyWith(
        blockedUsers: currentBlocked,
      );
    } catch (e) {
      print('Failed to block/unblock user: $e');
    }
  }

  // ── Clear on logout ────────────────────────────────────
  void clearUser() {
    updateOnlineStatus(false);
    currentUser.value = null;
  }
}
