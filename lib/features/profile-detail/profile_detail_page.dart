import 'package:easy_localization/easy_localization.dart';
import 'package:mini_chat/features/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/constants/app_images.dart';
import 'package:mini_chat/core/constants/locale_keys.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_dimens.dart';
import 'package:mini_chat/core/theme/app_typography.dart';
import 'package:mini_chat/features/profile-detail/profile_detail_controller.dart';
import 'package:mini_chat/features/profile-detail/widgets/profile_widgets.dart';

class ProfileDetailPage extends GetView<ProfileDetailController> {
  const ProfileDetailPage({super.key});

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
                nameWidget: _buildEditableName(),
                usernameWidget: _buildUsername(),
              ),

              // ── Action Bar (Edit + Change Avatar) ──────────
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
                          icon: Icons.edit_outlined,
                          label: StringTranslateExtension(
                            LocaleKeys.profileEditProfile,
                          ).tr(),
                          color: AppColors.primary,
                          onTap: controller.editName,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                        ProfileActionButton(
                          icon: Icons.camera_alt_outlined,
                          label: StringTranslateExtension(
                            LocaleKeys.profileChangeAvatar,
                          ).tr(),
                          color: AppColors.info,
                          onTap: controller.changeAvatar,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Info Section ──────────────────────────────
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
                      showEdit: true,
                      onEdit: controller.editBio,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ProfileInfoTile(
                      icon: Icons.phone_outlined,
                      label: StringTranslateExtension(
                        LocaleKeys.profilePhone,
                      ).tr(),
                      value: controller.phone.value,
                      isDark: isDark,
                      showEdit: true,
                      onEdit: controller.editPhone,
                    ),
                    SizedBox(height: Get.height * 0.02),
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
                    ProfileSharedMediaGrid(
                      isDark: isDark,
                      mediaUrls: const [],
                    ),

                    SizedBox(height: Get.height * 0.02),

                    // ── Settings ─────────────────────────────
                    ProfileSettingTile(
                      icon: Icons.lock_outline_rounded,
                      label: StringTranslateExtension(
                        LocaleKeys.profileChangePassword,
                      ).tr(),
                      isDark: isDark,
                      onTap: () {
                        // TODO: Change password
                      },
                    ),
                    ProfileSettingTile(
                      icon: Icons.logout_rounded,
                      label: StringTranslateExtension(
                        LocaleKeys.profileLogout,
                      ).tr(),
                      isDark: isDark,
                      isDestructive: true,
                      onTap: () {
                        Get.find<AuthController>().logout();
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

  // ── Avatar with camera overlay ─────────────────────────
  Widget _buildAvatar(bool isDark) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkBackground : AppColors.white,
          ),
          child: Obx(() {
            if (controller.isUploading.value) {
              return const CircleAvatar(
                radius: 50,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return CircleAvatar(
              radius: 50,
              backgroundImage: controller.avatarUrl.value.isNotEmpty
                  ? NetworkImage(controller.avatarUrl.value)
                  : AssetImage(AppImages.image) as ImageProvider,
            );
          }),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: GestureDetector(
            onTap: controller.changeAvatar,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBackground : AppColors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Editable Name ──────────────────────────────────────
  Widget _buildEditableName() {
    return GestureDetector(
      onTap: controller.editName,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Text(
              controller.name.value,
              style: AppTypography.heading2.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.edit_rounded,
            size: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ],
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
