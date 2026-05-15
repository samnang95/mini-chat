import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/app/routes/app_routes.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/core/widgets/x_gradient_text.dart';
import 'package:mini_chat/core/widgets/x_scaffold.dart';
import 'package:mini_chat/core/widgets/x_text_field.dart';
import 'package:mini_chat/features/chat/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: XAppBar(
        leading: GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profileDetailPage),
          child: ClipOval(
            child: Image.asset(
              AppImages.image,
              width: 40,
              height: 35,
              fit: BoxFit.cover,
            ),
          ),
        ),
        titleWidget: XGradientText(
          StringTranslateExtension(LocaleKeys.appName).tr(),
          colors: const [Color.fromARGB(255, 8, 8, 11), AppColors.accent],
          style: AppTypography.heading1,
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: XTextField(
              hintText: StringTranslateExtension(LocaleKeys.searchConversations).tr(),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
              ),
              onChanged: controller.onSearchChanged,
            ),
          ),

          // ── Chat List ───────────────────────────────────
          Expanded(
            child: Obx(() {
              final convs = controller.filteredConversations;

              if (convs.isEmpty) {
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
                        'No conversations yet',
                        style: AppTypography.bodyLarge.copyWith(
                          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start chatting from Contacts!',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: controller.scrollController,
                itemCount: convs.length,
                separatorBuilder: (_, __) => Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                  height: 1,
                  indent: 80,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final conv = convs[index];
                  final otherUser = controller.getOtherUser(conv);
                  final otherUserId = controller.getOtherUserId(conv);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.profileDetailFriendPage),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: Text(
                            (otherUser?.name ?? '?')[0].toUpperCase(),
                            style: AppTypography.heading2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        otherUser?.name ?? 'Loading...',
                        style: AppTypography.subtitle1,
                      ),
                      subtitle: Text(
                        conv.lastMessage.isNotEmpty
                            ? conv.lastMessage
                            : 'Start a conversation',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        controller.formatTime(conv.lastMessageTime),
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkTextHint
                              : AppColors.textHint,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.chatDetailPage,
                          arguments: {
                            'conversationId': conv.id,
                            'name': otherUser?.name ?? '',
                            'avatar': otherUser?.avatarUrl ?? '',
                            'status': 'Online',
                            'otherUserId': otherUserId,
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
