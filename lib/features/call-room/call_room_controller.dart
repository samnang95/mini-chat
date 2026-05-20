import 'dart:async';
import 'package:get/get.dart';
import 'package:mini_chat/app/config/env_config.dart';
import 'package:mini_chat/core/services/call_service.dart' as mini_chat_call_service;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class CallRoomController extends GetxController {
  final name = ''.obs;
  final avatar = ''.obs;
  final isVideo = false.obs;
  final channelName = ''.obs;
  
  final isMuted = false.obs;
  final isSpeaker = true.obs;
  final isVideoMuted = false.obs;
  
  final callDuration = 0.obs;
  Timer? _timer;

  // Agora variables
  final remoteUid = RxnInt();
  final localUserJoined = false.obs;
  late RtcEngine engine;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      name.value = args['name'] ?? 'Unknown';
      avatar.value = args['avatar'] ?? '';
      isVideo.value = args['isVideo'] ?? false;
      final convId = args['conversationId'] as String?;
      channelName.value = (convId != null && convId.isNotEmpty) 
          ? convId 
          : 'call_${DateTime.now().millisecondsSinceEpoch}';
      isVideoMuted.value = !isVideo.value;
      if (!isVideo.value) {
        isSpeaker.value = false;
      }

      // Log the call in Firestore if this is the caller
      final isCaller = args['isCaller'] ?? false;
      final uid = args['uid'];
      if (isCaller && uid != null && uid.isNotEmpty) {
        Get.find<mini_chat_call_service.CallService>().createCallRecord(
          receiverId: uid,
          media: isVideo.value ? 'video' : 'voice',
          conversationId: channelName.value,
        );
      }
    }
    
    _startTimer();
    _initAgora();
  }

  Future<void> _initAgora() async {
    try {
      print('Initializing Agora with App ID: ${EnvConfig.agoraAppId}');
      if (EnvConfig.agoraAppId.isEmpty) {
        Get.snackbar('Error', 'Agora App ID is missing in .env');
        return;
      }

      // Request permissions without blocking (prevents hanging on iOS Simulator)
      [Permission.microphone, Permission.camera].request().then((_) {
        print("Permissions requested");
      });

      // Create Agora Engine
      engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(
        appId: EnvConfig.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      // Register event handlers
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("Local user uid:${connection.localUid} joined the channel");
            localUserJoined.value = true;
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print("Remote user uid:$remoteUid joined the channel");
            this.remoteUid.value = remoteUid;
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            print("Remote user uid:$remoteUid left the channel");
            this.remoteUid.value = null;
            // End call if the other person leaves
            endCall();
          },
          onError: (ErrorCodeType err, String msg) {
            print("Agora Error: $err - $msg");
          },
        ),
      );

      // Enable video if this is a video call
      if (isVideo.value) {
        await engine.enableVideo();
        await engine.startPreview();
      } else {
        await engine.enableAudio();
      }

      // Join the channel (using empty string for token since we use Testing Mode)
      print('Joining channel: ${channelName.value}');
      await engine.joinChannel(
        token: '',
        channelId: channelName.value,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      // Set speakerphone (Wrapped in try/catch because Simulator might throw -3 ERR_INVALID_ARGUMENT)
      try {
        await engine.setEnableSpeakerphone(isSpeaker.value);
      } catch (e) {
        print('Warning: Could not set speakerphone: $e');
      }
    } catch (e) {
      print('Error initializing Agora: $e');
      Get.snackbar('Call Error', e.toString());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value++;
    });
  }

  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    await engine.muteLocalAudioStream(isMuted.value);
  }

  Future<void> toggleSpeaker() async {
    isSpeaker.value = !isSpeaker.value;
    await engine.setEnableSpeakerphone(isSpeaker.value);
  }

  Future<void> toggleVideo() async {
    isVideoMuted.value = !isVideoMuted.value;
    await engine.muteLocalVideoStream(isVideoMuted.value);
  }
  
  Future<void> endCall() async {
    _timer?.cancel();
    await engine.leaveChannel();
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
    engine.leaveChannel();
    engine.release();
    super.onClose();
  }
}
