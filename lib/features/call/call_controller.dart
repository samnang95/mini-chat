import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/services/call_service.dart';
import 'package:mini_chat/core/services/user_service.dart';
import 'package:mini_chat/data/call/models/call_model.dart';
import 'package:mini_chat/data/auth/models/user_model.dart';

class CallController extends GetxController {
  final isShow = false.obs;
  final scrollController = ScrollController();
  
  final CallService _callService = Get.find<CallService>();
  final UserService _userService = Get.find<UserService>();

  // Use a map to cache users we've already fetched
  final userCache = <String, UserModel>{}.obs;

  // The actual stream of calls from Firestore
  final calls = <CallModel>[].obs;
  StreamSubscription? _callsSub;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.offset > 0) {
        if (!isShow.value) isShow.value = true;
      } else {
        if (isShow.value) isShow.value = false;
      }
    });

    // Listen to call history
    _callsSub = _callService.getCallHistory().listen((callList) {
      calls.value = callList;
      
      // Fetch user data for any new participants we haven't cached
      for (final call in callList) {
        final otherUid = getOtherUid(call);
        if (otherUid.isNotEmpty && !userCache.containsKey(otherUid)) {
          _fetchUser(otherUid);
        }
      }
    });
  }

  String getOtherUid(CallModel call) {
    final currentUid = _userService.currentUser.value?.uid ?? '';
    return call.callerId == currentUid ? call.receiverId : call.callerId;
  }

  UserModel? getOtherUser(CallModel call) {
    return userCache[getOtherUid(call)];
  }

  bool isIncoming(CallModel call) {
    final currentUid = _userService.currentUser.value?.uid ?? '';
    return call.receiverId == currentUid;
  }

  Future<void> _fetchUser(String uid) async {
    // Prevent multiple simultaneous fetches for the same ID
    userCache[uid] = UserModel(
      uid: '',
      name: 'Loading...',
      email: '',
      createdAt: null as dynamic, // Temporary placeholder
    );

    final user = await _userService.getUserById(uid);
    if (user != null) {
      userCache[uid] = user;
    }
  }

  // Get formatted time (simplified for now)
  String getFormattedTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      if (now.day != time.day) return 'Yesterday';
      return 'Today, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${time.day}/${time.month}';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    _callsSub?.cancel();
    super.onClose();
  }
}