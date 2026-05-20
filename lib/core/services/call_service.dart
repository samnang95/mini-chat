import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mini_chat/data/call/models/call_model.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/services/user_service.dart';

class CallService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _incomingCallSubscription;

  String get _currentUid => _auth.currentUser?.uid ?? '';

  CollectionReference get _callsRef => _firestore.collection('calls');

  @override
  void onInit() {
    super.onInit();
    _listenForIncomingCalls();
  }

  void _listenForIncomingCalls() {
    // Listen for new calls where the current user is the receiver and status is 'ringing'
    _auth.authStateChanges().listen((user) {
      _incomingCallSubscription?.cancel();
      if (user != null) {
        _incomingCallSubscription = _callsRef
            .where('receiverId', isEqualTo: user.uid)
            .where('status', isEqualTo: 'ringing')
            .snapshots()
            .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final call = CallModel.fromFirestore(change.doc);
              // Show incoming call dialog
              _showIncomingCallDialog(call);
            }
          }
        });
      }
    });
  }

  Future<void> _showIncomingCallDialog(CallModel call) async {
    // Fetch caller info
    final callerUser = await Get.find<UserService>().getUserById(call.callerId);
    final callerName = callerUser?.name ?? 'Unknown Caller';
    final callerAvatar = callerUser?.avatarUrl ?? '';

    // Show persistent dialog
    if (Get.isDialogOpen == false) {
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: callerAvatar.isNotEmpty ? NetworkImage(callerAvatar) : null,
                child: callerAvatar.isEmpty ? Text(callerName[0].toUpperCase(), style: const TextStyle(fontSize: 32)) : null,
              ),
              const SizedBox(height: 16),
              Text(
                '$callerName is calling...',
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Text(
                call.media == 'video' ? 'Video Call' : 'Voice Call',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // Reject Button
            GestureDetector(
              onTap: () async {
                Get.back();
                await updateCallStatus(call.id, 'rejected');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                child: const Icon(Icons.call_end, color: Colors.white, size: 32),
              ),
            ),
            // Accept Button
            GestureDetector(
              onTap: () async {
                Get.back();
                await updateCallStatus(call.id, 'accepted');
                
                // Navigate to Call Room
                Get.toNamed(
                  AppRoutes.callRoomPage,
                  arguments: {
                    'uid': call.callerId, 
                    'name': callerName,
                    'avatar': callerAvatar,
                    'isVideo': call.media == 'video',
                    'conversationId': call.conversationId ?? 'call_${call.id}',
                    'isCaller': false,
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.call, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  Future<void> updateCallStatus(String callId, String status) async {
    await _callsRef.doc(callId).update({'status': status});
  }

  // Stream call history involving the current user
  Stream<List<CallModel>> getCallHistory() {
    if (_currentUid.isEmpty) return const Stream.empty();

    return _callsRef
        .where('participants', arrayContains: _currentUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CallModel.fromFirestore(doc)).toList();
    });
  }

  // Create a new call record (Returns the Call ID)
  Future<String?> createCallRecord({
    required String receiverId,
    required String media, // 'voice' or 'video'
    String? conversationId,
  }) async {
    if (_currentUid.isEmpty) return null;

    final call = CallModel(
      id: '',
      callerId: _currentUid,
      receiverId: receiverId,
      type: 'outgoing', 
      media: media,
      status: 'ringing',
      conversationId: conversationId,
      createdAt: DateTime.now(),
    );

    final data = call.toFirestore();
    data['participants'] = [_currentUid, receiverId]; // Used for easy querying

    final docRef = await _callsRef.add(data);
    return docRef.id;
  }
  
  @override
  void onClose() {
    _incomingCallSubscription?.cancel();
    super.onClose();
  }
}
