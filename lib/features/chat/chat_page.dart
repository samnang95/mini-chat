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
import 'package:mini_chat/core/services/user_service.dart';
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
          child: Obx(() {
            final avatarUrl = Get.find<UserService>().currentUser.value?.avatarUrl ?? '';
            return ClipOval(
              child: avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      width: 40,
                      height: 35,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      AppImages.image,
                      width: 40,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
            );
          }),
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

          // ── Scroll Shadow Divider ────────────────────────
          Obx(() {
            return Container(
              height: 1,
              decoration: BoxDecoration(
                color: controller.isShow.value
                    ? (isDark ? AppColors.darkDivider : AppColors.divider)
                    : Colors.transparent,
                boxShadow: controller.isShow.value
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ]
                    : null,
              ),
            );
          }),

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

              return RefreshIndicator(
                onRefresh: controller.refreshConversations,
                child: ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
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

                  // Staggered animation: each item fades + slides in
                  final delay = Duration(milliseconds: 50 * (index < 10 ? index : 0));
                  return TweenAnimationBuilder<double>(
                    key: ValueKey(conv.id),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.profileDetailFriendPage,
                            arguments: {
                              'uid': otherUserId,
                              'conversationId': conv.id,
                            },
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            backgroundImage: (otherUser?.avatarUrl ?? '').isNotEmpty
                                ? NetworkImage(otherUser!.avatarUrl)
                                : null,
                            child: (otherUser?.avatarUrl ?? '').isEmpty
                                ? Text(
                                    (otherUser?.name ?? '?')[0].toUpperCase(),
                                    style: AppTypography.heading2.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  )
                                : null,
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
                        trailing: Builder(
                          builder: (context) {
                            final unreadCount = controller.getUnreadCount(conv);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  controller.formatTime(conv.lastMessageTime),
                                  style: AppTypography.caption.copyWith(
                                    color: unreadCount > 0 
                                        ? AppColors.primary 
                                        : (isDark ? AppColors.darkTextHint : AppColors.textHint),
                                    fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                if (unreadCount > 0) ...[
                                  const SizedBox(height: 6),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.elasticOut,
                                    builder: (context, value, child) => Transform.scale(
                                      scale: value,
                                      child: child,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                                        style: AppTypography.caption.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }
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
                    ),
                  );
                },
              ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
