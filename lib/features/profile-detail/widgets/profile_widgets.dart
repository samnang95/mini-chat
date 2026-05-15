import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_dimens.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

// ── Action Button Widget ──────────────────────────────────
class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: AppDimens.iconMedium),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Tile Widget ──────────────────────────────────────
class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final bool showEdit;
  final VoidCallback? onEdit;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.showEdit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showEdit ? onEdit : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.spacing16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.background,
          borderRadius: AppDimens.borderRadiusMedium,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppDimens.iconMedium, color: AppColors.primary),
            const SizedBox(width: AppDimens.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (showEdit)
              Icon(
                Icons.edit_outlined,
                size: AppDimens.iconSmall,
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Setting Tile Widget ──────────────────────────────────
class ProfileSettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileSettingTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isDark,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.spacing16,
          horizontal: AppDimens.spacing16,
        ),
        margin: const EdgeInsets.only(bottom: AppDimens.spacing8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.background,
          borderRadius: AppDimens.borderRadiusMedium,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppDimens.iconMedium, color: color),
            const SizedBox(width: AppDimens.spacing12),
            Text(label, style: AppTypography.bodyMedium.copyWith(color: color)),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: AppDimens.iconMedium,
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Media Grid ────────────────────────────────────
class ProfileSharedMediaGrid extends StatelessWidget {
  final bool isDark;

  const ProfileSharedMediaGrid({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppDimens.spacing8,
        mainAxisSpacing: AppDimens.spacing8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.background,
            borderRadius: AppDimens.borderRadiusMedium,
          ),
          child: Icon(
            Icons.image_outlined,
            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            size: AppDimens.iconLarge,
          ),
        );
      },
    );
  }
}

// ── Profile Header ───────────────────────────────────────
class ProfileHeader extends StatelessWidget {
  final bool isDark;
  final Widget avatarWidget;
  final Widget nameWidget;
  final Widget usernameWidget;

  const ProfileHeader({
    super.key,
    required this.isDark,
    required this.avatarWidget,
    required this.nameWidget,
    required this.usernameWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Background gradient
        Container(
          height: Get.height * 0.32,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [AppColors.primaryDarker, AppColors.darkBackground]
                  : [AppColors.primaryLight, AppColors.primary],
            ),
          ),
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: AppDimens.spacing16,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: AppDimens.iconSmall,
              color: Colors.white,
            ),
          ),
        ),

        // More options button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: AppDimens.spacing16,
          child: const Icon(
            Icons.more_vert_rounded,
            size: AppDimens.iconMedium,
            color: Colors.white,
          ),
        ),

        // Avatar + Name
        Positioned(
          bottom: -20,
          child: Column(
            children: [
              avatarWidget,
              const SizedBox(height: AppDimens.spacing8),
              nameWidget,
              usernameWidget,
            ],
          ),
        ),
      ],
    );
  }
}
