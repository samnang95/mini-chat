import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/features/call-room/call_room_controller.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallRoomPage extends GetView<CallRoomController> {
  const CallRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Deep dark background
      body: Stack(
        children: [
          // Background Blur
          Positioned.fill(
            child: Obx(() {
              if (controller.avatar.value.isNotEmpty) {
                return Image.network(
                  controller.avatar.value,
                  fit: BoxFit.cover,
                );
              }
              return Container(color: const Color(0xFF1E1E2C));
            }),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Top Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 36),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'End-to-end encrypted',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(width: 48), // balance header
                  ],
                ),
                
                // Avatar & Info (or Video View)
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    if (controller.isVideo.value) {
                      // Video Call Layout
                      return Stack(
                        children: [
                          // Remote Video (Full Screen)
                          Positioned.fill(
                            child: controller.remoteUid.value != null
                                ? AgoraVideoView(
                                    controller: VideoViewController.remote(
                                      rtcEngine: controller.engine,
                                      canvas: VideoCanvas(uid: controller.remoteUid.value),
                                      connection: RtcConnection(channelId: controller.channelName.value),
                                    ),
                                  )
                                : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                          ),
                          
                          // Local Video (Small box in corner)
                          if (controller.localUserJoined.value && !controller.isVideoMuted.value)
                            Positioned(
                              top: 20,
                              right: 20,
                              width: 100,
                              height: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black54,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AgoraVideoView(
                                    controller: VideoViewController(
                                      rtcEngine: controller.engine,
                                      canvas: const VideoCanvas(uid: 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          // Call Info overlay
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Text(
                                  controller.name.value,
                                  style: AppTypography.heading2.copyWith(color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.remoteUid.value != null ? controller.formattedDuration : 'Connecting...',
                                  style: AppTypography.subtitle1.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Channel: ${controller.channelName.value}',
                                  style: const TextStyle(color: Colors.white24, fontSize: 10, shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Voice Call Layout
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                              image: controller.avatar.value.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(controller.avatar.value),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: controller.avatar.value.isEmpty
                                ? Center(
                                    child: Text(
                                      controller.name.value.isNotEmpty
                                          ? controller.name.value[0].toUpperCase()
                                          : '?',
                                      style: AppTypography.heading1.copyWith(
                                        color: Colors.white,
                                        fontSize: 64,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            controller.name.value,
                            style: AppTypography.heading2.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.remoteUid.value != null ? controller.formattedDuration : 'Calling...',
                            style: AppTypography.subtitle1.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Channel: ${controller.channelName.value}',
                            style: const TextStyle(color: Colors.white24, fontSize: 10),
                          ),
                        ],
                      );
                    }
                  }),
                ),

                // Call Controls
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildControlButton(
                        icon: Icons.mic_off_rounded,
                        isToggled: controller.isMuted,
                        onTap: controller.toggleMute,
                      ),
                      Obx(() {
                        if (controller.isVideo.value) {
                          return _buildControlButton(
                            icon: Icons.videocam_off_rounded,
                            isToggled: controller.isVideoMuted,
                            onTap: controller.toggleVideo,
                          );
                        } else {
                          return _buildControlButton(
                            icon: Icons.volume_up_rounded,
                            isToggled: controller.isSpeaker,
                            onTap: controller.toggleSpeaker,
                          );
                        }
                      }),
                      _buildEndCallButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required RxBool isToggled,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final active = isToggled.value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: active ? Colors.black : Colors.white,
            size: 28,
          ),
        ),
      );
    });
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: controller.endCall,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.call_end_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
