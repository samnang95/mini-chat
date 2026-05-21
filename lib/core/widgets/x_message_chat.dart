import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XMessageChat extends StatefulWidget {
  final bool isMe;
  final String message;
  final String time;
  final bool isRead;
  final String type; // 'text', 'image', 'voice'
  final String? mediaUrl;
  final VoidCallback? onLongPress;
  final Map<String, List<String>> reactions;
  final void Function(String emoji)? onReactionTap;

  const XMessageChat({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
    this.isRead = false,
    this.type = 'text',
    this.mediaUrl,
    this.onLongPress,
    this.reactions = const {},
    this.onReactionTap,
  });

  @override
  State<XMessageChat> createState() => _XMessageChatState();
}

class _XMessageChatState extends State<XMessageChat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: Offset(widget.isMe ? 0.15 : -0.15, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  bool get _hasReactions =>
      widget.reactions.isNotEmpty &&
      widget.reactions.values.any((v) => v.isNotEmpty);

  List<Widget> _buildReactionBadges(bool isDark) {
    final activeReactions = widget.reactions.entries
        .where((e) => e.value.isNotEmpty)
        .toList();

    if (activeReactions.isEmpty) return [];

    return [
      const SizedBox(height: 2),
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: activeReactions.map((entry) {
          final emoji = entry.key;
          final count = entry.value.length;

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: GestureDetector(
              onTap: () => widget.onReactionTap?.call(emoji),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.15)
                        : Colors.black.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    if (count > 1) ...[
                      const SizedBox(width: 3),
                      Text(
                        '$count',
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ];
  }

  Widget _buildMessageContent(Color textColor, bool isDark) {
    if (widget.type == 'image' && widget.mediaUrl != null) {
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
                        tag: widget.mediaUrl!,
                        child: Image.network(
                          widget.mediaUrl!,
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
            tag: widget.mediaUrl!,
            child: Image.network(
              widget.mediaUrl!,
              fit: BoxFit.cover,
              width: 200,
              height: 150,
            ),
          ),
        ),
      );
    } else if (widget.type == 'voice') {
      return _VoiceMessagePlayer(
        mediaUrl: widget.mediaUrl!,
        textColor: textColor,
        isMe: widget.isMe,
      );
    } else if (widget.type == 'location') {
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
                  widget.mediaUrl ?? 'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=400&q=80',
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
            widget.message.isNotEmpty ? widget.message : "Shared Location",
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
      widget.message,
      style: AppTypography.bodyLarge.copyWith(
        color: textColor,
        fontStyle: widget.type == 'deleted' ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine colors based on sender and theme
    final bubbleColor = widget.type == 'image' 
        ? Colors.transparent 
        : (widget.isMe
            ? AppColors.bubbleSent
            : (isDark ? AppColors.bubbleReceivedDark : AppColors.bubbleReceived));
    
    final textColor = widget.isMe
        ? AppColors.bubbleSentText
        : (isDark ? AppColors.bubbleReceivedTextDark : AppColors.bubbleReceivedText);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onLongPress: widget.onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: widget.type == 'image' 
                    ? EdgeInsets.zero 
                    : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: widget.type == 'image' ? null : BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0),
                    bottomLeft: Radius.circular(widget.isMe ? 16.0 : 4.0),
                    bottomRight: Radius.circular(widget.isMe ? 4.0 : 16.0),
                  ),
                ),
                child: _buildMessageContent(textColor, isDark),
              ),
              // ── Reaction Badges ──
              if (_hasReactions) ..._buildReactionBadges(isDark),
              const SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.time,
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                  ),
                  if (widget.isMe) ...[
                    const SizedBox(width: 4.0),
                    Icon(
                      widget.isRead ? Icons.done_all : Icons.done,
                      size: 16.0,
                      color: widget.isRead ? AppColors.primary : (isDark ? AppColors.darkTextHint : AppColors.textHint),
                    ),
                  ],
                ],
              ),
            ],
          ),
          ),
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