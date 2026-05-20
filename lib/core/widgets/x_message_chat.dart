import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XMessageChat extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final bool isRead;
  final String type; // 'text', 'image', 'voice'
  final String? mediaUrl;
  final VoidCallback? onLongPress;

  const XMessageChat({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
    this.isRead = false,
    this.type = 'text',
    this.mediaUrl,
    this.onLongPress,
  });

  Widget _buildMessageContent(Color textColor, bool isDark) {
    if (type == 'image' && mediaUrl != null) {
      return GestureDetector(
        onTap: () {
          Get.to(
            () => Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Hero(
                        tag: mediaUrl!,
                        child: Image.network(
                          mediaUrl!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fullscreenDialog: true,
            transition: Transition.fadeIn,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Hero(
            tag: mediaUrl!,
            child: Image.network(
              mediaUrl!,
              fit: BoxFit.cover,
              width: 200,
              height: 150,
            ),
          ),
        ),
      );
    } else if (type == 'voice') {
      return _VoiceMessagePlayer(
        mediaUrl: mediaUrl!,
        textColor: textColor,
        isMe: isMe,
      );
    } else if (type == 'location') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  mediaUrl ?? 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=400&q=80',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 120,
                ),
                const Icon(Icons.location_on, color: Colors.red, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message.isNotEmpty ? message : "Shared Location",
            style: AppTypography.bodyMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    // Default to text
    return Text(
      message,
      style: AppTypography.bodyLarge.copyWith(
        color: textColor,
        fontStyle: type == 'deleted' ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine colors based on sender and theme
    final bubbleColor = type == 'image' 
        ? Colors.transparent 
        : (isMe
            ? AppColors.bubbleSent
            : (isDark ? AppColors.bubbleReceivedDark : AppColors.bubbleReceived));
    
    final textColor = isMe
        ? AppColors.bubbleSentText
        : (isDark ? AppColors.bubbleReceivedTextDark : AppColors.bubbleReceivedText);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: type == 'image' 
                ? EdgeInsets.zero 
                : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: type == 'image' ? null : BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
                bottomLeft: Radius.circular(isMe ? 16.0 : 4.0),
                bottomRight: Radius.circular(isMe ? 4.0 : 16.0),
              ),
            ),
            child: _buildMessageContent(textColor, isDark),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4.0),
                Icon(
                  isRead ? Icons.done_all : Icons.done,
                  size: 16.0,
                  color: isRead ? AppColors.primary : (isDark ? AppColors.darkTextHint : AppColors.textHint),
                ),
              ],
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _VoiceMessagePlayer extends StatefulWidget {
  final String mediaUrl;
  final Color textColor;
  final bool isMe;

  const _VoiceMessagePlayer({
    required this.mediaUrl,
    required this.textColor,
    required this.isMe,
  });

  @override
  State<_VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<_VoiceMessagePlayer> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setSourceUrl(widget.mediaUrl);
      final duration = await _audioPlayer.getDuration();
      if (duration != null && mounted) {
        setState(() {
          _duration = duration;
        });
      }
    } catch (e) {
      print('Error setting audio source: $e');
    }
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });
    
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.mediaUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: Icon(
            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: widget.textColor,
            size: 32,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: widget.textColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            width: _duration.inMilliseconds > 0
                ? 100 * (_position.inMilliseconds / _duration.inMilliseconds)
                : 0,
            height: 4,
            decoration: BoxDecoration(
              color: widget.textColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _duration.inSeconds > 0 
              ? (_isPlaying ? _formatDuration(_position) : _formatDuration(_duration))
              : "--:--",
          style: AppTypography.bodyMedium.copyWith(color: widget.textColor),
        ),
      ],
    );
  }
}