import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/widgets/x_message_chat.dart';
import 'package:mini_chat/core/widgets/x_chat_date_header.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/features/chat-detail/chat_detail_controller.dart';

class ChatDetailPage extends GetView<ChatDetailController> {
  const ChatDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: XAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        titleWidget: Obx(() {
          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profileDetailFriendPage),
            child: Row(
              children: [
                ClipOval(
                  child: controller.chatAvatar.value.isNotEmpty
                      ? Image.network(
                          controller.chatAvatar.value,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppImages.image,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.chatName.value,
                      style: AppTypography.subtitle1.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : Colors.black,
                      ),
                    ),
                    Text(
                      controller.chatStatus.value,
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        action: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.video_call_rounded,
                color: isDark ? AppColors.darkTextSecondary : Colors.black45,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.phone,
                color: isDark ? AppColors.darkTextSecondary : Colors.black45,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 64,
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a message to start the conversation!',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          itemCount: controller.messages.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const XChatDateHeader(date: "Today");
            }
            final msg = controller.messages[index - 1];
            final isMe = controller.isMyMessage(msg);
            return XMessageChat(
              isMe: isMe,
              message: msg.text,
              time: _formatTime(msg.createdAt),
              isRead: msg.isRead,
              type: msg.type,
              mediaUrl: msg.mediaUrl,
            );
          },
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.plus,
                  color: isDark ? AppColors.darkTextHint : Colors.grey,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                  cursorColor: AppColors.primary,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.sendMessage(),
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkDivider : AppColors.divider,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: AppColors.primary,
                ),
                onPressed: controller.sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
