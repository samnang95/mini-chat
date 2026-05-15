import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_dimens.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/features/profile-detail/profile_detail_controller.dart';
import 'package:mini_chat/features/profile-detail/widgets/profile_widgets.dart';

class ProfileDetailFriendPage extends GetView<ProfileDetailController> {
  const ProfileDetailFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              // ── Header ─────────────────────────────────────
              ProfileHeader(
                isDark: isDark,
                avatarWidget: _buildAvatar(isDark),
                nameWidget: _buildName(),
                usernameWidget: _buildUsername(),
              ),

              // ── Action Bar (Message, Audio, Video) ─────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing24,
                ),
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spacing16,
                      horizontal: AppDimens.spacing24,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: AppDimens.borderRadiusXL,
                      boxShadow: isDark ? null : AppDimens.shadowMedium,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: StringTranslateExtension(
                            LocaleKeys.profileMessage,
                          ).tr(),
                          color: AppColors.primary,
                          onTap: controller.onMessageTap,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                        ProfileActionButton(
                          icon: Icons.call_outlined,
                          label: StringTranslateExtension(
                            LocaleKeys.profileAudioCall,
                          ).tr(),
                          color: AppColors.success,
                          onTap: controller.onAudioCallTap,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                        ProfileActionButton(
                          icon: Icons.videocam_outlined,
                          label: StringTranslateExtension(
                            LocaleKeys.profileVideoCall,
                          ).tr(),
                          color: AppColors.info,
                          onTap: controller.onVideoCallTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Info Section (Read-only) ───────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileInfoTile(
                      icon: Icons.info_outline_rounded,
                      label: StringTranslateExtension(
                        LocaleKeys.profileBio,
                      ).tr(),
                      value: controller.bio.value,
                      isDark: isDark,
                    ),
                    ProfileInfoTile(
                      icon: Icons.phone_outlined,
                      label: StringTranslateExtension(
                        LocaleKeys.profilePhone,
                      ).tr(),
                      value: controller.phone.value,
                      isDark: isDark,
                    ),
                    ProfileInfoTile(
                      icon: Icons.email_outlined,
                      label: StringTranslateExtension(
                        LocaleKeys.profileEmail,
                      ).tr(),
                      value: controller.email.value,
                      isDark: isDark,
                    ),
                    SizedBox(height: Get.height * 0.02),

                    // ── Shared Media ─────────────────────────
                    Text(
                      StringTranslateExtension(
                        LocaleKeys.profileSharedMedia,
                      ).tr(),
                      style: AppTypography.subtitle1.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacing12),
                    ProfileSharedMediaGrid(isDark: isDark),

                    SizedBox(height: Get.height * 0.03),

                    // ── Mute & Block ─────────────────────────
                    Obx(
                      () => ProfileSettingTile(
                        icon: controller.isMuted.value
                            ? Icons.notifications_off_outlined
                            : Icons.notifications_outlined,
                        label: controller.isMuted.value
                            ? StringTranslateExtension(
                                LocaleKeys.profileMuted,
                              ).tr()
                            : StringTranslateExtension(
                                LocaleKeys.profileMuteNotifications,
                              ).tr(),
                        isDark: isDark,
                        onTap: controller.toggleMute,
                      ),
                    ),
                    ProfileSettingTile(
                      icon: Icons.block_rounded,
                      label: StringTranslateExtension(
                        LocaleKeys.profileBlockUser,
                      ).tr(),
                      isDark: isDark,
                      isDestructive: true,
                      onTap: () {
                        // TODO: Block user
                      },
                    ),

                    SizedBox(height: Get.height * 0.05),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ── Avatar (read-only, no camera overlay) ──────────────
  Widget _buildAvatar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkBackground : AppColors.white,
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(AppImages.image),
      ),
    );
  }

  // ── Name (read-only) ───────────────────────────────────
  Widget _buildName() {
    return Obx(
      () => Text(
        controller.name.value,
        style: AppTypography.heading2.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  // ── Username ───────────────────────────────────────────
  Widget _buildUsername() {
    return Obx(
      () => Text(
        controller.username.value,
        style: AppTypography.bodySmall.copyWith(
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
