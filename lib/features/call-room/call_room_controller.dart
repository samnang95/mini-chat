import 'dart:async';
import 'package:get/get.dart';

class CallRoomController extends GetxController {
  final name = ''.obs;
  final avatar = ''.obs;
  final isVideo = false.obs;
  
  final isMuted = false.obs;
  final isSpeaker = true.obs;
  final isVideoMuted = false.obs;
  
  final callDuration = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      name.value = args['name'] ?? 'Unknown';
      avatar.value = args['avatar'] ?? '';
      isVideo.value = args['isVideo'] ?? false;
      isVideoMuted.value = !isVideo.value;
      if (!isVideo.value) {
        isSpeaker.value = false;
      }
    }
    
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value++;
    });
  }

  void toggleMute() => isMuted.value = !isMuted.value;
  void toggleSpeaker() => isSpeaker.value = !isSpeaker.value;
  void toggleVideo() => isVideoMuted.value = !isVideoMuted.value;
  
  void endCall() {
    Get.back();
  }

  String get formattedDuration {
    final minutes = (callDuration.value / 60).floor().toString().padLeft(2, '0');
    final seconds = (callDuration.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
