import 'package:flutter/material.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XMessageChat extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final bool isRead;
  final String type; // 'text', 'image', 'voice'
  final String? mediaUrl;

  const XMessageChat({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
    this.isRead = false,
    this.type = 'text',
    this.mediaUrl,
  });

  Widget _buildMessageContent(Color textColor, bool isDark) {
    if (type == 'image' && mediaUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          mediaUrl!,
          fit: BoxFit.cover,
          width: 200,
          height: 150,
        ),
      );
    } else if (type == 'voice') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle_fill, color: textColor, size: 32),
          const SizedBox(width: 8),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text("0:12", style: AppTypography.bodyMedium.copyWith(color: textColor)),
        ],
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
      style: AppTypography.bodyLarge.copyWith(color: textColor),
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

    return Padding(
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
    );
  }
}